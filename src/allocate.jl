@doc raw"""
Rescales each group of strata (see [`PerStratum`](@ref)) to an exogenous
total: the strata of a group keep their shares of the group's value and the
group takes its total.
With `imports`, a fraction of each total is shared instead by an import
pattern that reads the values before an optional within-group spill.

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
With `imports = (fraction, pattern)` and `spill`, the shares come from the
spilled values ``u = M_t v`` and a fraction ``\phi_{t,p}`` of the total from
the import pattern ``h = P_t v``, read before the spill:

```math
\begin{aligned}
\sigma^u_p &= \max\Big(\sum_{j \in G_p} u_j,\ \epsilon\Big), \qquad
\sigma^h_p = \max\Big(\sum_{j \in G_p} h_j,\ \epsilon\Big), \qquad
r_p = \frac{1}{\sigma^h_p} \sum_{j \in G_p} h_j, \\
v'_i &= T_{t,p} \Big((1 - \phi_{t,p} r_p) \frac{u_i}{\sigma^u_p}
    + \phi_{t,p} \frac{h_i}{\sigma^h_p}\Big), \quad i \in G_p,
\end{aligned}
```

where ``M_t`` is the movement matrix of a
[`ComposableRecurrences.Redistribute`](@ref) (the identity without `spill`)
and ``P_t`` a
[coupling](@ref explanation-coupling).
``r_p`` is one once the pattern sum reaches ``\epsilon``.
Below that, the pattern places the share ``\phi_{t,p} r_p`` of the total, so
the split changes continuously, and a group whose pattern sums to zero
takes all of its total by ``u``.
The group sums of ``v'`` still equal the totals.
The split has no branch on the values, so a tape recorded at one input
holds at another.
Use `spill` only when the pattern must read the values from before the
spill; otherwise place the `Redistribute` before `Allocate` in the modifier
tuple.
It is meant for non-negative values: a group sum at or below zero is
floored to ``\epsilon``.
The groups partition the strata; a stratum in no group is an
`ArgumentError`.
A group may be empty, given as `Int[]` or a range such as `3:2` (an untyped
`[]` holds `Any` and is rejected): it holds no strata, so its total and
import fraction are not used and their gradients are zero.
The groups are stored flat, in the fields `strata` (each group's strata in
turn) and `offsets` (where each group starts), so the analytic adjoint sees
only integer arrays and the parameters.
`total` and `fraction` are [parameters](@ref ComposableRecurrences.param)
over groups, not strata: `PerStratum` holds one value per group.
It reads every stratum of a group, so it is not pointwise.
It has no state without `imports`; with them the state holds ``h``, after
``u`` when there is a spill.
It composes with the other modifiers in tuple order:
`(Allocate(groups, total), Add(b))` adds `b` after the split.
Its reverse pass, with ``\bar v'`` the output cotangent and
``a_p = \sum_{j \in G_p} \bar v'_j v_j / \sigma_p``, is

```math
\bar T_{t,p} \mathrel{+}= a_p, \qquad
\bar v_i = \frac{T_{t,p}}{\sigma_p} (\bar v'_i - a_p), \quad i \in G_p,
```

and on the floor (``\sigma_p = \epsilon``) the ``a_p`` term drops.
With `imports`, ``a^u_p`` and ``a^h_p`` are the same sums over ``u`` and
``h``, and

```math
\begin{aligned}
\bar T_{t,p} &\mathrel{+}= (1 - \phi_{t,p} r_p)\, a^u_p + \phi_{t,p}\, a^h_p, \qquad
\bar\phi_{t,p} \mathrel{+}= T_{t,p} (a^h_p - r_p a^u_p), \\
\bar u_i &= \frac{T_{t,p} (1 - \phi_{t,p} r_p)}{\sigma^u_p} (\bar v'_i - a^u_p), \qquad
\bar h_i = \frac{T_{t,p}\, \phi_{t,p}}{\sigma^h_p} (\bar v'_i - a^h_p),
\end{aligned}
```

where ``a^h_p`` is replaced by ``a^u_p`` in ``\bar h_i`` while the pattern
sum is below ``\epsilon``, then
``\bar v = M_t^\top \bar u + P_t^\top \bar h``, two transposed products.

# Arguments
- `groups`: a vector of index ranges or vectors, one per group,
  partitioning the strata.
- `total`: each group's total.

# Keyword Arguments
- `imports`: `nothing` (the default), or `(fraction, pattern)` with
  `fraction` the share of each group's total placed by the import pattern
  and `pattern` an `S × S` coupling, or `TimeVarying` of an `S × S × T`
  array.
- `spill`: `nothing` (the default), or a
  [`ComposableRecurrences.Redistribute`](@ref) applied after the pattern
  reads the values; it needs `imports`.

# Examples
```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
totals = [10.0 12.0 15.0 18.0; 2.0 3.0 3.0 4.0]  # groups × time
split = CR.Allocate([1:2, 3:3], TimeVarying(PerStratum(totals)))
Recurrence([0.6, 0.4]; modifiers = (split,))(fill(1.2, 3, 4); history = ones(3, 2))

# output

3×4 Matrix{Float64}:
 5.0  6.0  7.5  9.0
 5.0  6.0  7.5  9.0
 2.0  3.0  3.0  4.0
```

A fifth of the first group's total lands where the third stratum sends,
read before the first two strata spill a tenth of their values to each
other; the second group imports nothing:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
P = [0.0 0.0 0.2; 0.0 0.0 0.8; 0.0 0.0 0.0]
within = CR.Redistribute([0.9 0.1 0.0; 0.1 0.9 0.0; 0.0 0.0 1.0])
split = CR.Allocate(
    [1:2, 3:3], PerStratum([10.0, 2.0]);
    imports = (PerStratum([0.2, 0.0]), P), spill = within
)
y = Recurrence([1.0]; modifiers = (split,))(ones(3, 1); history = [3.0; 1.0; 1.0;;])
round.(y; digits = 3)

# output

3×1 Matrix{Float64}:
 6.0
 4.0
 2.0
```
"""
struct Allocate{T, I}
    "The strata of every group, group by group."
    strata::Vector{Int}
    "Group `p` is `strata[(offsets[p] + 1):offsets[p + 1]]`."
    offsets::Vector{Int}
    "Each group's total, a parameter over groups."
    total::T
    "The import fraction, pattern and spill, or `nothing`."
    imports::I
    function Allocate(
            groups::AbstractVector, total::T; imports = nothing, spill = nothing
        ) where {T}
        _check_groups(groups)
        _check_group_param(:total, total, length(groups))
        im = _imports(imports, spill, length(groups))
        strata = Int[k for zs in groups for k in zs]
        offsets = cumsum([0; length.(groups)])
        return new{T, typeof(im)}(strata, offsets, total, im)
    end
    function Allocate(::_Flat, strata, offsets, total::T, imports::I) where {T, I}
        return new{T, I}(strata, offsets, total, imports)
    end
