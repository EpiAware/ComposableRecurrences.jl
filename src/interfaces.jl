# Interfaces.jl declaration of the role interface. Test objects are
# `Arguments(; piece, role, args)`, with `kwargs` for a `Run`.

_kwargs(a) = haskey(a, :kwargs) ? a.kwargs : (;)

# `forward` runs and keeps to the role's conventions: outputs written into
# the leading arrays, inputs unchanged.
function _forward_ok(op, ::Run, args, kwargs)
    x = copy(first(args))
    y, cache = forward(op, Run(), args...; kwargs...)
    return size(y) == size(x) && first(args) == x
end
function _forward_ok(m, ::Step, args, kwargs)
    first(args) isa AbstractVector || return forward(m, Step(), args...) isa
        Tuple{Any, Any}
    v, s = float(copy(args[1])), float(copy(args[2]))
    out = forward(m, Step(), v, s, args[3:end]...)
    return out === nothing && length(v) == length(args[1]) &&
        length(s) == length(args[2])
end
function _forward_ok(m, ::Init, args, kwargs)
    s = float(copy(args[1]))
    return forward(m, Init(), s, args[2]) === nothing && all(isfinite, s)
end
function _forward_ok(C, ::Pressure, args, kwargs)
    q, p = float(copy(args[1])), copy(args[2])
    out = forward(C, Pressure(), q, p, args[3])
    return out === nothing && p == args[2] && all(isfinite, q)
end

# The vector Step of a pointwise modifier matches its scalar Step per stratum.
_pointwise_ok(piece, role, args) = true
function _pointwise_ok(m, ::Step, args)
    first(args) isa AbstractVector || return true
    v, s = float(copy(args[1])), float(copy(args[2]))
    t = args[3]
    pairs = [forward(m, Step(), v[k], s[k], t, k) for k in eachindex(v)]
    forward(m, Step(), v, s, t)
    return ispointwise(m) && v ≈ first.(pairs) && s ≈ last.(pairs)
end

# A modifier's state keeps `nstate(m, S)` entries through Init and Step,
# and a pointwise modifier keeps one per stratum.
_nstate_ok(piece, role, args) = true
function _nstate_ok(m, ::Init, args)
    n = nstate(m, _nstrata(args[2]))
    s = float(copy(args[1]))
    length(s) == n || return false
    forward(m, Init(), s, args[2])
    return length(s) == n
end
function _nstate_ok(m, ::Step, args)
    first(args) isa AbstractVector || return true
    v, s = float(copy(args[1])), float(copy(args[2]))
    S = length(v)
    n = nstate(m, S)
    length(s) == n || return false
    forward(m, Step(), v, s, args[3:end]...)
    return length(s) == n && (!ispointwise(m) || n == S)
end

# A `pullback!` method for the type in a role the rule calls is
# found by `uses_adjoint`, unless the type declares its own `uses_adjoint`.
# A method with typed arguments is missed by the folded lookup, and the
# rule would otherwise drop it without a word.
_adjoint_found(piece, role) = true
function _adjoint_found(x, role::Union{Run, Step, Pressure})
    sig = Tuple{Any, typeof(x), typeof(role), Vararg{Any}}
    isempty(methods(pullback!, sig)) && return true
    default = which(uses_adjoint, Tuple{Any, Any})
    which(uses_adjoint, Tuple{typeof(x), typeof(role)}) === default || return true
    return uses_adjoint(x, role)
end

@interface PieceInterface Any (
    mandatory = (
        forward = "forward runs in its role" =>
            a -> _forward_ok(a.piece, a.role, a.args, _kwargs(a)),
        adjoint = "uses_adjoint finds a pullback! method for the role" =>
            a -> _adjoint_found(a.piece, a.role),
    ),
    optional = (
        pointwise = "a vector Step matches the scalar Step on each stratum" =>
            a -> _pointwise_ok(a.piece, a.role, a.args),
        nstate = "Init and Step keep the state at nstate(m, S) entries" =>
            a -> _nstate_ok(a.piece, a.role, a.args),
    ),
) "An operator, coupling, modifier or variant with `forward` for a role.

