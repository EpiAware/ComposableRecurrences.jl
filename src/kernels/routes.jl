# The kernel `Pairwise(C₁ => k₁, C₂ => k₂, ...)` builds, held as its routes'
# couplings and kernels in route order.
struct _Routes{C <: Tuple, G <: Tuple}
    "Each route's coupling."
    couplings::C
    "Each route's kernel, lag 1 first."
    kernels::G
    function _Routes(::_Checked, couplings::C, kernels::G) where {C <: Tuple, G <: Tuple}
        length(couplings) == length(kernels) || throw(
            ArgumentError(
                "Pairwise has $(length(couplings)) couplings and " *
                    "$(length(kernels)) kernels"
            )
        )
        isempty(couplings) && throw(ArgumentError("Pairwise needs at least one route"))
        foreach(_check_coupling_shape, couplings)
        # Only a kernel takes `Primary()` indexing.
        _check_times(:coupling, couplings, nothing)
        foreach(_check_route_kernel, kernels)
        return new{C, G}(couplings, kernels)
    end
end

function Pairwise(route::Pair, routes::Pair...)
    rs = (route, routes...)
    return _Routes(_Checked(), map(first, rs), map(last, rs))
end
function Pairwise(route, routes...)
    throw(
        ArgumentError(
            string(
                "Pairwise takes one S × S × L array, or routes as coupling => ",
                "kernel pairs; got ", join(map(_describe, (route, routes...)), ", ")
            )
        )
    )
end

# Printed as written.
function Base.show(io::IO, R::_Routes)
    show(io, Pairwise)
    print(io, "(")
    for (i, route) in enumerate(map(Pair, R.couplings, R.kernels))
        i > 1 && print(io, ", ")
        show(io, route)
    end
    print(io, ")")
    return nothing
end

# A rebuild from the fields skips the pairing.
_routes_flat(couplings, kernels) = _Routes(_Checked(), couplings, kernels)
ConstructionBase.constructorof(::Type{<:_Routes}) = _routes_flat

# A route kernel may hold delays until the operator is built with `lags`.
_check_route_kernel(g) = _has_delays(typeof(g)) ? nothing : _check_kernel_shape(g)
function _check_route_kernel(::_Routes)
    throw(ArgumentError("a route's kernel cannot itself be routes"))
end

_describe(R::_Routes) = _describe_routes(length(R.kernels))
_describe_routes(n) = string("Pairwise with ", n, n == 1 ? " route" : " routes")

_check_kernel_shape(::_Routes) = nothing
function _check_pairwise_coupling(::_Routes, coupling)
    return _check_unit_coupling(
        coupling,
        "Pairwise routes hold each route's coupling, so the Recurrence coupling"
    )
end

# The fold: one route is its kernel with its coupling, unless it is a
# pairwise kernel, which takes coupling `I`; routes on `λ * I` with vector
# kernels sum into one kernel. Decided from the types.
function _fold(R::_Routes, J::UniformScaling{Bool})
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
    foreach((C, gr) -> view(g, eachindex(gr)) .+= C.λ .* gr, Cs, gs)
    return g
end

_nlags(R::_Routes) = maximum(map(_nlags, R.kernels))

function _check_kernel_strata(R::_Routes, S)
    foreach(C -> _check_coupling(C, S), R.couplings)
    foreach(g -> _check_kernel_strata(g, S), R.kernels)
    return nothing
end

function _check_kernel_times(R::_Routes, stop)
    _check_times(:coupling, R.couplings, stop)
    foreach(g -> _check_kernel_times(g, stop), R.kernels)
    return nothing
end

function _check_primary_seed(R::_Routes, history, start)
    foreach(g -> _check_primary_seed(g, history, start), R.kernels)
    return nothing
end

# The rule covers the routes when it covers every route coupling, with its
# own pullback or a local derivative, as for the coupling of a
# `Recurrence`; the local step rebuilds and fits each route coupling as it
# does that coupling.
_kernel_adjoint(R::_Routes) = all(C -> _coupling_adjoint(C) !== :none, R.couplings)
_kernel_couplings(R::_Routes) = R.couplings

