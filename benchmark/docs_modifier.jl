# A user-written modifier, timed by the benchmark matrix (cases
# `custom_modifier` and `custom_modifier_pullback`) to compare the local
# derivative with a hand-written `pullback!`.
#
# Saturation caps each value smoothly at `κ`: `y = v κ / (κ + v)`. It is
# pointwise and keeps no state. `Saturation` implements `forward!` only, so
# automatic differentiation goes through it; `SaturationPullback` is the
# same modifier with a hand-written `pullback!`. The tutorial "Writing your
# own modifier" shows this code; keep the two the same.
using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR

"Saturation at `κ`, with `forward!` only."
struct Saturation{K}
    κ::K
end

"Saturation at `κ`, with `forward!` and a hand-written `pullback!`."
struct SaturationPullback{K}
    κ::K
end

const _Saturating = Union{Saturation, SaturationPullback}

CR.blocks(::_Saturating) = (1, 1)
function CR.forward!(m::_Saturating, ::CR.Step, v, s, t)
    for k in eachindex(v)
        v[k] = v[k] * m.κ / (m.κ + v[k])
    end
    return nothing
end

# The cotangents of `y = v κ / (κ + v)`: ∂y/∂v = κ² / (κ + v)², and
# ∂y/∂κ = v² / (κ + v)², accumulated into the mirror of the field `κ`.
function CR.pullback!(grads, m::SaturationPullback, ::CR.Step, v, s, t)
    v̄ = grads.v
    for k in eachindex(v, v̄)
        d = inv(m.κ + v[k])^2
        CR.add_cotangent!(CR.cotangent(grads.piece, :κ), v̄[k] * v[k]^2 * d)
        v̄[k] *= m.κ^2 * d
    end
    return nothing
end