end

# The import fraction over groups, the pattern, a coupling read before the
# spill, and the spill, a `Redistribute` or `nothing`.
struct _AllocateImports{F, P, R}
    fraction::F
    pattern::P
    spill::R
end

# An `Allocate` rebuilt from its fields, for the local derivatives and the
# adjoint tests.
function _allocate_flat(strata, offsets, total, imports)
    return Allocate(_Flat(), strata, offsets, total, imports)
end
ConstructionBase.constructorof(::Type{<:Allocate}) = _allocate_flat

# A parameter read per group: checked as a parameter, against the number of
# groups, and not read from the outputs.
function _check_group_param(name, x, P)
    _check_param(name, x)
    _reads_outputs(x) && throw(
        ArgumentError(
            "$name is read per group, not per stratum, so it cannot read " *
                "the outputs; got $(_describe(x))"
        )
    )
    _check_rows(name, x, P, "groups")
    return nothing
end

function _imports(::Nothing, spill, P)
    spill === nothing || throw(
        ArgumentError(
            "spill needs imports; without them use " *
                "(Redistribute(M), Allocate(groups, total)), got spill = " *
                _describe(spill)
        )
    )
    return nothing
end
function _imports(imports, spill, P)
    imports isa Tuple{Any, Any} || throw(
        ArgumentError(
            "imports is (fraction, pattern), got $(_describe(imports))"
        )
    )
    fraction, pattern = imports
    _check_group_param(:fraction, fraction, P)
    _check_pattern(pattern)
    spill isa Union{Nothing, Redistribute} || throw(
        ArgumentError(
            "spill is a Redistribute or nothing, got $(_describe(spill))"
        )
    )
    return _AllocateImports(fraction, pattern, spill)
end

# The pattern is a coupling of the strata at the step's time.
function _check_pattern(P)
    P isa Union{AbstractMatrix, TimeVarying} || throw(
        ArgumentError(
            "pattern is an S × S matrix or TimeVarying of an S × S × T " *
                "array, got $(_describe(P))"
        )
    )
    _check_coupling_shape(P)
    P isa AbstractMatrix && size(P, 1) != size(P, 2) && throw(
        DimensionMismatch("pattern is $(size(P)), expected a square matrix")
    )
    return nothing
