# Interfaces.jl declaration of the role interface. Test objects are
# `Arguments(; piece, role, args)`, with `kwargs` for a `Run`.

_kwargs(a) = haskey(a, :kwargs) ? a.kwargs : (;)

# `forward!` runs and keeps to the role's conventions: outputs written into
# the leading arrays and `nothing` returned, inputs unchanged; a `Run`
# returns `(y, cache)`.
function _forward_ok(op, ::Run, args, kwargs)
    x = copy(first(args))
    y, cache = forward(op, Run(), args...; kwargs...)
    return size(y) == size(x) && first(args) == x
end
function _forward_ok(m, ::Step, args, kwargs)
    v, s = float(copy(args[1])), float(copy(args[2]))
    out = forward!(m, Step(), v, s, args[3:end]...)
    return out === nothing && length(v) == length(args[1]) &&
        length(s) == length(args[2])
end
function _forward_ok(m, ::Init, args, kwargs)
    s = float(copy(args[1]))
    return forward!(m, Init(), s, args[2]) === nothing && all(isfinite, s)
end
function _forward_ok(C, ::Pressure, args, kwargs)
    q, p = float(copy(args[1])), copy(args[2])
    out = forward!(C, Pressure(), q, p, args[3])
    return out === nothing && p == args[2] && all(isfinite, q)
end
# A trace writes into `r` (a vector, a tuple of vectors, or a group's
# one-entry values read as `x[]`) and leaves the step's values and state
# as they were.
function _forward_ok(m, ::Trace, args, kwargs)
    r, ins = deepcopy(args[1]), _snapshot(args[2:end])
    out = forward!(m, Trace(), r, args[2:end]...)
    return out === nothing && _snapshot(args[2:end]) == ins && _finite(r)
end
_snapshot(x::Tuple) = map(_snapshot, x)
_snapshot(x::Ref) = x[]
_snapshot(x::AbstractArray) = copy(x)
_snapshot(x) = x
_finite(x::Tuple) = all(_finite, x)
_finite(x::Ref) = isfinite(x[])
_finite(x::AbstractArray) = all(isfinite, x)

# A pointwise modifier's Step on each stratum's one-entry views matches its
# Step on the whole vectors.
_pointwise_ok(piece, role, args) = true
function _pointwise_ok(m, ::Step, args)
    ispointwise(m) || return true
    v, s = float(copy(args[1])), float(copy(args[2]))
    t = args[3]
    # A step that broadcasts against a length-S field cannot run on one
    # stratum's view, which fails the check rather than the call.
    pairs = try
        [_step(m, v[k], s[k], t, k) for k in eachindex(v)]
    catch e
        e isa DimensionMismatch || rethrow()
        return false
    end
    forward!(m, Step(), v, s, t)
    return v ≈ first.(pairs) && s ≈ last.(pairs)
end

# The vector Step of a blockwise modifier matches its group Step per group.
_blocks_ok(piece, role, args) = true
_blocks_ok(m, ::Step, args) = _groups_ok(blocks(m), m, args)
_groups_ok(::Nothing, m, args) = true
function _groups_ok(::Val{B}, m, args) where {B}
    nv, ns = B
    v, s = float(copy(args[1])), float(copy(args[2]))
    t = args[3]
    G = length(v) ÷ nv
    groups = [
        _block_step(m, _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g), t, g)
            for g in 1:G
    ]
    forward!(m, Step(), v, s, t)
    return all(1:G) do g
        v′, s′ = groups[g]
        all(i -> v[(i - 1) * G + g] ≈ v′[i], 1:nv) &&
            all(j -> s[(j - 1) * G + g] ≈ s′[j], 1:ns)
    end
end

# A modifier's state keeps `nstate(m, S)` entries through Init and Step,
# and a pointwise modifier keeps one per stratum.
_nstate_ok(piece, role, args) = true
function _nstate_ok(m, ::Init, args)
    n = nstate(m, _nstrata(args[2]))
    s = float(copy(args[1]))
    length(s) == n || return false
    forward!(m, Init(), s, args[2])
    return length(s) == n