The mandatory `forward` component checks that `forward` runs and keeps to
its role's conventions (outputs written into the leading arrays, inputs
unchanged).
The mandatory `adjoint` component checks that a `pullback!` method for the
type and role is found by [`ComposableRecurrences.uses_adjoint`](@ref): a
method with a typed `grads` or typed arguments after the role is not, and
needs a `uses_adjoint` method, and one with the wrong number of arguments
fails too.
The optional `pointwise` component checks that a modifier's vector step
equals its scalar step on every stratum,

```math
M(v, s, t)_i = M_i(v_i, s_i, t), \\qquad i = 1, \\dots, S,
```

where ``M`` is the modifier, ``v`` and ``s`` its value and state vectors at
time ``t`` and ``S`` the number of strata.
The optional `nstate` component checks the state length against
[`ComposableRecurrences.nstate`](@ref).

Test objects are `Arguments(; piece, role, args)`, with `kwargs` for `Run()`.

# Examples

```jldoctest
using ComposableRecurrences, Interfaces
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

@implements PieceInterface UniformScaling [
    Arguments(; piece = I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1)),
    Arguments(; piece = 0.5I, role = Pressure(), args = (zeros(2), [1.0, 2.0], 1)),
]

@implements PieceInterface AbstractMatrix [
    Arguments(;
        piece = [0.9 0.1; 0.2 0.8], role = Pressure(),
        args = (zeros(2), [1.0, 2.0], 1)
    ),
    Arguments(;
        piece = Diagonal([0.5, 2.0]), role = Pressure(),
        args = (zeros(2), [1.0, 2.0], 1)
    ),
]

@implements PieceInterface TimeVarying [
    Arguments(;
        piece = TimeVarying(reshape(collect(1.0:8.0), 2, 2, 2)),
        role = Pressure(), args = (zeros(2), [1.0, 2.0], 2)
    ),
]

@implements PieceInterface{(:pointwise, :nstate)} Depletion [
    Arguments(;
        piece = Depletion(PerStratum([100.0, 50.0]); pool0 = PerStratum([97.0, 46.0])),
        role = Init(), args = (zeros(2), [1.0 2.0; 3.0 1.0])
    ),
    Arguments(;
        piece = Depletion(80.0, Floor(); heterogeneity = 1.5), role = Step(),
        args = ([2.0, 3.0], [80.0, 60.0], 1)
    ),
    Arguments(;
        piece = Depletion(80.0; removals = TimeVarying([4.0, 6.0])),
        role = Step(), args = ([2.0, 3.0], [80.0, 3.0], 2)
    ),
]

@implements PieceInterface Hazard [
    Arguments(; piece = Hazard(), role = Step(), args = (2.0, 80.0, 100.0, 1.0)),
]

@implements PieceInterface Floor [
    Arguments(; piece = Floor(), role = Step(), args = (2.0, 80.0, 100.0, 1.5)),
]

@implements PieceInterface{(:pointwise, :nstate)} Add [
    Arguments(;
        piece = Add(TimeVarying(PerStratum([0.5 1.0; 0.2 0.1]))), role = Step(),
        args = ([2.0, 3.0], [0.0, 0.0], 2)
    ),
    Arguments(;
        piece = Add(0.5), role = Init(), args = (zeros(2), ones(2, 3))
    ),
]

@implements PieceInterface{(:nstate,)} Redistribute [
    Arguments(;
        piece = Redistribute([0.0 0.3; 0.2 0.0], PerStratum([0.1, 0.2])),
        role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
]

@implements PieceInterface{(:pointwise, :nstate)} Clamp [
    Arguments(;
        piece = Clamp(0.0, 2.5), role = Step(), args = ([2.0, 3.0], [0.0, 0.0], 1)
    ),
]

@implements PieceInterface{(:nstate,)} Allocate [
    Arguments(;
        piece = Allocate([1:2, 3:3], TimeVarying(PerStratum([4.0 5.0; 1.0 2.0]))),
        role = Step(), args = ([2.0, 3.0, 0.5], [0.0, 0.0, 0.0], 2)
    ),
    Arguments(;
        piece = Allocate([1:2, 3:3], 1.0), role = Init(),
        args = (zeros(3), ones(3, 2))
    ),
]
