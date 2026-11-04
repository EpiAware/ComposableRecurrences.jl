# The three-argument show gives a one-line summary of each public type; the
# two-argument show stays the default constructor form that `repr` prints.

const _Summarised = Union{
    Recurrence, Convolution, PerStratum, Pairwise, TimeVarying, Depletion,
    Flow, Transform, Redistribute, Allocate, Recent, State,
}

function Base.show(io::IO, ::MIME"text/plain", x::_Summarised)
    print(io, _summary(x))
    return nothing
end

# A slot value inside a summary: a wrapper by its own summary, anything else
# as an error message names it.
_brief(x) = _describe(x)
_brief(x::Union{PerStratum, Pairwise, TimeVarying}) = _summary(x)
_brief(x::Function) = string(nameof(x))
_brief(::UniformScaling{Bool}) = "I"

# A value printed as written, without the module prefix.
_bare_repr(x) = repr(x; context = :module => @__MODULE__)

# A count with its noun, plural when the count is not one.
_count(n, one, many = one * "s") = string(n, " ", n == 1 ? one : many)

_summary_string(name, parts) = string(name, "(", join(parts, ", "), ")")

function _summary(r::Recurrence)
    parts = String[_count(_nlags(r.kernel), "lag")]
    r.kernel isa AbstractVector || push!(parts, "kernel " * _brief(r.kernel))
    r.coupling === I || push!(parts, "coupling " * _brief(r.coupling))
    isempty(r.modifiers) || push!(
        parts, "modifiers (" *
            join(map(m -> string(nameof(typeof(m))), r.modifiers), ", ") * ")"
    )
    return _summary_string(:Recurrence, parts)
end

function _summary(c::Convolution{K, M}) where {K, M}
    parts = String[_count(_nlags(c.kernel), "lag")]
    c.kernel isa AbstractVector || push!(parts, "kernel " * _brief(c.kernel))
    M === Auto || push!(parts, "method " * string(nameof(M)))
    return _summary_string(:Convolution, parts)
end

function _summary(x::PerStratum)
    parts = String[_count(size(x.x, 1), "stratum", "strata")]
    x.x isa AbstractVector || push!(parts, _describe(x.x))
    return _summary_string(:PerStratum, parts)
end

function _summary(x::Pairwise)
    A = x.x
    parts = String[
        string(size(A, 1), "×", size(A, 2), " strata"),
        _count(size(A, ndims(A)), "lag"),
    ]
    return _summary_string(:Pairwise, parts)
end

# The default `Secondary()` indexing is left out.
function _summary(x::TimeVarying{Idx}) where {Idx}
    parts = String[]
    x.x isa AbstractArray && push!(parts, _count(size(x.x, ndims(x.x)), "time"))
    x.x isa AbstractVector || push!(parts, _describe(x.x))
    Idx === Primary && push!(parts, "Primary()")
    return _summary_string(:TimeVarying, parts)
end

# A part of a `Depletion` among its pools `names`: a draw by its form and
# the arguments the draw holds, a run of flows by the pools each joins.
_overflow_summary(::_Drop) = nothing
_overflow_summary(::_Queue) = "overflow = :queue"
_overflow_summary(::_ToStratum) = "overflow = :stratum"
function _draw_parts(d::_DrawFrom, names)
    return (
        d.first == 1 ? nothing : "from = " * repr(names[d.first]),
        _default_weights(d) ? nothing : "weights = " * repr(d.weights),
    )
end
# Weights of one on the drawn pool and zero elsewhere are the default.
function _default_weights(d::_DrawFrom)
    d.weights === nothing && return true
    return all(i -> d.weights[i] == (i == d.first), eachindex(values(d.weights)))
end
_draw_parts(d::_DrawInto, names) = ("into = " * repr(names[d.pool]),)
function _piece_summary(d::_Drawing, names)
    args = String[
        a for a in (_draw_parts(d, names)..., _overflow_summary(d.overflow))
            if a !== nothing
    ]
    form = _bare_repr(d.form)
    form = isempty(args) ? form : string(form, " with ", join(args, ", "))
    N = d.N === nothing ? "" : ", population " * _brief(d.N)
    return "draw " * form * N
end
function _piece_summary(fs::_Flows, names)
    pair(f) = string(names[f.from], " => ", f.to == 0 ? "0" : names[f.to])
    return "flows (" * join(map(pair, fs), ", ") * ")"
end

function _summary(d::Depletion)
    names = keys(d.pools)
    parts = String["pools " * repr(names)]
    for p in d.pieces
        push!(parts, _piece_summary(p, names))
    end
    return _summary_string(:Depletion, parts)
end

function _summary(f::Flow)
    to = f.to == 0 ? "0" : repr(f.to)
    parts = String[
        string(repr(f.from), " => ", to), _bare_repr(f.form), _brief(f.demand),
    ]
    return _summary_string(:Flow, parts)
end

function _summary(r::Redistribute{L}) where {L}
    parts = String["movement " * _brief(r.M)]
    L && push!(parts, "leak")
    return _summary_string(:Redistribute, parts)
end

function _summary(a::Allocate)
    parts = String[
        _count(length(a.offsets) - 1, "group"),
        _count(length(a.strata), "stratum", "strata"),
    ]
    a.imports === nothing || push!(parts, "imports")
    return _summary_string(:Allocate, parts)
end

# Clamp's bounds are written as two arguments.
_theta_summary!(parts, f, ::Nothing) = parts
_theta_summary!(parts, f, θ) = push!(parts, _brief(θ))
_theta_summary!(parts, ::typeof(clamp), θ::Tuple) = append!(parts, map(_brief, θ))

function _summary(t::Transform)
    parts = String[_brief(t.f)]
    _theta_summary!(parts, t.f, t.θ)
    t.derivative === nothing || push!(parts, "derivative " * _brief(t.derivative))
    return _summary_string(:Transform, parts)
end

_summary(r::Recent) = _describe(r)

function _summary(s::State)
    parts = String[
        string("t = ", s.t), "history " * _brief(s.history),
        _count(length(s.states), "modifier state"),
    ]
    return _summary_string(:State, parts)
end