end
function _nstate_ok(m, ::Step, args)
    v, s = float(copy(args[1])), float(copy(args[2]))
    S = length(v)
    n = nstate(m, S)
    length(s) == n || return false
    forward!(m, Step(), v, s, args[3:end]...)
    return length(s) == n && (!ispointwise(m) || n == S)
end

# A `pullback!` method for the type in a role the rule calls is
# found by `uses_adjoint`, unless the type declares its own `uses_adjoint`.
# A method with typed arguments is missed by the folded lookup, and the
# rule would otherwise drop it without a word.
function _adjoint_found(x, role)
    role isa Union{Run, Step, Pressure} || return true
    sig = Tuple{Any, typeof(x), typeof(role), Vararg{Any}}
    isempty(methods(pullback!, sig)) && return true
    default = which(uses_adjoint, Tuple{Any, Any})
    which(uses_adjoint, Tuple{typeof(x), typeof(role)}) === default || return true
    return uses_adjoint(x, role)
end

# A `pullback!` for a modifier's or a depletion form's `Step()`, or a
# coupling's `Pressure()`, gives the transpose Jacobian of its `forward!`
# times a fixed cotangent, in the type's float parameters and the role's
# inputs. The Jacobian is `ForwardDiff`'s, from the dual-number extension;
# without it the check passes with a note. A role or a type without a
# `pullback!` passes, as does a blockwise group step on tuples, which the
# vector step's check covers.
_pullback_ok(piece, role, args) = true
function _pullback_ok(x, role::Union{Step, Pressure}, args)
    uses_adjoint(x, role) || return true
    first(args) isa AbstractVector || return true
    return _pullback_matches(x, role, args)
end
_pullback_matches(x, role, args) = true
# A modifier's step: inputs and outputs `v` and `s`, with the pullback
# the rule calls on the whole vectors (per group for a blockwise one).
function _pullback_matches(m, ::Step, args::Tuple{Any, Any, Any})
    v, s, t = float(copy(args[1])), float(copy(args[2])), args[3]
    θ, nv = _params(m), length(v)
    P = length(θ)
    J = _check_jacobian([θ; v; s]) do z
        vz, sz = z[(P + 1):(P + nv)], z[(P + nv + 1):end]
        forward!(_rebuild(m, view(z, 1:P)), Step(), vz, sz, t)
        return [vz; sz]
    end
    J === nothing && return _no_jacobian()
    w = _probe_cotangent(length(v) + length(s))
    grads = (; piece = _zero_mirror(m), v = w[1:nv], s = w[(nv + 1):end])
    _vector_pullback!(grads, m, v, s, t)
    return _close(J, w, [_mirror_params(grads.piece, m); grads.v; grads.s])
end
# A depletion form's draw: inputs `v`, `s`, `N` and `α`, outputs `v` and
# `s`; the cotangents of the scalars `N` and `α` arrive indexed as `v`.
function _pullback_matches(f, ::Step, args::Tuple{Any, Any, Real, Real})
    v, s, N, α = float(copy(args[1])), float(copy(args[2])), args[3], args[4]
    θ, n = _params(f), length(v)
    P = length(θ)
    J = _check_jacobian([θ; v; s; N; α]) do z
        vz, sz = z[(P + 1):(P + n)], z[(P + n + 1):(end - 2)]
        forward!(_rebuild(f, view(z, 1:P)), Step(), vz, sz, z[end - 1], z[end])
        return [vz; sz]
    end
    J === nothing && return _no_jacobian()
    w = _probe_cotangent(n + length(s))
    grads = (;
        piece = _zero_mirror(f), v = w[1:n], s = w[(n + 1):end],
        N = zeros(eltype(w), n), α = zeros(eltype(w), n),
    )
    pullback!(grads, f, Step(), v, s, N, α)
    ḡ = [_mirror_params(grads.piece, f); grads.v; grads.s]
    return _close(J, w, [ḡ; sum(grads.N); sum(grads.α)])