end

# The groups are stored flat, as index vectors, so the analytic rules see
# only integer arrays and the total.
_ngroups(m::Allocate) = length(m.offsets) - 1
_group(m::Allocate, p) = view(m.strata, (m.offsets[p] + 1):m.offsets[p + 1])

# The groups are disjoint vectors of positive indices, some possibly empty;
# that they cover every stratum is checked once the strata are known.
function _check_groups(groups)
    isempty(groups) && throw(
        ArgumentError(
            "groups must hold at least one group, got $(_describe(groups))"
        )
    )
    for zs in groups
        zs isa AbstractVector{<:Integer} || throw(
            ArgumentError(
                "each group is a vector of stratum indices, got " *
                    "$(_describe(zs))"
            )
        )
        isempty(zs) || minimum(zs) >= 1 || throw(
            ArgumentError(
                "stratum indices start at 1, got $(minimum(zs)) in group " *
                    _describe(zs)
            )
        )
    end
    seen = zeros(Bool, maximum(zs -> maximum(zs; init = 0), groups))
    for zs in groups, k in zs
        seen[k] && throw(
            ArgumentError(
                "stratum $k is in two groups; the groups must be disjoint"
            )
        )
        seen[k] = true
    end
    return nothing
end

function _check_partition(m::Allocate, S)
    n = length(m.strata)
    top = maximum(m.strata; init = 0)
    n == S && top <= S || throw(
        ArgumentError(
            "the groups cover $n strata with indices up to $top; they " *
                "must partition 1:$S"
        )
    )
    return S
end

# The groups hold indices, not parameters.
param_eltype(m::Allocate) = promote_type(param_eltype(m.total), param_eltype(m.imports))

# With imports the state holds the import pattern, after the spilled values
# when there is a spill.
nstate(m::Allocate{<:Any, <:_AllocateImports}, S) = _nslots(m) * S

function forward!(m::Allocate, ::Init, s, history)
    _check_imports(m.imports, _check_partition(m, length(s) ÷ _nslots(m)))
    fill!(s, zero(eltype(s)))
    return nothing
end
function _nslots(m::Allocate)
    m.imports === nothing && return 1
    return m.imports.spill === nothing ? 1 : 2
end
_check_imports(::Nothing, S) = nothing
function _check_imports(im::_AllocateImports, S)
    _check_coupling(im.pattern, S)
    im.spill === nothing && return nothing
    _check_modifier_strata(im.spill, S)
    return nothing
end
pullback!(grads, ::Allocate, ::Init, s, history) = nothing
_stateless(::Allocate{<:Any, Nothing}) = true

# The groups are disjoint, so each is one index of the loop.
function forward!(m::Allocate{<:Any, Nothing}, ::Step, v, s, t)
    strata, offsets = _like(v, m.strata), _like(v, m.offsets)
    _each!(
        _allocate_body!, Serial(), v, _ngroups(m), length(v),
        v, strata, offsets, m.total, t
    )
    return nothing
end

function _allocate_body!(p, v, strata, offsets, total, t)
    ε = eps(eltype(v))
    zs = view(strata, (offsets[p] + 1):offsets[p + 1])
    tot = zero(eltype(v))
    for k in zs
        tot += v[k]
    end
    c = param(total, p, t) / max(tot, ε)
    for k in zs
        v[k] *= c
    end
    return nothing
end

# Per group, with `a = Σ ȳ_k v_k / s_p`: the total's cotangent is `a` and
# `v̄_k = (T_p / s_p)(ȳ_k − a)`; on the floor the sum term drops.
function pullback!(grads, m::Allocate{<:Any, Nothing}, ::Step, v, s, t)
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

# With imports: the spilled values `u` go into the first slot of the state
# when there is a spill (otherwise `u = v`) and the pattern `h = P v` into
# the last, then each group shares its total between them.
function forward!(m::Allocate{<:Any, <:_AllocateImports}, ::Step, v, s, t)
    (; fraction, pattern, spill) = m.imports
    S = length(v)
    h = view(s, (length(s) - S + 1):length(s))
    u = _spill!(spill, view(s, 1:S), v, t)
    forward!(pattern, Pressure(), h, v, t)
    strata, offsets = _like(v, m.strata), _like(v, m.offsets)
    _each!(
        _import_body!, Serial(), v, _ngroups(m), length(v),
        v, u, h, strata, offsets, m.total, fraction, t
    )
    return nothing
