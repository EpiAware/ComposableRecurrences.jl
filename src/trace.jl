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
the step, the value it passes on ``y_t`` and the overflow
``d_t + Q_{t-1} - y_t``, what its draws leave of the demand ``d_t`` and
the queue ``Q_{t-1}`` (zero without one), with rows for each pool, then
the values passed on, then the overflows, each over the strata or groups;
without a draw it records the amount each flow moves, a row per flow over
the groups.
[`ComposableRecurrences.Redistribute`](@ref) records its arrivals, its
state.
A modifier records its trace with
`forward!(m, Trace(), r, v, s, v′, s′, t)`, writing into `r`, which takes
the shape of `v` for its kind of step:
for a pointwise modifier ([`ComposableRecurrences.ispointwise`](@ref)) a
tuple of vectors, one per trace value, indexed by stratum as `v` is, their
`k`th entries filling row `(j - 1) * S + k`;
for a blockwise modifier ([`ComposableRecurrences.blocks`](@ref)), as
`forward!(m, Trace(), r, v, s, v′, s′, t, g)` for group `g`, a tuple of
one-entry views filling rows `(j - 1) * G + g` for ``G`` groups, with
`v`, `s`, `v′` and `s′` tuples of one-entry views;
for any other modifier the step's column of
[`ComposableRecurrences.ntrace`](@ref) rows.
Its pullback, `pullback!(grads, m, Trace(), v, s, t)` (with `g` for a
group), is given `grads = (; piece, trace, v, s, v′, s′)`: `trace` holds
the cotangent of `r`, in its shape, and the pullback adds the cotangents
of the step's inputs and outputs into `v`, `s`, `v′` and `s′` and those of
the modifier's parameters into `piece`.
[A trace](@ref extending-trace) writes one.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
r = ([0.0], [0.0], [0.0])
CR.forward!(CR.Depletion(100.0), CR.Trace(), r, [2.0], [80.0], [1.6], [78.4], 1)
r

# output

([78.4], [1.6], [0.3999999999999999])
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

# The defaults: the state after the step, per stratum, per group or for
# the whole step, and its pullback, which adds the trace's cotangent into
# that of the state after the step.
function forward!(m, ::Trace, r, v, s, v′, s′, t)
    _copy_trace!(r, s′)
    return nothing
end
function forward!(m, ::Trace, r::Tuple, v::Tuple, s::Tuple, v′::Tuple, s′::Tuple, t, g)
    foreach((x, y) -> x[] = y[], r, s′)
    return nothing
end
function pullback!(grads, m, ::Trace, v, s, t)
    _add_trace!(grads.s′, grads.trace)
    return nothing
end
function pullback!(grads, m, ::Trace, v::Tuple, s::Tuple, t, g)
    foreach((x̄, r̄) -> x̄[] += r̄[], grads.s′, grads.trace)
    return nothing
end
# A pointwise modifier's trace is a tuple of series, one per value, and a
# whole-step modifier's one vector.
_copy_trace!(r::Tuple, s′) = (copyto!(first(r), s′); nothing)
_copy_trace!(r::AbstractVector, s′) = (copyto!(r, s′); nothing)
_add_trace!(s̄′, r̄::Tuple) = _add_trace!(s̄′, first(r̄))
function _add_trace!(s̄′, r̄::AbstractVector)
    for k in eachindex(s̄′, r̄)
        s̄′[k] += r̄[k]
    end
    return nothing
end

# A modifier's trace at one step into its column `col`, from its inputs
# `v` and `s` and outputs `v′` and `s′`: a pointwise modifier's as one
# series per value over the strata, a blockwise one's per group from
# one-entry views, and any other's as the whole column.
_trace!(col, m, v, s, v′, s′, t) = _trace!(blocks(m), col, m, v, s, v′, s′, t)
function _trace!(::Nothing, col, m, v, s, v′, s′, t)
    r = ispointwise(m) ? _trace_series(col, Val(ntrace(m, 1)), length(v)) : col
    _written(m, forward!(m, Trace(), r, v, s, v′, s′, t))
    return nothing
end
function _trace!(::Val{B}, col, m, v, s, v′, s′, t) where {B}
    G = _ngroups(Val(B), length(v))
    for g in 1:G
        _group_trace!(m, Val(B), col, v, s, v′, s′, t, G, g)
    end
    return nothing
end
# Group `g`'s trace: the modifier's `forward!` on one-entry views. A
# built-in's group trace (`_trace_values`) is a function of the group's
# gathered values, which it returns, so its trace runs without views, as
# its step does.
function _group_trace!(m, ::Val{B}, col, v, s, v′, s′, t, G, g) where {B}
    nv, ns = B
    r = _group_views(col, Val(ntrace(m, nv)), G, g)
    _written(
        m, forward!(
            m, Trace(), r, _group_views(v, Val(nv), G, g),
            _group_views(s, Val(ns), G, g), _group_views(v′, Val(nv), G, g),
            _group_views(s′, Val(ns), G, g), t, g
        )
    )
    return nothing
end
# The `n` series of a column, rows `(j - 1) * S + 1` to `j * S` for the
# `j`th, and a group's one-entry views of them, entry `g` of each. A group
# reads its views as `x[]`, so each points at its entry of `x` directly.
_trace_series(col, ::Val{n}, S) where {n} = ntuple(j -> view(col, ((j - 1) * S + 1):(j * S)), Val(n))
_group_views(x, ::Val{n}, G, g) where {n} = ntuple(j -> _At(x, (j - 1) * G + g), Val(n))