end
# A coupling: input `p`, output `q`.
function _pullback_matches(C, ::Pressure, args)
    q, p, t = float(copy(args[1])), float(copy(args[2])), args[3]
    θ = _params(C)
    P = length(θ)
    J = _check_jacobian([θ; p]) do z
        qz = similar(z, length(q))
        forward!(_rebuild(C, view(z, 1:P)), Pressure(), qz, z[(P + 1):end], t)
        return qz
    end
    J === nothing && return _no_jacobian()
    w = _probe_cotangent(length(q))
    grads = (; piece = _zero_mirror(C), q = w, p = zero(p))
    pullback!(grads, C, Pressure(), nothing, p, t)
    return _close(J, w, [_mirror_params(grads.piece, C); grads.p])
end
_close(J, w, ḡ) = isapprox(transpose(J) * w, ḡ; rtol = 1.0e-8)

# The Jacobian of `f` at `x`, from the dual-number extension, or `nothing`.
_check_jacobian(f, x) = nothing
function _no_jacobian()
    @info "PieceInterface: the pullback check needs `using ForwardDiff`; " *
        "it passes without it" maxlog = 1
    return true
end

# A cotangent with distinct entries of both signs, the same on every call.
_probe_cotangent(n) = [cospi(0.37 * i + 0.1) for i in 1:n]

# A zeroed mirror of `x`, as the extending guide's gradient mirror gives
# it: a `Ref` for a float scalar, an array for a float array, a NamedTuple of
# its fields' mirrors for a struct (a sparse or `Diagonal` matrix included)
# and `nothing` for anything without a cotangent.
_zero_mirror(x::AbstractFloat) = Ref(zero(x))
_zero_mirror(x::AbstractArray{<:AbstractFloat}) = zero(x)
function _zero_mirror(
        x::Union{Diagonal{<:AbstractFloat}, SparseMatrixCSC{<:AbstractFloat}}
    )
    return _struct_mirror(x)
end
_zero_mirror(::_Leafless) = nothing
_zero_mirror(x::Union{Tuple, NamedTuple}) = map(_zero_mirror, x)
_zero_mirror(x) = isstructtype(typeof(x)) ? _struct_mirror(x) : nothing
function _struct_mirror(x)
    names = fieldnames(typeof(x))
    return NamedTuple{names}(map(n -> _zero_mirror(getfield(x, n)), names))
end

# The entries of mirror `x̄` in the order of `_params(x)`.
function _mirror_params(x̄, x)
    θ̄ = zeros(float(param_eltype(x)), _nparams(x))
    _mirror_params!(θ̄, x̄, x, 0)
    return θ̄
end
function _mirror_params!(θ̄, x̄, ::AbstractFloat, o)
    x̄ === nothing || (θ̄[o + 1] = x̄[])
    return o + 1
end
function _mirror_params!(θ̄, x̄, x::AbstractArray{<:AbstractFloat}, o)
    x̄ === nothing || copyto!(θ̄, o + 1, vec(x̄), 1, length(x))
    return o + length(x)
end
function _mirror_params!(θ̄, x̄, x::SparseMatrixCSC{<:AbstractFloat}, o)
    return _mirror_params!(θ̄, cotangent(x̄, :nzval), nonzeros(x), o)
end
function _mirror_params!(θ̄, x̄, x::Diagonal{<:AbstractFloat}, o)
    return _mirror_params!(θ̄, cotangent(x̄, :diag), x.diag, o)
end
_mirror_params!(θ̄, x̄, ::_Leafless, o) = o
function _mirror_params!(θ̄, x̄, x::Union{Tuple, NamedTuple}, o)
    for i in 1:length(x)
        o = _mirror_params!(θ̄, x̄ === nothing ? nothing : x̄[i], x[i], o)
    end
    return o
end
function _mirror_params!(θ̄, x̄, x, o)
    isstructtype(typeof(x)) || return o
    for n in fieldnames(typeof(x))
        o = _mirror_params!(θ̄, _field_mirror(x̄, n), getfield(x, n), o)
    end
    return o
end