end

# The spilled values `u = M v`, the spill's product written to `u` rather
# than to `v`.
_spill!(::Nothing, u, v, t) = v
function _spill!(r::Redistribute, u, v, t)
    forward!(r.M, Pressure(), u, v, t)
    return u
end

function _import_body!(p, v, u, h, strata, offsets, total, fraction, t)
    ε = eps(eltype(v))
    zs = view(strata, (offsets[p] + 1):offsets[p + 1])
    su = zero(eltype(v))
    sh = zero(eltype(v))
    for k in zs
        su += u[k]
        sh += h[k]
    end
    cu, ch = _import_weights(param(total, p, t), param(fraction, p, t), su, sh, ε)
    for k in zs
        v[k] = cu * u[k] + ch * h[k]
    end
    return nothing
end

# The weights of `u` and `h` in a group's output. A pattern summing to less
# than the floor places the share `φ r` of the total, with `r = sh / ε`, and
# the rest goes by `u`; the weights have no branch on the values.
function _import_weights(T, φ, su, sh, ε)
    mh = max(sh, ε)
    return T * (1 - φ * sh / mh) / max(su, ε), T * φ / mh
end

# The step keeps `u` and `h` in its state, so the reverse pass records the
# state after each step and the pullback reads them there (see
# `_pass_buffer` for the contract).
_keeps_after(::Allocate{<:Any, <:_AllocateImports}) = true

# Per group, with `a_u = Σ ȳ_k u_k / s_u` and `a_h = Σ ȳ_k h_k / s_h`:
# `ū_k = c_u (ȳ_k − a_u)` and `h̄_k = c_h (ȳ_k − a_h)`, then `ū` goes back
# through the spill's pullback and `h̄` through the pattern's, each one
# transposed product. `u` and `h` are read from the state after the step
# when the reverse pass recorded it, else computed again from the input.
function pullback!(grads, m::Allocate{<:Any, <:_AllocateImports}, ::Step, v, s, t)
    (; fraction, pattern, spill) = m.imports
    v̄, s̄ = grads.v, grads.s
    S = length(v)
    h̄ = view(s̄, (length(s̄) - S + 1):length(s̄))
    īm = cotangent(grads.piece, :imports)
    T̄, φ̄ = cotangent(grads.piece, :total), cotangent(īm, :fraction)
    u, h = _spilled_and_pattern(_after(grads), spill, pattern, v, t)
    pass = _pass(grads)
    ε = eps(eltype(v))
    for p in 1:_ngroups(m)
        zs = _group(m, p)
        su = zero(eltype(v))
        sh = zero(eltype(v))
        au = zero(eltype(v̄))
        ah = zero(eltype(v̄))
        for k in zs
            su += u[k]
            sh += h[k]
            au += v̄[k] * u[k]
            ah += v̄[k] * h[k]
        end
        T, φ = param(m.total, p, t), param(fraction, p, t)
        cu, ch = _import_weights(T, φ, su, sh, ε)
        mh = max(sh, ε)
        r = sh / mh
        au /= max(su, ε)
        ah /= mh
        add_param!(T̄, m.total, (1 - φ * r) * au + φ * ah, p, t)
        add_param!(φ̄, fraction, T * (ah - r * au), p, t)
        on = su >= ε
        # Below the floor `h` moves the share through `r`, not through `mh`.
        bh = sh > ε ? ah : au
        for k in zs
            ȳk = v̄[k]
            h̄[k] += ch * (ȳk - bh)
            v̄[k] = cu * (on ? ȳk - au : ȳk)
        end
    end
    _spill_back!(spill, cotangent(īm, :spill), v̄, s̄, v, t, _field(pass, :vc), pass)
    _pattern_back!(pattern, cotangent(īm, :pattern), h̄, v̄, v, t, _field(pass, :hb))
    fill!(h̄, zero(eltype(h̄)))
    return nothing
end

# The spilled values `u` and the pattern `h` of a step: read from the state
# after the step, or computed again from its input `v`.
function _spilled_and_pattern(::Nothing, spill, pattern, v, t)
    S = length(v)
    buf = similar(v, 2S)
    h = view(buf, (S + 1):(2S))
    u = _spill!(spill, view(buf, 1:S), v, t)
    forward!(pattern, Pressure(), h, v, t)
    return u, h
