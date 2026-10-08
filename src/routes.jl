@doc raw"""
A coupling that sums transmission routes, each a kernel and the coupling it
reaches its contacts through, for a [`Recurrence`](@ref) with kernel
`nothing`.

Route ``r`` convolves the past values with its own kernel, then mixes the
result with its own coupling:

```math
z^{(r)}_{t,j} = \sum_{l=1}^{L_r} k^{(r)}_{j,l}(t)\, y_{t-l,j},
\qquad
q_t = \sum_{r=1}^{R} C^{(r)}_t\, z^{(r)}_t,
```

where ``y_{t,j}`` is the output of stratum ``j`` at absolute time ``t``,
``k^{(r)}_{j,l}(t)`` the weight of route ``r``'s kernel on lag ``l``,
``L_r`` its length, ``C^{(r)}_t`` its ``S \times S`` coupling and ``q_t``
the pressure the recurrence scales by the gain.
A [`Pairwise`](@ref) route kernel replaces ``z^{(r)}_{t,j}`` with
``\sum_{b} \sum_{l} k^{(r)}_{jb,l}(t)\, y_{t-l,b}``.

Each step costs ``R`` kernel convolutions and ``R`` coupling products, and
a sparse route coupling stays sparse.
This is the [`Pairwise`](@ref) kernel
``A_{ij,l} = \sum_r C^{(r)}_{ij} k^{(r)}_l`` held as its routes.
A route kernel is any [`Recurrence`](@ref) kernel and a route coupling any
[`Recurrence`](@ref) coupling; kernels may differ in length.
The analytic adjoint applies when every route coupling has its own
[`ComposableRecurrences.pullback!`](@ref), as the built-in ones do.

The constructor stores the routes' couplings in `couplings` and their
kernels in `kernels`, in route order.

# Arguments
- `routes`: one `(coupling, kernel)` tuple per route, kernel lag 1 first.

# Examples
```jldoctest
using ComposableRecurrences
using SparseArrays: sparse
CR = ComposableRecurrences
community = [0.9 0.1; 0.1 0.9]
funeral = sparse([0.0 0.4; 0.4 0.0])  # transmission at funerals in the other place
routes = CR.Routes((community, [0.5, 0.3, 0.2]), (funeral, [0.0, 0.0, 0.0, 1.0]))
y = Recurrence(nothing; coupling = routes)(fill(1.2, 2, 6); history = ones(2, 4))
round.(y; digits = 3)

# output

2×6 Matrix{Float64}:
 1.68  2.088  2.578  3.181  4.144  5.253
 1.68  2.088  2.578  3.181  4.144  5.253
```
"""
struct Routes{C <: Tuple, G <: Tuple}
    "Each route's coupling."
    couplings::C
    "Each route's kernel, lag 1 first."
    kernels::G
    function Routes(::_Checked, couplings::C, kernels::G) where {C <: Tuple, G <: Tuple}
        length(couplings) == length(kernels) || throw(
            ArgumentError(
                "Routes has $(length(couplings)) couplings and " *
                    "$(length(kernels)) kernels"
            )
        )
        isempty(couplings) && throw(ArgumentError("Routes needs at least one route"))
        foreach(_check_route_coupling, couplings)
        foreach(_check_kernel_shape, kernels)
        return new{C, G}(couplings, kernels)
    end
end

function Routes(routes::Tuple...)
    return Routes(_Checked(), map(_route_coupling, routes), map(last, routes))
end
function Routes(routes...)
    throw(
        ArgumentError(
            string(
                "each route is a (coupling, kernel) tuple, got ",
                join(map(_describe, routes), ", ")
            )
        )
    )
end

# A rebuild from the fields skips the pairing.
_routes_flat(couplings, kernels) = Routes(_Checked(), couplings, kernels)
ConstructionBase.constructorof(::Type{<:Routes}) = _routes_flat

function _route_coupling(route::Tuple)
    length(route) == 2 || throw(
        ArgumentError(
            "each route is a (coupling, kernel) tuple, got $(_describe(route))"
        )
    )
    return first(route)
end

function _check_route_coupling(C)
    _check_coupling_shape(C)
    C isa Routes && throw(
        ArgumentError("a route's coupling cannot itself be Routes")
    )
    return nothing
end

# A `nothing` kernel and a `Routes` coupling come together: the routes hold
# the kernels.
_check_routes(kernel, coupling) = nothing
function _check_routes(::Nothing, coupling)
    throw(
        ArgumentError(
            "a nothing kernel needs coupling = Routes(...), which holds " *
                "the kernels; got coupling $(_describe(coupling))"
        )
    )
end
_check_routes(::Nothing, ::Routes) = nothing
function _check_routes(kernel, ::Routes)
    throw(
        ArgumentError(
            "Routes holds each route's kernel, so the Recurrence kernel " *
                "must be nothing, got $(_describe(kernel))"
        )
    )
end

_describe(C::Routes) = string("Routes with ", length(C.kernels), " routes")

_nlags(::Nothing, C::Routes) = maximum(map(_nlags, C.kernels))

function _check_coupling(C::Routes, S)
    foreach(K -> _check_coupling(K, S), C.couplings)
    foreach(g -> _check_kernel_strata(g, S), C.kernels)
    return nothing