@interface PieceInterface Any (
    mandatory = (
        forward = "forward or forward! runs in its role" =>
            a -> _forward_ok(a.piece, a.role, a.args, _kwargs(a)),
        adjoint = "uses_adjoint finds a pullback! method for the role" =>
            a -> _adjoint_found(a.piece, a.role),
    ),
    optional = (
        pointwise = "a vector Step matches the Step on each stratum's view" =>
            a -> _pointwise_ok(a.piece, a.role, a.args),
        blocks = "a vector Step matches the group Step on each group" =>
            a -> _blocks_ok(a.piece, a.role, a.args),
        nstate = "Init and Step keep the state at nstate(m, S) entries" =>
            a -> _nstate_ok(a.piece, a.role, a.args),
        pullback = "pullback! matches the `ForwardDiff` Jacobian of forward!" =>
            a -> _pullback_ok(a.piece, a.role, a.args),
    ),
) "An operator, coupling, modifier or variant with `forward` or `forward!`
for a role.

The mandatory `forward` component checks that `forward` (for `Run()`) or
`forward!` (for the other roles) runs and keeps to its role's conventions
(outputs written into the leading arrays and `nothing` returned, inputs
unchanged).
The mandatory `adjoint` component checks that a `pullback!` method for the
type and role is found by [`ComposableRecurrences.uses_adjoint`](@ref): a
method with a typed `grads` or typed arguments after the role is not, apart
from a blockwise group step's with `v::Tuple, s::Tuple`, and needs a
`uses_adjoint` method, and one with the wrong number of arguments fails
too.
The optional `pointwise` component checks that a pointwise modifier's
step on the whole vectors equals its step on a one-entry view of each
stratum,

```math
M(v, s, t)_i = M_i(v_i, s_i, t), \\qquad i = 1, \\dots, S,
```

where ``M`` is the modifier, ``v`` and ``s`` its value and state vectors at
time ``t`` and ``S`` the number of strata; it passes any other modifier.
The optional `blocks` component checks the same for a blockwise modifier
([`ComposableRecurrences.blocks`](@ref)), group by group, and passes any
other modifier.
The optional `nstate` component checks the state length against
[`ComposableRecurrences.nstate`](@ref).
The optional `pullback` component checks a `pullback!` for a modifier's or
a depletion form's `Step()`, or a coupling's `Pressure()`, against the
Jacobian ``J`` of `forward!` from `ForwardDiff`: for a fixed cotangent
``\\bar o`` of the outputs it compares the cotangents of the type's float
parameters and the role's inputs with ``J^\\top \\bar o`` at
`rtol = 1e-8`.
It needs `using ForwardDiff`, and passes with a note without it; it passes
any other role and a type without a `pullback!`.

Test objects are `Arguments(; piece, role, args)`, with `kwargs` for `Run()`.

# Examples

```jldoctest
using ComposableRecurrences, Interfaces, ForwardDiff
CR = ComposableRecurrences
Interfaces.test(CR.PieceInterface, CR.Clamp; show = false)

# output

true
```"

@implements PieceInterface Recurrence [
    Arguments(;
        piece = Recurrence([0.2, 0.3, 0.5]), role = Run(),
        args = ([1.1, 0.9, 1.2, 1.0],), kwargs = (; history = [1.0, 2.0, 3.0])
    ),
    Arguments(;
        piece = Recurrence([0.4, 0.6]; coupling = [0.9 0.1; 0.2 0.8]),
        role = Run(), args = ([1.1 0.9 1.2 1.0; 0.8 1.3 1.1 0.9],),
        kwargs = (; history = [1.0 2.0; 3.0 1.0])
    ),
    Arguments(;
        piece = Recurrence(Pairwise(fill(0.25, 2, 2, 2))), role = Run(),
        args = ([1.1 0.9 1.2; 0.8 1.3 1.1],), kwargs = (; history = ones(2, 2))
    ),
]

