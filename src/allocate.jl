# Marks the constructor that takes the flat fields as they are.
struct _Flat end

@doc raw"""
Rescales each group of strata to an exogenous total: the strata of a group
keep their shares of the group's value and the group takes its total.
A stratum is one of ``S`` parallel series computed together, such as a
place or an age group.

At absolute time ``t``, with ``v_i`` stratum ``i``'s value after the
earlier modifiers, ``G_p`` the strata of group ``p`` and ``T_{t,p}`` its
total,

```math
\begin{aligned}
\sigma_p &= \max\Big(\sum_{j \in G_p} v_j,\ \epsilon\Big), \\
v'_i &= T_{t,p}\, \frac{v_i}{\sigma_p}, \quad i \in G_p,
\end{aligned}
```

with ``\epsilon`` the machine epsilon of the buffer eltype, so the group
sums of ``v'`` equal the totals wherever ``\sigma_p > \epsilon``.
The groups partition the strata; a stratum in no group is an
`ArgumentError`.
The groups are stored flat, in the fields `strata` (each group's strata in
turn) and `offsets` (where each group starts), so the analytic adjoint sees
only integer arrays and `total`.
`total` is a parameter over groups, not strata: one value,
[`PerStratum`](@ref) (one per group), [`TimeVarying`](@ref) (one per time)
or `TimeVarying(PerStratum(T))` with `T` groups × time, read at the
absolute time.
It reads every stratum of a group, so it is not pointwise, and it has no
state.
It composes with the other modifiers in tuple order:
`(Allocate(groups, total), Add(b))` adds `b` after the split.
Its reverse pass, with ``\bar v'`` the output cotangent and
``a_p = \sum_{j \in G_p} \bar v'_j v_j / \sigma_p``, is

```math
\bar T_{t,p} \mathrel{+}= a_p, \qquad
\bar v_i = \frac{T_{t,p}}{\sigma_p} (\bar v'_i - a_p), \quad i \in G_p,
```

and on the floor (``\sigma_p = \epsilon``) the ``a_p`` term drops.

# Arguments
- `groups`: a vector of index ranges or vectors, one per group,
  partitioning the strata.
- `total`: each group's total.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
totals = [10.0 12.0 15.0 18.0; 2.0 3.0 3.0 4.0]  # groups × time
split = CR.Allocate([1:2, 3:3], TimeVarying(PerStratum(totals)))
Recurrence([0.6, 0.4]; modifiers = (split,))(fill(1.2, 3, 4); history = ones(3, 2))
```
"""
struct Allocate{T}
    "The strata of every group, group by group."
    strata::Vector{Int}
    "Group `p` is `strata[(offsets[p] + 1):offsets[p + 1]]`."
    offsets::Vector{Int}
    "Each group's total: one value, `PerStratum` or `TimeVarying`."
    total::T
    function Allocate(groups::AbstractVector, total::T) where {T}
        _check_groups(groups)
        _check_param(:total, total)
        _check_group_totals(total, length(groups))
        strata = Int[k for zs in groups for k in zs]
        offsets = cumsum([0; length.(groups)])
        return new{T}(strata, offsets, total)
    end
    function Allocate(::_Flat, strata, offsets, total::T) where {T}
        return new{T}(strata, offsets, total)
    end
end

# An `Allocate` rebuilt from its fields, for the local derivatives and the
# adjoint tests.
_allocate_flat(strata, offsets, total) = Allocate(_Flat(), strata, offsets, total)
_constructorof(::Type{<:Allocate}) = _allocate_flat

# The groups are stored flat, as index vectors, so the analytic rules see
# only integer arrays and the total.
_ngroups(m::Allocate) = length(m.offsets) - 1
_group(m::Allocate, p) = view(m.strata, (m.offsets[p] + 1):m.offsets[p + 1])

# The groups are disjoint, non-empty vectors of positive indices; that they
# cover every stratum is checked once the strata are known.
function _check_groups(groups)
    isempty(groups) && throw(ArgumentError("groups is empty"))
    for zs in groups
        zs isa AbstractVector{<:Integer} && !isempty(zs) || throw(
            ArgumentError("each group is a non-empty vector of stratum indices")
        )
        minimum(zs) >= 1 || throw(ArgumentError("stratum indices start at 1"))
    end
    seen = zeros(Bool, maximum(maximum, groups))
    for zs in groups, k in zs
        seen[k] && throw(ArgumentError("stratum $k is in two groups"))
        seen[k] = true
    end
    return nothing
end

_check_group_totals(total, P) = nothing
_check_group_totals(total::TimeVarying, P) = _check_group_totals(total.x, P)
function _check_group_totals(total::PerStratum, P)
    size(total.x, 1) == P || throw(
        DimensionMismatch("total has $(size(total.x, 1)) groups, expected $P")
    )
    return nothing
end

function _check_partition(m::Allocate, S)
    n = length(m.strata)
    n == S && maximum(m.strata) <= S || throw(
        ArgumentError(
            "the groups cover $n strata with indices up to " *
                "$(maximum(m.strata)); they must partition 1:$S"
        )
    )
    return nothing
end

# The groups hold indices, not parameters.
param_eltype(m::Allocate) = param_eltype(m.total)

function forward(m::Allocate, ::Init, s, history)
    _check_partition(m, length(s))
    fill!(s, zero(eltype(s)))
    return nothing
end
pullback!(grads, ::Allocate, ::Init, s, history) = nothing

function forward(m::Allocate, ::Step, v, s, t)
    ε = eps(eltype(v))
    for p in 1:_ngroups(m)
        zs = _group(m, p)
        tot = zero(eltype(v))
        for k in zs
            tot += v[k]
        end
        c = param(m.total, p, t) / max(tot, ε)
        for k in zs
            v[k] *= c
        end
    end
    return nothing
end

# Per group, with `a = Σ ȳ_k v_k / s_p`: the total's cotangent is `a` and
# `v̄_k = (T_p / s_p)(ȳ_k − a)`; on the floor the sum term drops.
function pullback!(grads, m::Allocate, ::Step, v, s, t)
    v̄ = grads.v
    T̄ = cotangent(grads.piece, :total)
    ε = eps(eltype(v))
    for p in 1:_ngroups(m)
        zs = _group(m, p)
        tot = zero(eltype(v))
        a = zero(eltype(v̄))
        for k in zs
            tot += v[k]
            a += v̄[k] * v[k]
        end
        sp = max(tot, ε)
        a /= sp
        add_param!(T̄, m.total, a, p, t)
        c = param(m.total, p, t) / sp
        on = tot >= ε
        for k in zs
            v̄[k] = c * (on ? v̄[k] - a : v̄[k])
        end
    end
    return nothing
end

# The pullback above is the adjoint the analytic `Recurrence` rule uses.
uses_adjoint(::Allocate, ::Step) = true
