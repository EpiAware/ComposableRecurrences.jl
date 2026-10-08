@doc raw"""
A [`Recurrence`](@ref) kernel that sums transmission routes, each a kernel
and the coupling it reaches its contacts through.

Route ``r`` convolves the past values with its own kernel, then mixes the
result with its own coupling:

```math
z^{(r)}_{t,j} = \sum_{l=1}^{L_r} k^{(r)}_{j,l}(t)\, y_{t-l,j},
\qquad
p_t = \sum_{r=1}^{R} C^{(r)}_t\, z^{(r)}_t,
```

where ``y_{t,j}`` is the output of stratum ``j`` at absolute time ``t``,
``k^{(r)}_{j,l}(t)`` the weight of route ``r``'s kernel on lag ``l``,
``L_r`` its length, ``C^{(r)}_t`` its ``S \times S`` coupling and ``p_t``
the pressure the recurrence scales by the gain.
A [`Pairwise`](@ref) route kernel replaces ``z^{(r)}_{t,j}`` with
``\sum_{b} \sum_{l} k^{(r)}_{jb,l}(t)\, y_{t-l,b}``.

This is the [`Pairwise`](@ref) kernel
``A_{ij,l} = \sum_r C^{(r)}_{ij} k^{(r)}_l`` held as its routes.
Each step costs ``R`` kernel convolutions and ``R`` coupling products, and
a sparse route coupling stays sparse.
The routes mix strata, so the recurrence's coupling is `I`.
A route kernel is any [`Recurrence`](@ref) kernel but `Routes`, and a route
coupling any [`Recurrence`](@ref) coupling; kernels may differ in length.
The recurrence's history covers the longest route kernel.

Routes with a cheaper equivalent form fold into it when the
[`Recurrence`](@ref) is built: one route is its kernel with its coupling,
and routes whose couplings are all `λ * I` on vector kernels are the one
kernel ``\sum_r \lambda_r k^{(r)}``.
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
community = [0.9 0.1; 0.1 0.9]
funeral = sparse([0.0 0.4; 0.4 0.0])  # funerals in the other place
routes = Routes((community, [0.5, 0.3, 0.2]), (funeral, [0.0, 0.0, 0.0, 1.0]))
y = Recurrence(routes)(fill(1.2, 2, 6); history = ones(2, 4))
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
        foreach(_check_coupling_shape, couplings)
        foreach(_check_route_kernel, kernels)
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

_check_route_kernel(g) = _check_kernel_shape(g)
function _check_route_kernel(::Routes)
    throw(ArgumentError("a route's kernel cannot itself be Routes"))
end

_describe(R::Routes) = string("Routes with ", length(R.kernels), " routes")

_check_kernel_shape(::Routes) = nothing
function _check_pairwise_coupling(::Routes, coupling)
    coupling isa UniformScaling && isone(coupling.λ) || throw(
        ArgumentError(
            "Routes holds each route's coupling, so the Recurrence " *
                "coupling must be I, got $(_describe(coupling))"
        )
    )
    return nothing
end

# The fold: one route is its kernel with its coupling, unless it is a
# pairwise kernel, which takes coupling `I`; routes on `λ * I` with vector
# kernels sum into one kernel. Decided from the types.
function _fold(R::Routes, J::UniformScaling{Bool})
    _check_pairwise_coupling(R, J)
    return _fold_routes(R.couplings, R.kernels, R, J)
end
_fold_routes(Cs, gs, R, J) = (R, J)
function _fold_routes(Cs::Tuple{Any}, gs::Tuple{Any}, R, J)
    return _fold_one(only(Cs), only(gs), R, J)
end
function _fold_routes(Cs::Tuple{UniformScaling}, gs::Tuple{AbstractVector}, R, J)
    return _fold_one(only(Cs), only(gs), R, J)
end
function _fold_routes(
        Cs::Tuple{Vararg{UniformScaling}}, gs::Tuple{Vararg{AbstractVector}}, R, J
    )
    return _scaled_sum(Cs, gs), J
end
_fold_one(C, g, R, J) = (g, C)
_fold_one(C, g::_PairwiseKernel, R, J) = (R, J)

# `Σ_r λ_r g_r`, each kernel zero past its end.
function _scaled_sum(Cs, gs)
    T = promote_type(map(C -> typeof(C.λ), Cs)..., map(eltype, gs)...)
    g = _zeros(first(gs), T, maximum(map(length, gs)))
    foreach(Cs, gs) do C, gr
        for i in eachindex(gr)
            g[i] += C.λ * gr[i]
        end
    end
    return g
end

_nlags(R::Routes) = maximum(map(_nlags, R.kernels))

function _check_kernel_strata(R::Routes, S)
    foreach(C -> _check_coupling(C, S), R.couplings)
    foreach(g -> _check_kernel_strata(g, S), R.kernels)
    return nothing
end

function _check_kernel_times(R::Routes, stop)
    foreach(C -> _check_times(:coupling, C, stop), R.couplings)
    foreach(g -> _check_kernel_times(g, stop), R.kernels)
    return nothing
end

function _check_primary_seed(R::Routes, history, start)
    foreach(g -> _check_primary_seed(g, history, start), R.kernels)
    return nothing
end

# The rule covers the routes when every route coupling has its own
# pullback.
_kernel_adjoint(R::Routes) = _all_pressure_pullbacks(R.couplings)
_all_pressure_pullbacks(::Tuple{}) = true
function _all_pressure_pullbacks(Cs::Tuple)
    return uses_adjoint(first(Cs), Pressure()) &&
        _all_pressure_pullbacks(Base.tail(Cs))
end

# The routes as a run reads them: the couplings, each kernel oldest first
# and its length, and two work vectors at the buffer eltype for one route's
# convolution and its coupled pressure, or their cotangents.
struct _RouteKernels{C <: Tuple, G <: Tuple, L <: Tuple, W}
    couplings::C
    kernels::G
    lags::L
    z::W
    w::W
end
function _run_kernel(::Type{Tp}, R::Routes, h, S) where {Tp}
    return _RouteKernels(
        R.couplings, map(_oldest_first, R.kernels), map(_nlags, R.kernels),
        _zeros(h, Tp, S), _zeros(h, Tp, S)
    )
end

function _kwork(k::_RouteKernels, S, L)
    return sum(map((g, Lr) -> _kwork(g, S, Lr) + S, k.kernels, k.lags))
end

# The routes mix strata, so the strata do not run on their own.
_independent(::_PointwiseCoupling, ::_RouteKernels, ::Tuple) = false

# The routes' pressure fills `p` before each step, and the coupling is `I`.
# Route `r` reads the last `L_r` rows of the window, buffer rows
# `t + L - L_r` to `t + L - 1`.
function _prepare!(ex, p, q, C::UniformScaling, k::_RouteKernels, H, t, τ, L)
    fill!(p, zero(eltype(p)))
    _routes_pressure!(ex, p, k.z, k.w, k.couplings, k.kernels, k.lags, H, t, τ, L)
    return nothing
end
function _pressure_at(C::UniformScaling, k::_RouteKernels, p, q, H, t, τ, L, a)
    return p[a], C.λ * p[a]
end
_routes_pressure!(ex, p, z, w, ::Tuple{}, ::Tuple{}, ::Tuple{}, H, t, τ, L) = nothing
function _routes_pressure!(ex, p, z, w, Cs::Tuple, gs::Tuple, Ls::Tuple, H, t, τ, L)
    Lr = first(Ls)
    _kernel_pressure!(ex, z, first(gs), H, t + L - Lr, τ, Lr)
    forward(first(Cs), Pressure(), w, z, τ)
    for a in eachindex(p, w)
        p[a] += w[a]
    end
    return _routes_pressure!(
        ex, p, z, w, Base.tail(Cs), Base.tail(gs), Base.tail(Ls), H, t, τ, L
    )
end

# The reverse pass, per route: recompute its kernel convolution `z` from
# the buffer, send the pressure's cotangent `p̄` back through its coupling
# into `z̄`, then through its kernel into the buffer. The mirrors of the
# route couplings and kernels sit in the kernel's mirror.
_route_mirrors(::Nothing, xs) = map(_ -> nothing, xs)
_route_mirrors(x̄s, xs) = x̄s

function _kernel_buffer(ḡ, k::_RouteKernels, H, S, L)
    ḡs = _route_mirrors(cotangent(ḡ, :kernels), k.kernels)
    return map((ḡr, g, Lr) -> _kernel_buffer(ḡr, g, H, S, Lr), ḡs, k.kernels, k.lags)
end

function _kernel_back!(kbuf, ḡ, k::_RouteKernels, p̄, H, H̄, t, τ, L)
    C̄s = _route_mirrors(cotangent(ḡ, :couplings), k.couplings)
    ḡs = _route_mirrors(cotangent(ḡ, :kernels), k.kernels)
    _routes_back!(
        kbuf, ḡs, C̄s, k.couplings, k.kernels, k.lags, k.z, k.w, p̄, H, H̄, t, τ, L
    )
    return nothing
end
_routes_back!(::Tuple{}, ḡs, C̄s, Cs, gs, Ls, z, z̄, p̄, H, H̄, t, τ, L) = nothing
function _routes_back!(kbuf::Tuple, ḡs, C̄s, Cs, gs, Ls, z, z̄, p̄, H, H̄, t, τ, L)
    Lr, g = first(Ls), first(gs)
    tr = t + L - Lr
    _kernel_pressure!(Serial(), z, g, H, tr, τ, Lr)
    fill!(z̄, zero(eltype(z̄)))
    _pressure_back!(z̄, first(C̄s), first(Cs), p̄, z, τ)
    _kernel_back!(first(kbuf), first(ḡs), g, z̄, H, H̄, tr, τ, Lr)
    return _routes_back!(
        Base.tail(kbuf), Base.tail(ḡs), Base.tail(C̄s), Base.tail(Cs),
        Base.tail(gs), Base.tail(Ls), z, z̄, p̄, H, H̄, t, τ, L
    )
end

function _kernel_finish!(ḡ, kbuf::Tuple)
    foreach(_kernel_finish!, _route_mirrors(cotangent(ḡ, :kernels), kbuf), kbuf)
    return nothing
end

function _check_coupling_shape(R::Routes)
    throw(
        ArgumentError(
            "Routes is a kernel: use Recurrence(Routes(...)) with coupling " *
                "I, not coupling = $(_describe(R))"
        )
    )
end
