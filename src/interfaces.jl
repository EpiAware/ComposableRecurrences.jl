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
    first(args) isa AbstractVector && ispointwise(m) || return true
    v, s = float(copy(args[1])), float(copy(args[2]))
    t = args[3]
    pairs = [forward(m, Step(), v[k], s[k], t, k) for k in eachindex(v)]
    forward(m, Step(), v, s, t)
    return v ≈ first.(pairs) && s ≈ last.(pairs)
end

# The vector Step of a blockwise modifier matches its group Step per group.
_blocks_ok(piece, role, args) = true
function _blocks_ok(m, ::Step, args)
    first(args) isa AbstractVector || return true
    return _groups_ok(blocks(m), m, args)
end
_groups_ok(::Nothing, m, args) = true
function _groups_ok(::Val{B}, m, args) where {B}
    nv, ns = B
    v, s = float(copy(args[1])), float(copy(args[2]))
    t = args[3]
    G = length(v) ÷ nv
    groups = [
        forward(m, Step(), _gather(v, Val(nv), G, g), _gather(s, Val(ns), G, g), t, g)
            for g in 1:G
    ]
    forward(m, Step(), v, s, t)
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
function _adjoint_found(x, role)
    role isa Union{Run, Step, Pressure} || return true
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
        blocks = "a vector Step matches the group Step on each group" =>
            a -> _blocks_ok(a.piece, a.role, a.args),
        nstate = "Init and Step keep the state at nstate(m, S) entries" =>
            a -> _nstate_ok(a.piece, a.role, a.args),
    ),
) "An operator, coupling, modifier or variant with `forward` for a role.

The mandatory `forward` component checks that `forward` runs and keeps to
its role's conventions (outputs written into the leading arrays, inputs
unchanged).
The mandatory `adjoint` component checks that a `pullback!` method for the
type and role is found by [`ComposableRecurrences.uses_adjoint`](@ref): a
method with a typed `grads` or typed arguments after the role is not, apart
from a blockwise group step's with `v::Tuple, s::Tuple`, and needs a
`uses_adjoint` method, and one with the wrong number of arguments fails
too.
The optional `pointwise` component checks that a pointwise modifier's
vector step equals its scalar step on every stratum,

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
    Arguments(;
        piece = TimeVarying([1 => [1.0 3.0; 2.0 4.0], 2 => [5.0 7.0; 6.0 8.0]]),
        role = Pressure(), args = (zeros(2), [1.0, 2.0], 5)
    ),
]

@implements PieceInterface{(:pointwise, :blocks, :nstate)} Pool [
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
    Arguments(;
        piece = Pool(100.0; flows = Flow(1 => 0, 0.01)), role = Step(),
        args = ([2.0, 3.0], [80.0, 60.0], 2)
    ),
    Arguments(;
        piece = Pool(
            100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => Hazard(),
            flows = Flow(:S => :V, 1.0; form = Truncate())
        ),
        role = Step(), args = ([2.0, 3.0], [80.0, 60.0, 10.0, 5.0], 2)
    ),
    Arguments(;
        piece = Pool(
            100.0; pools = (:S, :V), draw = (:S => 1, :V => 0.3) => Hazard(),
            initial = (nothing, 4.0), flows = Flow(:V => :S, 0.1)
        ),
        role = Init(), args = (zeros(4), ones(2, 3))
    ),
    Arguments(;
        piece = Pool(
            PerStratum([100.0, 50.0]); pools = (:S, :V, :R),
            draw = (:V => PerStratum([0.5, 0.2]), :S => 1) => Floor(),
            flows = (Flow(:V => :S, 0.1), Flow(:S => :R, 0.5; form = Share()))
        ),
        role = Step(), args = ([2.0, 3.0], [80.0, 40.0, 10.0, 5.0, 1.0, 2.0], 2)
    ),
    Arguments(;
        piece = Depletion(100.0, Truncate()), role = Step(),
        args = ([2.0, 3.0], [80.0, 1.0], 2)
    ),
    Arguments(;
        piece = Pool(;
            pools = 2, draw = nothing,
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
        piece = Pool(; pools = (:U, :C), draw = nothing, flows = Flow(:U => :C, 0.3)),
        role = Init(), args = (zeros(4), ones(4, 2))
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
    Arguments(;
        piece = Allocate(
            [1:2, 3:3], PerStratum([4.0, 1.0]);
            imports = (0.2, [0.0 0.0 0.5; 0.0 0.0 0.5; 1.0 0.0 0.0]),
            spill = Redistribute([0.0 1.0 0.0; 1.0 0.0 0.0; 0.0 0.0 0.0], 0.1)
        ),
        role = Step(), args = ([2.0, 3.0, 0.5], zeros(6), 2)
    ),
]


@implements PieceInterface{(:nstate,)} Capacity [
    Arguments(;
        piece = Capacity(
            4.0, Beds(0.2); pairs = [1 => 2], form = SoftTruncate(0.1)
        ),
        role = Step(),
        args = ([5.0, 1.0, 0.5], [2.0], 1)
    ),
    Arguments(;
        piece = Capacity(
            PerStratum([3.0, 2.0]), Budget(7); pairs = [1, 3], overflow = Hold()
        ),
        role = Step(), args = ([5.0, 1.0, 0.5], [0.0, 1.0, 0.0, 2.0], 1)
    ),
    Arguments(;
        piece = Capacity(4.0, Budget(Inf); pairs = [2 => 1], initial = 1.0),
        role = Init(), args = (zeros(1), ones(3, 2))
    ),
    Arguments(;
        piece = Capacity(2.0, Budget(3); pairs = [2], overflow = Drop()),
        role = Step(), args = ([5.0, 1.0, 0.5], [0.0], 1)
    ),
]

@implements PieceInterface Truncate [
    Arguments(; piece = Truncate(), role = Step(), args = (2.0, 1.5, 100.0, 1.0)),
]

@implements PieceInterface SoftTruncate [
    Arguments(;
        piece = SoftTruncate(0.1), role = Step(), args = (2.0, 1.5, 100.0, 1.0)
    ),
]