# The plain-AD note names the route couplings the rule cannot use.
function _no_adjoint_kernel(R::_Routes)
    return Tuple(_part_why(C) for C in R.couplings if _coupling_adjoint(C) === :none)
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
function _run_kernel(::Type{Tp}, R::_Routes, h, S) where {Tp}
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
# One route's coupled pressure; its own function so an AD backend can give
# it a rule.
_route_forward!(C, w, z, τ) = forward!(C, Pressure(), w, z, τ)
function _routes_pressure!(ex, p, z, w, Cs::Tuple, gs::Tuple, Ls::Tuple, H, t, τ, L)
    Lr = first(Ls)
    _kernel_pressure!(ex, z, first(gs), H, t + L - Lr, τ, Lr)
    _route_forward!(first(Cs), w, z, τ)
    p .+= w
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

# Each route's kernel buffer, and its coupling's dual-number buffers
# (`_pressure_buffers`), made once per reverse pass so a step allocates
# nothing.
struct _RouteBuffers{K <: Tuple, P <: Tuple}
    kernels::K
    pressures::P
end
function _kernel_buffer(ḡ, k::_RouteKernels, H, S, L)
    ḡs = _route_mirrors(cotangent(ḡ, :kernels), k.kernels)
    C̄s = _route_mirrors(cotangent(ḡ, :couplings), k.couplings)
    kbufs = map((ḡr, g, Lr) -> _kernel_buffer(ḡr, g, H, S, Lr), ḡs, k.kernels, k.lags)
    pbufs = map((C̄, C) -> _pressure_buffers(C̄, C, eltype(H)), C̄s, k.couplings)
    return _RouteBuffers(kbufs, pbufs)
end

function _kernel_back!(kbuf, ḡ, k::_RouteKernels, p̄, H, H̄, t, τ, L)
    C̄s = _route_mirrors(cotangent(ḡ, :couplings), k.couplings)
    ḡs = _route_mirrors(cotangent(ḡ, :kernels), k.kernels)
    _routes_back!(
        kbuf.kernels, kbuf.pressures, ḡs, C̄s, k.couplings, k.kernels, k.lags,
        k.z, k.w, p̄, H, H̄, t, τ, L
    )
    return nothing
end
# The routes share `z` and `w` and mix strata, so their pullback runs on the
# calling task.
function _kernels_back!(accs, kbuf, k::_RouteKernels, p̄, H, H̄, t, τ, L)
    _kernel_back!(kbuf, _own(first(accs).ḡ), k, p̄, H, H̄, t, τ, L)
    return nothing
end
function _routes_back!(
        ::Tuple{}, pbufs, ḡs, C̄s, Cs, gs, Ls, z, z̄, p̄, H, H̄, t, τ, L
    )
    return nothing
end
function _routes_back!(
        kbuf::Tuple, pbufs, ḡs, C̄s, Cs, gs, Ls, z, z̄, p̄, H, H̄, t, τ, L
    )
    Lr, g = first(Ls), first(gs)
    tr = t + L - Lr
    _kernel_pressure!(Serial(), z, g, H, tr, τ, Lr)
    fill!(z̄, zero(eltype(z̄)))
    _pressure_back!(z̄, first(C̄s), first(Cs), p̄, z, τ, first(pbufs))
    _kernel_back!(first(kbuf), first(ḡs), g, z̄, H, H̄, tr, τ, Lr)
    return _routes_back!(
        Base.tail(kbuf), Base.tail(pbufs), Base.tail(ḡs), Base.tail(C̄s),
        Base.tail(Cs), Base.tail(gs), Base.tail(Ls), z, z̄, p̄, H, H̄, t, τ, L
    )
end

function _kernel_finish!(ḡ, kbuf::_RouteBuffers)
    kbufs = kbuf.kernels
    foreach(_kernel_finish!, _route_mirrors(cotangent(ḡ, :kernels), kbufs), kbufs)
    return nothing
end

function _check_coupling_shape(R::_Routes)
    return _kernel_as_coupling_error(R, "Pairwise(C => k, ...)", "Pairwise")
end
