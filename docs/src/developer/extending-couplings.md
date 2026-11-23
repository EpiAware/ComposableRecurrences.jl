# [Couplings](@id extending-coupling)

A new coupling mixes the strata in a way a matrix cannot hold, or holds wastefully, and runs wherever a built-in coupling does.
It builds on [Writing new types](@ref extending); [Where the coupling acts](@ref explanation-coupling) says where the mixing sits in a step.

```@example extending-couplings
using ComposableRecurrences
const CR = ComposableRecurrences
```

## [A coupling with a pullback](@id extending-coupling-pullback)

A coupling has one role, [`Pressure()`](@ref ComposableRecurrences.Pressure).
Its `forward!(C, Pressure(), q, p, t)` writes the pressure `q` on each stratum from each stratum's kernel-weighted past values `p`.
Its `pullback!(grads, C, Pressure(), q, p, t)` is called with `q === nothing`, reads the cotangent `grads.q` and adds into `grads.p`.

This one sends a share ``a`` of every stratum's pressure to the first:

```math
q_i = (1 - a) \, p_i + a \, \delta_{i1} \sum_{j=1}^{S} p_j,
```

where ``\delta_{i1}`` is 1 for the first stratum and 0 otherwise, and ``S`` is the number of strata.
Its pullback also adds the cotangent of `share`.

```@example extending-couplings
struct ToFirst{A}
    share::A
end
function CR.forward!(C::ToFirst, ::CR.Pressure, q, p, t)
    q .= (1 - C.share) .* p
    q[1] += C.share * sum(p)
    return nothing
end
function CR.pullback!(grads, C::ToFirst, ::CR.Pressure, q, p, t)
    q̄, p̄ = grads.q, grads.p
    for i in eachindex(p, p̄)
        p̄[i] += (1 - C.share) * q̄[i] + C.share * q̄[1]
    end
    ā = q̄[1] * sum(p) - sum(i -> q̄[i] * p[i], eachindex(p))
    CR.add_cotangent!(CR.cotangent(grads.piece, :share), ā)
    return nothing
end

r = Recurrence([0.5, 0.5]; coupling = ToFirst(0.2))
r(1.0; history = ones(2, 2), stop = 4)
```

## [A linear coupling](@id extending-linear)

A coupling whose `forward!` is linear in `p` and does not read `t` is a matrix, and can say so with [`islinear`](@ref ComposableRecurrences.islinear).
Each call then builds that matrix from `forward!` on the basis vectors,

```math
q = A p, \qquad A_{\cdot b} = f(e_b), \quad b = 1, \dots, S,
```

where ``f`` is the coupling's `forward!` and ``e_b`` the ``b``-th basis vector.
The call runs the built-in dense coupling in its place, and the gradient uses that coupling's `pullback!`.
The same declaration on a whole-step modifier with no state of its own runs the matrix product as its step.

```@example extending-couplings
using LinearAlgebra: mul!
struct Mixing{M}
    K::M
end
function CR.forward!(C::Mixing, ::CR.Pressure, q, p, t)
    mul!(q, C.K, p)
    return nothing
end
CR.islinear(::Mixing) = true

K = [0.9 0.2; 0.1 0.8]
r = Recurrence([0.5, 0.5]; coupling = Mixing(K))
r(1.0; history = ones(2, 2), stop = 4)
```

For a `forward!` written as a matrix product, as here, the gradient is then close to the built-in dense coupling's.
For one written as scalar loops a hand-written `pullback!` is still faster, as the declared route differentiates those loops once per call.
A coupling that is not linear, or that changes in time, needs a `pullback!` to be fast.
[Specialising for speed](@ref specialising) shows a rank-one coupling that skips the dense product.
