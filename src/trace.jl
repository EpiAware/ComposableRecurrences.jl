# The trace of a modifier: a series it computes on the way, recorded per
# step when a call asks for it (`trace = true`). Each step's trace is a
# function of the step's inputs and outputs, read from the records the
# rule keeps, so a call without a trace runs as before.

@doc raw"""
The role of a modifier's trace: what a call with `trace = true` records
for it at each step.

At absolute time ``t`` the modifier maps its values and state
``(v_t, s_{t-1})`` to ``(v'_t, s_t)``, and its trace is

```math
r_t = R_M\big(v_t,\ s_{t-1},\ v'_t,\ s_t\big),
```

with ``R_M`` the modifier's own map: by default its state after the step,
``r_t = s_t``, and a modifier whose state never changes, such as
[`ComposableRecurrences.Add`](@ref), records nothing.
A [`ComposableRecurrences.Depletion`](@ref) with a draw records its pools after
the step, the value drawn ``y_t`` and the overflow
``d_t + Q_{t-1} - y_t``, what the draw leaves of the demand ``d_t`` and
the queue ``Q_{t-1}`` (zero without one), with rows for each pool, then
the drawn values, then the overflows, each over the strata or groups;
without a draw it records the amount each flow moves, a row per flow over
the groups.
[`ComposableRecurrences.Redistribute`](@ref) records its arrivals, its
state.
A pointwise modifier ([`ComposableRecurrences.ispointwise`](@ref))
implements `forward(m, Trace(), v, s, v′, s′, t, k)` for stratum `k`,
returning a tuple of ``r`` values, which fill rows `(j - 1) * S + k`.
A blockwise modifier ([`ComposableRecurrences.blocks`](@ref)) implements it
for group `g`, with `v`, `s`, `v′` and `s′` tuples, its values filling rows
`(j - 1) * G + g` for ``G`` groups.
Its pullback, `pullback!(grads, m, Trace(), v, s, t, k)` with
`grads = (; piece, trace)`, returns the cotangents
`(v̄, s̄, v̄′, s̄′)` of the inputs and outputs from that of the trace and
adds those of the modifier's parameters into `piece`;
[`ComposableRecurrences.ntrace`](@ref) gives the number of rows.
[A trace](@ref extending-trace) writes one.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.forward(CR.Depletion(100.0), CR.Trace(), 2.0, 80.0, 1.6, 78.4, 1, 1)

# output

(78.4, 1.6, 0.3999999999999999)
```
"""
struct Trace end

@doc raw"""
The number of rows of a modifier's trace for `S` strata, one column per
step.

For a modifier with ``r`` trace values per stratum, or per group of a
blockwise modifier with ``G`` groups,

```math
n_r = r S \quad \text{or} \quad n_r = r G;
```

the default is the modifier's [`ComposableRecurrences.nstate`](@ref), its
state after each step, or none for a modifier whose state never changes.

# Arguments
- `m`: the modifier.
- `S`: the number of strata.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
CR.ntrace(CR.Clamp(0.0, 1.0), 3), CR.ntrace(CR.Depletion(100.0), 3)

# output

(0, 9)
```
"""
ntrace(m, S) = _stateless(m) ? 0 : nstate(m, S)

# The defaults: the state after the step, per stratum or per group.
forward(m, ::Trace, v, s, v′, s′, t, k) = (s′,)
forward(m, ::Trace, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g) = s′
function pullback!(grads, m, ::Trace, v, s, t, k)
    z = zero(first(grads.trace))
    return z, z, z, only(grads.trace)
end
function pullback!(grads, m, ::Trace, v::Tuple, s::Tuple, t, g)
    z = zero(first(grads.trace))
    zv = map(_ -> z, v)
    return zv, map(_ -> z, s), zv, grads.trace
end

# A modifier's trace at one step into `out`, from its inputs `v` and `s`
# and outputs `v′` and `s′`: per stratum, per group, or for a vector-level
# modifier its state after the step.
_trace!(out, m, v, s, v′, s′, t) = _trace!(blocks(m), out, m, v, s, v′, s′, t)
function _trace!(::Nothing, out, m, v, s, v′, s′, t)
    ispointwise(m) || (copyto!(out, s′); return nothing)
    S = length(v)
    for k in 1:S
        _scatter!(out, forward(m, Trace(), v[k], s[k], v′[k], s′[k], t, k), S, k)
    end
    return nothing
end
function _trace!(::Val{B}, out, m, v, s, v′, s′, t) where {B}
    nv, ns = B
    G = _ngroups(Val(B), length(v))
    for g in 1:G
        r = forward(
            m, Trace(), _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g),
            _gather(v′, Val(nv), G, g), _gather(s′, Val(ns), G, g), t, g
        )
        _scatter!(out, r, G, g)
    end
    return nothing
end