end
function _spilled_and_pattern(after, spill, pattern, v, t)
    S = length(v)
    u = spill === nothing ? v : view(after, 1:S)
    return u, view(after, (length(after) - S + 1):length(after))
end

_after(grads) = hasfield(typeof(grads), :after) ? grads.after : nothing
_pass(grads) = hasfield(typeof(grads), :pass) ? grads.pass : nothing
_field(::Nothing, name) = nothing
_field(x::NamedTuple, name) = getfield(x, name)

# The pattern's pullback: its cotangent `h̄` to the input's, `v̄ += Pᵀ h̄`,
# and to the pattern. With a column `hb` of the per-pass buffer, the
# pattern's cotangent is left to `_finish_pass!`, one product for every step.
function _pattern_back!(P, P̄, h̄, v̄, v, t, ::Nothing)
    pullback!((; piece = P̄, q = h̄, p = v̄), P, Pressure(), h̄, v, t)
    return nothing
end
function _pattern_back!(P::Matrix, P̄, h̄, v̄, v, t, hb::AbstractVector)
    copyto!(hb, h̄)
    mul!(v̄, transpose(P), h̄, true, true)
    return nothing
end

# Batching asks for a dense pattern or movement matrix whose mirror is a
# dense matrix: the buffer keeps each step's `h̄` (`hb`) and each step's
# cotangent of the spilled values (`vc`). Whether it batches depends on the
# types only, so the buffer's type is inferred; a mirror of the wrong size
# throws.
function _pass_buffer(H, ::Type{Tp}, m::Allocate{<:Any, <:_AllocateImports}, m̄, S, T) where {Tp}
    (; pattern, spill) = m.imports
    īm = cotangent(m̄, :imports)
    P̄ = cotangent(īm, :pattern)
    r̄ = cotangent(īm, :spill)
    hb = _batches(pattern, P̄) ? _batch_columns(H, Tp, pattern, P̄, S, T) : nothing
    vc = _batches_spill(spill, r̄) ?
        _batch_columns(H, Tp, spill.M, cotangent(r̄, :M), S, T) : nothing
    hb === nothing && vc === nothing && return nothing
    return (; hb, vc)
end
_batches(P, P̄) = false
_batches(P::Matrix, P̄) = _array_mirror(P̄) isa Matrix
_batches_spill(spill, r̄) = false
_batches_spill(r::Redistribute, r̄) = _batches(r.M, cotangent(r̄, :M))
function _batch_columns(H, ::Type{Tp}, P, P̄, S, T) where {Tp}
    _check_dense(_array_mirror(P̄), P)
    return _zeros(H, Tp, S, T)
end

# After the last step: `P̄ += H̄ Vᵀ` and `M̄ += Ū Vᵀ`, with `H̄` and `Ū` each
# step's cotangents of the pattern and the spilled values, and `V` each
# step's input.
function _finish_pass!(m̄, m::Allocate{<:Any, <:_AllocateImports}, R, b::NamedTuple, τ0)
    īm = cotangent(m̄, :imports)
    if b.hb !== nothing
        P̄ = _array_mirror(cotangent(īm, :pattern))
        mul!(P̄, b.hb, transpose(R.V), true, true)
    end
    if b.vc !== nothing
        M̄ = _array_mirror(cotangent(cotangent(īm, :spill), :M))
        mul!(M̄, b.vc, transpose(R.V), true, true)
    end
    return nothing
end

_spill_back!(::Nothing, r̄, v̄, s̄, v, t, vc, pass) = nothing
# The spilled values' state cotangent joins theirs, then they go back
# through the spill's product: `v̄ = Mᵀ ū` and `M̄ += ū vᵀ`.
function _spill_back!(r::Redistribute, r̄, v̄, s̄, v, t, ::Nothing, pass)
    ū = view(s̄, 1:length(v))
    ū .+= v̄
    fill!(v̄, zero(eltype(v̄)))
    M̄ = cotangent(r̄, :M)
    pullback!((; piece = M̄, q = ū, p = v̄), r.M, Pressure(), ū, v, t)
    fill!(ū, zero(eltype(ū)))
    return nothing
end
# The same with `M̄` left to `_finish_pass!`: the step keeps `ū` in the
# column `vc`.
function _spill_back!(r::Redistribute, r̄, v̄, s̄, v, t, vc::AbstractVector, pass)
    ū = view(s̄, 1:length(v))
    ū .+= v̄
    copyto!(vc, ū)
    mul!(v̄, transpose(r.M), ū)
    fill!(ū, zero(eltype(ū)))
    return nothing
end