@implements PieceInterface Convolution [
    Arguments(;
        piece = Convolution([0.1, 0.6, 0.3]), role = Run(),
        args = ([1.0, 2.0, 3.0, 4.0],)
    ),
    Arguments(;
        piece = Convolution([0.1, 0.6, 0.3]), role = Run(),
        args = ([1.0 2.0 3.0; 4.0 5.0 6.0],),
        kwargs = (; history = [1.0 1.0; 2.0 2.0])
    ),
]

@implements PieceInterface{(:pullback,)} UniformScaling [
    Arguments(; piece = I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1)),
    Arguments(; piece = 0.5I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1)),
]

@implements PieceInterface{(:pullback,)} AbstractMatrix [
    Arguments(;
        piece = [0.9 0.1; 0.2 0.8], role = Pressure(),
        args = (zeros(2), [1.0, 2.0], 1)
    ),
    Arguments(;
        piece = Diagonal([0.5, 2.0]), role = Pressure(),
        args = (zeros(2), [1.0, 2.0], 1)
    ),
]

@implements PieceInterface{(:pullback,)} TimeVarying [
    Arguments(;
        piece = TimeVarying(reshape(collect(1.0:8.0), 2, 2, 2)),
        role = Pressure(), args = (zeros(2), [1.0, 2.0], 2)
    ),
    Arguments(;
        piece = TimeVarying([1 => [1.0 3.0; 2.0 4.0], 2 => [5.0 7.0; 6.0 8.0]]),
        role = Pressure(), args = (zeros(2), [1.0, 2.0], 5)
    ),
]

@implements PieceInterface{(:pointwise, :blocks, :nstate, :pullback)} Depletion [
    Arguments(;
        piece = Depletion(
            PerStratum([100.0, 50.0]); pools = (S = PerStratum([97.0, 46.0]),)
        ),
        role = Init(), args = (zeros(2), [1.0 2.0; 3.0 1.0])
    ),
    Arguments(;
        piece = Depletion(80.0; form = Floor(), heterogeneity = 1.5), role = Step(),
        args = ([2.0, 3.0], [80.0, 60.0], 1)
    ),
    Arguments(;
        piece = Depletion(80.0; removals = TimeVarying([4.0, 6.0])),
        role = Step(), args = ([2.0, 3.0], [80.0, 3.0], 2)
    ),
    Arguments(;
        piece = Depletion(100.0; flows = Flow(1 => 0, 0.01)), role = Step(),
        args = ([2.0, 3.0], [80.0, 60.0], 2)
    ),
    Arguments(;
        piece = Depletion(100.0; protected = 0.3, removals = 1.0),
        role = Step(), args = ([2.0, 3.0], [80.0, 60.0, 10.0, 5.0], 2)
    ),
    Arguments(;
        piece = Depletion(
            100.0; pools = (S = nothing, V = 4.0), protected = 0.3,
            flows = Flow(:V => :S, 0.1)
        ),
        role = Init(), args = (zeros(4), ones(2, 3))
    ),
    Arguments(;
        piece = Depletion(
            PerStratum([100.0, 50.0]); pools = (:S, :V, :R), form = Floor(),
            weights = (V = PerStratum([0.5, 0.2]), S = 1),
            flows = (Flow(:V => :S, 0.1), Flow(:S => :R, 0.5; form = Share()))
        ),
        role = Step(), args = ([2.0, 3.0], [80.0, 40.0, 10.0, 5.0, 1.0, 2.0], 2)
    ),
    Arguments(;
        piece = Depletion(100.0; form = Truncate()), role = Step(),
        args = ([2.0, 3.0], [80.0, 1.0], 2)
    ),
    Arguments(;
        piece = Depletion(;
            pools = (:A, :B), form = nothing,
            flows = (
                Flow(1 => 2, PerStratum([0.3, 0.2])),
                Flow(2 => 0, 0.1; form = Share()),
                Flow(1 => 0, 0.5; form = Truncate()),
                Flow(2 => 0, 0.2; form = SoftTruncate(0.1)),
            )
        ),
        role = Step(), args = ([2.0, 3.0, 1.0, 0.5], zeros(4), 1)
    ),
    Arguments(;
        piece = Depletion(; pools = (:U, :C), form = nothing, flows = Flow(:U => :C, 0.3)),
        role = Init(), args = (zeros(4), ones(4, 2))
    ),
    Arguments(;
        piece = Depletion(
            4.0; pools = (:O,), form = SoftTruncate(0.1), fill = :O,
            flows = Flow(:O => 0, 0.2; form = Share()), flows_first = true,
            overflow = :stratum
        ),
        role = Step(), args = ([2.0, 3.0, 1.0, 0.5], [1.0, 3.5], 2)
    ),
    Arguments(;
        piece = Depletion(;
            pools = (:B,), form = Truncate(), flows_first = true,
            flows = (
                Flow(:B => 0, TimeVarying([1.0, 0.0, 0.0]); form = Share()),
                Flow(
                    0 => :B, TimeVarying(PerStratum([3.0 0.0 0.0; 2.0 0.0 0.0]));
                    form = Truncate()
                ),
            ),
            overflow = :queue
        ),
        role = Step(), args = ([2.0, 3.0], [1.0, 0.5, 0.0, 1.0], 1)
    ),
    Arguments(;
        piece = Depletion(; pools = (B = 1.0,), form = Truncate()),
        role = Step(), args = ([2.0, 0.5], [1.0, 0.0], 2)
    ),
    Arguments(;
        piece = Depletion(
            2.0; pools = (O = 1.0,), form = Truncate(), fill = :O, overflow = :queue
        ),
        role = Init(), args = (zeros(4), ones(2, 2))
    ),
]