end

function _check_times(name, C::Routes, stop)
    foreach(K -> _check_times(name, K, stop), C.couplings)
    foreach(g -> _check_kernel_times(g, stop), C.kernels)
    return nothing
end

function _check_primary_seeds(::Nothing, C::Routes, history, start)
    foreach(g -> _check_primary_seed(g, history, start), C.kernels)
    return nothing
end

# The rule applies when every route coupling has its own pullback.
uses_adjoint(C::Routes, ::Pressure) = _all_pressure_pullbacks(C.couplings)
_all_pressure_pullbacks(::Tuple{}) = true
function _all_pressure_pullbacks(Cs::Tuple)
    return uses_adjoint(first(Cs), Pressure()) &&
        _all_pressure_pullbacks(Base.tail(Cs))
end
_coupling_adjoint(C::Routes) = uses_adjoint(C, Pressure()) ? :pullback : :none

# The routes as one run reads them: each kernel oldest first, its length,
# and a work vector for one route's coupled pressure.
struct _RouteKernels{G <: Tuple, L <: Tuple, W}
    kernels::G
    lags::L
    w::W
end
function _run_kernel(::Type{Tp}, ::Nothing, C::Routes, h, S) where {Tp}
    return _RouteKernels(
        map(_oldest_first, C.kernels), map(_nlags, C.kernels), _zeros(h, Tp, S)
    )
end

function _kwork(k::_RouteKernels, S, L)
    return sum(map((g, Lr) -> _kwork(g, S, Lr) + S, k.kernels, k.lags))
end

# Route `r` reads the last `L_r` rows of the window, rows `t + L - L_r` to
# `t + L - 1` of the buffer.
function _prepare!(ex, p, q, C::Routes, k::_RouteKernels, H, t, τ, L)
    fill!(q, zero(eltype(q)))
    _routes_pressure!(ex, p, q, k.w, C.couplings, k.kernels, k.lags, H, t, τ, L)
    return nothing
end
_routes_pressure!(ex, z, q, w, ::Tuple{}, ::Tuple{}, ::Tuple{}, H, t, τ, L) = nothing
function _routes_pressure!(ex, z, q, w, Cs::Tuple, gs::Tuple, Ls::Tuple, H, t, τ, L)
    Lr = first(Ls)
    _kernel_pressure!(ex, z, first(gs), H, t + L - Lr, τ, Lr)
    forward(first(Cs), Pressure(), w, z, τ)
    for k in eachindex(q, w)
        q[k] += w[k]
    end
    return _routes_pressure!(
        ex, z, q, w, Base.tail(Cs), Base.tail(gs), Base.tail(Ls), H, t, τ, L
    )
end

# The reverse pass, per route: recompute its kernel convolution `z` from the
# buffer, send the pressure's cotangent back through its coupling into
# `z̄` (held in `p̄`), then through its kernel into the buffer. The mirrors
# of the route couplings and kernels sit in the coupling's mirror.
_route_mirrors(::Nothing, xs) = map(_ -> nothing, xs)
_route_mirrors(x̄s, xs) = x̄s

function _kernel_buffer(ḡ, C̄, C::Routes, k::_RouteKernels, H, S, L)
    ḡs = _route_mirrors(cotangent(C̄, :kernels), k.kernels)
    return map((ḡr, g, Lr) -> _kernel_buffer(ḡr, g, H, S, Lr), ḡs, k.kernels, k.lags)
end

function _core_back!(
        kbuf, ḡ, C̄, C::Routes, k::_RouteKernels, p̄, q̄, P, H, H̄, t, τ, L
    )
    C̄s = _route_mirrors(cotangent(C̄, :couplings), C.couplings)
    ḡs = _route_mirrors(cotangent(C̄, :kernels), k.kernels)
    _routes_back!(
        kbuf, ḡs, C̄s, C.couplings, k.kernels, k.lags, k.w, p̄, q̄, H, H̄, t, τ, L
    )
    return nothing
end
_routes_back!(::Tuple{}, ḡs, C̄s, Cs, gs, Ls, z, p̄, q̄, H, H̄, t, τ, L) = nothing
function _routes_back!(kbuf::Tuple, ḡs, C̄s, Cs, gs, Ls, z, p̄, q̄, H, H̄, t, τ, L)
    Lr, g = first(Ls), first(gs)
    tr = t + L - Lr
    _kernel_pressure!(Serial(), z, g, H, tr, τ, Lr)
    fill!(p̄, zero(eltype(p̄)))
    _pressure_back!(p̄, first(C̄s), first(Cs), q̄, z, τ)
    _kernel_back!(first(kbuf), first(ḡs), g, p̄, H, H̄, tr, τ, Lr)
    return _routes_back!(
        Base.tail(kbuf), Base.tail(ḡs), Base.tail(C̄s), Base.tail(Cs),
        Base.tail(gs), Base.tail(Ls), z, p̄, q̄, H, H̄, t, τ, L
    )
end

function _kernel_finish!(ḡ, C̄, C::Routes, kbuf::Tuple)
    ḡs = _route_mirrors(cotangent(C̄, :kernels), C.kernels)
    foreach(_kernel_finish!, ḡs, kbuf)
    return nothing
end
