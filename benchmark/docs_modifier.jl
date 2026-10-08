# A user-written modifier, timed by the benchmark matrix (cases
# `custom_modifier` and `custom_modifier_pullback`) to compare the local
# derivative with a hand-written `pullback!`.
#
# Saturation caps each value smoothly at `κ`: `y = v κ / (κ + v)`. It is
# pointwise and keeps no state. `Saturation` implements `forward` only, so
# automatic differentiation goes through it; `SaturationPullback` is the
# same modifier with a hand-written `pullback!`.
using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR

"Saturation at `κ`, with `forward` only."
struct Saturation{K}
    κ::K
end

"Saturation at `κ`, with `forward` and a hand-written `pullback!`."
struct SaturationPullback{K}
    κ::K
end

const _Saturating = Union{Saturation, SaturationPullback}

CR.ispointwise(::_Saturating) = true
CR.forward(::_Saturating, ::CR.Init, s, history) = (fill!(s, 0); nothing)
CR.forward(m::_Saturating, ::CR.Step, v, s, t, k) = (v * m.κ / (m.κ + v), s)

# The cotangents of `y = v κ / (κ + v)`: ∂y/∂v = κ² / (κ + v)², and
# ∂y/∂κ = v² / (κ + v)², accumulated into the mirror of the field `κ`.
CR.pullback!(grads, ::SaturationPullback, ::CR.Init, s, history) = nothing
function CR.pullback!(grads, m::SaturationPullback, ::CR.Step, v, s, t, k)
    d = inv(m.κ + v)^2
    κ̄ = grads.piece === nothing ? nothing : grads.piece.κ
    κ̄ === nothing || (κ̄[] += grads.v * v^2 * d)
    return grads.v * m.κ^2 * d, grads.s
end