@implements PieceInterface{(:pullback,)} Hazard [
    Arguments(; piece = Hazard(), role = Step(), args = ([2.0], [80.0], 100.0, 1.0)),
]

@implements PieceInterface{(:pullback,)} Floor [
    Arguments(; piece = Floor(), role = Step(), args = ([2.0], [80.0], 100.0, 1.5)),
]

@implements PieceInterface{(:pointwise, :nstate, :pullback)} Add [
    Arguments(;
        piece = Add(TimeVarying(PerStratum([0.5 1.0; 0.2 0.1]))), role = Step(),
        args = ([2.0, 3.0], [0.0, 0.0], 2)
    ),
    Arguments(;
        piece = Add(0.5), role = Init(), args = (zeros(2), ones(2, 3))
    ),
]

@implements PieceInterface{(:nstate, :pullback)} Redistribute [
    Arguments(;
        piece = Redistribute([0.98 0.06; 0.02 0.94]),
        role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
]

@implements PieceInterface{(:pointwise, :nstate, :pullback)} Clamp [
    Arguments(;
        piece = Clamp(0.0, 2.5), role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
]

@implements PieceInterface{(:nstate, :pullback)} Allocate [
    Arguments(;
        piece = Allocate([1:2, 3:3], TimeVarying(PerStratum([4.0 5.0; 1.0 2.0]))),
        role = Step(), args = ([2.0, 3.0, 0.5], [0.0, 0.0, 0.0], 2)
    ),
    Arguments(;
        piece = Allocate([1:2, 3:3], 1.0), role = Init(),
        args = (zeros(3), ones(3, 2))
    ),
    Arguments(;
        piece = Allocate(
            [1:2, 3:3], PerStratum([4.0, 1.0]);
            imports = (0.2, [0.0 0.0 0.5; 0.0 0.0 0.5; 1.0 0.0 0.0]),
            spill = Redistribute([0.9 0.1 0.0; 0.1 0.9 0.0; 0.0 0.0 1.0])
        ),
        role = Step(), args = ([2.0, 3.0, 0.5], zeros(6), 2)
    ),
]


@implements PieceInterface{(:pullback,)} Truncate [
    Arguments(; piece = Truncate(), role = Step(), args = ([2.0], [1.5], 100.0, 1.0)),
]

@implements PieceInterface{(:pullback,)} SoftTruncate [
    Arguments(;
        piece = SoftTruncate(0.1), role = Step(), args = ([2.0], [1.5], 100.0, 1.0)
    ),
]
