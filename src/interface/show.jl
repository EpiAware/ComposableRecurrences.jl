# One-line summaries for the REPL, error messages and the docs: the
# three-argument `show` names the type and gives its shape, and the
# two-argument `show` keeps the constructor form that `repr` prints.

# A slot value in a summary: its size and type when it is an array.
_brief(x) = _describe(x)
_brief(x::Function) = string(nameof(x))
_brief(::UniformScaling{Bool}) = "I"
function _brief(x::Union{PerStratum, Pairwise, TimeVarying})
    return sprint(show, MIME"text/plain"(), x)
end

# A count with its noun, plural when the count is not one.
_count(n, one, many = one * "s") = string(n, " ", n == 1 ? one : many)

# Writes `name(parts...)`, the parts joined by commas.
function _show_summary(io::IO, name, parts)
    print(io, name, "(")
    join(io, parts, ", ")
    print(io, ")")
    return nothing
end

# The modifiers by name, in order.
_modifier_names(modifiers::Tuple) = map(m -> string(nameof(typeof(m))), modifiers)

function Base.show(io::IO, ::MIME"text/plain", r::Recurrence)
    parts = String[_count(_nlags(r.kernel), "lag")]
    r.kernel isa AbstractVector || push!(parts, "kernel " * _brief(r.kernel))
    r.coupling === I || push!(parts, "coupling " * _brief(r.coupling))
    isempty(r.modifiers) || push!(
        parts, "modifiers (" * join(_modifier_names(r.modifiers), ", ") * ")"
    )
    _show_summary(io, :Recurrence, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", c::Convolution{K, M}) where {K, M}
    parts = String[_count(_nlags(c.kernel), "lag")]
    c.kernel isa AbstractVector || push!(parts, "kernel " * _brief(c.kernel))
    M === Auto || push!(parts, "method " * string(nameof(M)))
    _show_summary(io, :Convolution, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", x::PerStratum)
    parts = String[_count(size(x.x, 1), "stratum", "strata")]
    x.x isa AbstractVector || push!(parts, _brief(x.x))
    _show_summary(io, :PerStratum, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", x::Pairwise)
    A = x.x
    parts = String[
        string(size(A, 1), "×", size(A, 2), " strata"),
        _count(size(A, ndims(A)), "lag"),
    ]
    _show_summary(io, :Pairwise, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", x::TimeVarying{I}) where {I}
    parts = String[]
    x.x isa AbstractArray && push!(parts, _count(size(x.x, ndims(x.x)), "time"))
    x.x isa AbstractVector || push!(parts, _brief(x.x))
    I === Primary && push!(parts, "Primary()")
    _show_summary(io, :TimeVarying, parts)
    return nothing
end

# A depletion form by name, with its exponent or softness when it has one.
_form_summary(form) = string(nameof(typeof(form)))
function _form_summary(form::_ExponentForm)
    name = string(nameof(typeof(form)))
    return form.α === nothing ? name : string(name, "(", form.α, ")")
end
function _form_summary(form::Truncate)
    return form.κ === nothing ? "Truncate" : string("Truncate(", form.κ, ")")
end

# A part of a `Depletion` among its pools `names`: a draw by its form, a
# run of flows by the pools each joins.
function _piece_summary(d::_Drawing, names)
    N = d.N === nothing ? "" : ", population " * _brief(d.N)
    return "draw " * _form_summary(d.form) * N
end
function _piece_summary(fs::_Flows, names)
    pair(f) = string(names[f.from], " => ", f.to == 0 ? "0" : names[f.to])
    return "flows (" * join(map(pair, fs), ", ") * ")"
end

function Base.show(io::IO, ::MIME"text/plain", d::Depletion)
    names = keys(d.pools)
    parts = String["pools " * repr(names)]
    for p in d.pieces
        push!(parts, _piece_summary(p, names))
    end
    _show_summary(io, :Depletion, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", f::Flow)
    to = f.to == 0 ? "0" : repr(f.to)
    parts = String[
        string(repr(f.from), " => ", to), _form_summary(f.form),
        _brief(f.demand),
    ]
    _show_summary(io, :Flow, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", r::Redistribute{L}) where {L}
    parts = String["movement " * _brief(r.M)]
    L && push!(parts, "leak")
    _show_summary(io, :Redistribute, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", a::Allocate)
    parts = String[
        _count(length(a.offsets) - 1, "group"),
        _count(length(a.strata), "stratum", "strata"),
    ]
    a.imports === nothing || push!(parts, "imports")
    _show_summary(io, :Allocate, parts)
    return nothing
end

# A transform's parameters as it is written: clamp's bounds as two.
_theta_summary!(parts, f, ::Nothing) = parts
_theta_summary!(parts, f, θ) = push!(parts, _brief(θ))
_theta_summary!(parts, ::typeof(clamp), θ::Tuple) = append!(parts, map(_brief, θ))

function Base.show(io::IO, ::MIME"text/plain", t::Transform)
    parts = String[_brief(t.f)]
    _theta_summary!(parts, t.f, t.θ)
    t.derivative === nothing || push!(parts, "derivative " * _brief(t.derivative))
    _show_summary(io, :Transform, parts)
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", r::Recent)
    print(io, _describe(r))
    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", s::State)
    parts = String[
        string("t = ", s.t), "history " * _brief(s.history),
        _count(length(s.states), "modifier state"),
    ]
    _show_summary(io, :State, parts)
    return nothing
end
