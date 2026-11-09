# A recorded run's tape of each pool's leaving terms, `(e^{-H}, g(H))`
# by group and step. The flows' step writes them and their pullback reads
# them, rather than computing the exponentials again. The tape rides on
# the first hazard flow of a run of flows, in its parameter, so the
# `Depletion`, its records, its state and its pullback keep their shapes;
# the reverse pass binds the same tape from the cache.

# A hazard flow's parameter bound to its run's tape. It reads, and takes
# cotangents, as the parameter it holds. Steps are at times `o + 1` to
# `o + T`.
struct _Taped{P, A <: AbstractArray{<:Any, 3}}
    x::P
    tape::A
    o::Int
end
param(b::_Taped, k, t) = param(b.x, k, t)
param_eltype(b::_Taped) = param_eltype(b.x)
add_param!(x̄, b::_Taped, v, k, t) = add_param!(x̄, b.x, v, k, t)
_check_param(name, b::_Taped) = b
_check_param_strata(name, b::_Taped, G) = _check_param_strata(name, b.x, G)

# The tape of a run of flows, from the first flow whose parameter holds
# one, or `nothing`.
_tape_of(::Tuple{}) = nothing
_tape_of(fs::Tuple) = _tape_of(first(fs).demand, Base.tail(fs))
_tape_of(b::_Taped, rest) = b
_tape_of(x, rest) = _tape_of(rest)

# The step's leaving terms `L` of group `g` at time `t` onto the tape. The
# tape has a column per group and step of the run (`_flow_tapes`).
_tape_leaves!(::Nothing, L, g, t) = nothing
function _tape_leaves!(b::_Taped, L::NTuple{N, Any}, g, t) where {N}
    j = t - b.o
    ntuple(Val(N)) do i
        @inbounds b.tape[2i - 1, g, j] = L[i][1]
        @inbounds b.tape[2i, g, j] = L[i][2]
        return nothing
    end
    return nothing
end

# The leaving terms of group `g` at time `t`: from the tape where the step
# wrote them, else as the step computes them.
function _taped_leaves(::Nothing, fs, ::Val{N}, g, t, z) where {N}
    return ntuple(i -> _step_leaves(fs, i, g, t, z), Val(N))
end
function _taped_leaves(b::_Taped, fs, ::Val{N}, g, t, z) where {N}
    j = t - b.o
    return ntuple(Val(N)) do i
        E, gH = @inbounds b.tape[2i - 1, g, j], b.tape[2i, g, j]
        return E, gH, _out(_share, fs, i, g, t, z)
    end
end

# A recorded run's tapes: for each modifier, `nothing`, or for a
# `Depletion` one per part, for each run of flows with a hazard flow. Only
# a host buffer's run tapes; a device buffer's run recomputes the leaving
# terms in its pullback.
_flow_tapes(ms::Tuple, H, Tp, S, T) = map(m -> _flow_tapes(m, H, Tp, S, T), ms)
_flow_tapes(m, H, Tp, S, T) = nothing
function _flow_tapes(m::Depletion, H::Array, Tp, S, T)
    G = _ngroups(Val(blocks(m)), S)
    return map(p -> _flow_tape(p, Tp, 2 * _npools(m), G, T), m.pieces)
end
_flow_tape(p, Tp, n, G, T) = nothing
function _flow_tape(fs::Tuple, ::Type{Tp}, n, G, T) where {Tp}
    return fs isa _NoHazard ? nothing : Array{Tp}(undef, n, G, T)
end

# The modifiers with their tapes bound, for steps after time `o`.
_with_tapes(m, ::Nothing, o) = m
_with_tapes(ms::Tuple, tapes::Tuple, o) = map((m, A) -> _with_tapes(m, A, o), ms, tapes)
function _with_tapes(m::Depletion, tapes::Tuple, o)
    pieces = map((p, A) -> _with_tape(p, A, o), m.pieces, tapes)
    return constructorof(typeof(m))(m.pools, pieces)
end
_with_tape(p, ::Nothing, o) = p
_with_tape(::Tuple{}, A::AbstractArray, o) = ()
function _with_tape(fs::Tuple, A::AbstractArray, o)
    f = first(fs)
    f isa Flow{<:Any, _FlowHazard} || return (f, _with_tape(Base.tail(fs), A, o)...)
    g = constructorof(typeof(f))(f.from, f.to, _Taped(f.demand, A, o), f.form)
    return (g, Base.tail(fs)...)
end
