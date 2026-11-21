# The package's own rules on a device backend: the forward pass and pullback
# of each call that takes the rule on device arrays, run on real device
# arrays and checked against the same passes on the host. JLArrays run
# kernels as Julia code, so they cannot catch a pullback a device compiler
# refuses. Included by `test/cuda/runtests.jl` and `test/opencl/runtests.jl`;
# not part of `Pkg.test`.
using Adapt: adapt
using LinearAlgebra: Diagonal, I
using Test
using ComposableRecurrences
using ComposableRecurrences: ComposableRecurrences as CR

# The values of a mirror's leaves, on the host, in order.
_leaves(x::AbstractArray) = Any[Array(x)]
_leaves(x::Base.RefValue) = Any[x[]]
_leaves(::Nothing) = Any[]
function _leaves(x::Union{Tuple, NamedTuple})
    return reduce(vcat, map(_leaves, collect(values(x))); init = Any[])
end

# A float argument's cotangent: a zero array, or a `Ref` for a scalar.
_mirror(a::AbstractArray{<:AbstractFloat}) = zero(a)
_mirror(a::AbstractFloat) = Ref(zero(a))
_mirror(a) = nothing

# A cotangent with the shape of `y`: the same on the host and the device for
# outputs of one shape, so a device output of another shape fails the check.
_cotangent_like(y) = cos.(0.37 .* reshape(1:length(y), size(y)))

# An output on the host, and a cotangent of its shape on arrays made by
# `move`: a traced run's output is the run's and each modifier's trace.
_host(y::AbstractArray) = Array(y)
function _host(y::Tuple)
    return vcat(vec(Array(first(y))), map(T -> vec(Array(T)), y[2].modifiers)...)
end
# A traced run's operator wraps the recurrence, which moves to the device.
_on_device(A, op) = adapt(A, op)
_on_device(A, w::CR._WithTrace) = CR._WithTrace(adapt(A, w.op))
_cotangent_of(y::AbstractArray, move) = move(_cotangent_like(Array(y)))
function _cotangent_of((Y, tr)::Tuple, move)
    T̄s = map(T -> _cotangent_of(T, move), tr.modifiers)
    return (_cotangent_of(Y, move), (; modifiers = T̄s, pressure = nothing))
end

# The output, the input's cotangent and the leaves of the parameter mirror
# after the rule's passes, for `op` on arrays made by `A`. A convolution's
# gain, add input and history take cotangents too.
function _rule_passes(op0, args0, A)
    op = A === identity ? op0 : _on_device(A, op0)
    move(x) = x isa AbstractArray ? A(x) : x
    args = map(move, args0)
    y, cache = CR._run_forward(op, args...)
    x̄ = zero(args[1])
    # A transpose's tail takes a cotangent too.
    takes = op isa Union{Convolution, CR._TransposedConvolution}
    rest = map(a -> takes ? _mirror(a) : nothing, Base.tail(args))
    piece = CR._zero_mirror(op)
    grads = (; piece, y = _cotangent_of(y, move), args = (x̄, rest...))
    CR._run_pullback!(grads, op, cache)
    return _host(y), Array(x̄), vcat(_leaves(piece), _leaves(rest))
end

# A user modifier per stratum with a scalar parameter and no `pullback!`,
# whose step reverses through its local derivative in a kernel.
struct _DevShrink{A}
    a::A
end
CR.blocks(::_DevShrink) = (1, 1)
function CR.forward!(m::_DevShrink, ::CR.Step, v, s, t)
    for k in eachindex(v, s)
        v[k] = v[k] / (1 + m.a * v[k])
    end
    return nothing
end

# The rule cases, each an operator and its rule arguments on the host, for
# `S` strata.
function _rule_cases(S)
    T, L = 30, 5
    pmf = collect(range(1.0, 2.0; length = L)) ./ (1.5L)
    x = 1 .+ 0.5 .* abs.(sin.((1:S) .+ (1:T)'))
    h = fill(1.0, S, L)
    G = pmf .* (1 .+ 0.1 .* sin.((1:L) .+ (1:T)'))
    GS = [pmf[i] * (1 + 0.1 * sin(a + i + t)) for a in 1:S, i in 1:L, t in 1:T]
    C = Matrix(0.5I, S, S) .+ 0.5 / S
    CT = [
        (a == b ? 0.5 : 0.5 / S) * (1 + 0.1 * sin(a + b + t))
            for a in 1:S, b in 1:S, t in 1:T
    ]
    tail = repeat(x[:, end], 1, L - 1)
    # Ragged columns, held flat as a device holds them; by output time a
    # recurrence's columns may be empty.
    ragged(ns) = CR._Ragged([pmf[1:n] .* (1 + 0.1 * sin(n)) for n in ns])
    by_input = ragged([min(L, T - τ + 1) for τ in 1:T])
    by_output = ragged([mod(τ, L + 1) for τ in 1:T])
    # A kernel per pair of strata, fixed and over time.
    PP = [pmf[i] * (1 + 0.1 * sin(a + 2b)) / S for a in 1:S, b in 1:S, i in 1:L]
    PT = [
        pmf[i] * (1 + 0.1 * sin(a + 2b + t)) / S
            for a in 1:S, b in 1:S, i in 1:L, t in 1:T
    ]
    flow = CR.Flow(:S => 0, 0.1; form = CR.Share())
    pools = (
        CR.Depletion(200.0, CR.Hazard(), flow),
        CR.Depletion(PerStratum(fill(150.0, S)), CR.Floor()),
    )
    conv(k) = (Convolution(k), (x, true, nothing, nothing, 1, nothing))
    recent = CR.Recent(pmf[1:3])
    feedback = CR.Transform(*, CR.Derived(exp, -0.05 * recent))
    # The same read through a coupling, which reads every stratum's window.
    across = CR.Transform(
        *, CR.Derived(exp, -0.05 * CR.Recent(pmf[1:3]; coupling = C))
    )
    # Two routes of different lengths, each a dense coupling and a kernel.
    near = Matrix(0.3I, S, S) .+ 0.1 / S
    routes = Pairwise(C => pmf[1:(L - 1)], near => pmf)
    # A gain or add input per stratum and time, per time or shared.
    gain, add = 0.5 .* x, collect(range(0.1, 1.0; length = T))
    scaled(g, a) = (Convolution(pmf), (x, g, a, fill(1.0, S, 2), 1, nothing))
    function rec(r; start = 1)
        return (r, (CR._run_args(r, x, h, nothing, nothing, start)..., nothing))
    end
    # Modifiers with a vector step: two pools, two draws on one pool, a
    # queue and grouped totals.
    hazard = CR.Hazard(; weights = (S = 1, V = 0.5))
    doses = CR.Flow(:S => :V, PerStratum(fill(0.5, S)); form = CR.Truncate())
    two_pools = CR.Depletion(
        PerStratum(fill(60.0, S)), hazard, doses; pools = (:S, :V)
    )
    two_draws = CR.Depletion(
        60.0, CR.Hazard(), flow, CR.Floor(); pools = (S = 50.0,)
    )
    queued = CR.Depletion(
        CR.Flow(0 => :B, 2.0; form = CR.Truncate()),
        CR.Truncate(; overflow = :queue); pools = (B = 50.0,)
    )
    totals = CR.Allocate([1:(S ÷ 2), (S ÷ 2 + 1):S], PerStratum(fill(1.0, 2)))
    # The same totals importing by a pattern, with a spill in the first group.
    # As `imported` in the unit tests, which this environment does not load.
    pattern = zeros(S, S)
    pattern[1, S], pattern[2, S], pattern[S, 1] = 0.6, 0.4, 1.0
    within = Matrix(1.0I, S, S)
    within[1:2, 1:2] .= [0.9 0.1; 0.1 0.9]
    imported = CR.Allocate(
        [1:(S ÷ 2), (S ÷ 2 + 1):S], PerStratum(fill(6.0, 2));
        imports = (0.2, pattern), spill = CR.Redistribute(within)
    )
    stepped(m) = rec(Recurrence(pmf; modifiers = (m,)))
    # The same with each modifier's trace, written and reversed per stratum
    # or group.
    function traced(ms...)
        r, args = rec(Recurrence(pmf; modifiers = ms))
        return CR._WithTrace(r), args
    end
    # Moves between strata: a matrix, and a kernel with an intensity over
    # time.
    moves = CR.Redistribute(0.9 .* C; leak = true)
    E = [0.1 + 0.01 * k + 0.005 * t for k in 1:S, t in 1:T]
    movement = CR.Redistribute(0.6 .* (ones(S, S) .- I(S)) ./ (S - 1), E)
    # The intensity read from recent outputs, whose scale every origin
    # shares.
    flows = 0.6 .* (ones(S, S) .- I(S)) ./ (S - 1)
    from_recent = CR.Redistribute(
        flows, CR.Derived(x -> 0.2 * tanh(x), 0.05 * CR.Recent(pmf[1:3]))
    )
    # Kernels computed from a hazard over time: shared by the strata and
    # confirmed from the lag after entry, one per stratum, and one through a
    # map, whose partials come from a local forward-mode derivative.
    hz = 0.1 .+ 0.05 .* sin.(1:T)
    HZ = [0.1 + 0.05 * sin(k + t) for k in 1:S, t in 1:T]
    computed(w) = TimeVarying(w, CR.Primary())
    confirmed = pmf * (1 - CR.Survival(TimeVarying(hz); from = 1))
    stratified = pmf * CR.Survival(TimeVarying(PerStratum(HZ)))
    mapped = pmf * CR.Survival(CR.Derived(exp, TimeVarying(log.(hz))))
    cases = [
        "Convolution, vector kernel" => conv(pmf),
        "Convolution, per-stratum kernel" => conv(PerStratum(repeat(pmf', S))),
        "Convolution, time-varying kernel" => conv(TimeVarying(G)),
        "Convolution, per-stratum time-varying kernel" =>
            conv(TimeVarying(PerStratum(GS))),
        "Convolution, per-stratum time-varying kernel by output" =>
            conv(TimeVarying(PerStratum(GS), CR.Primary())),
        "Convolution, ragged kernel" => conv(TimeVarying(by_input)),
        "Convolution, ragged kernel by output" =>
            conv(TimeVarying(by_input, CR.Primary())),
        "Convolution, gain per stratum and time, add per time" =>
            scaled(gain, add),
        "Convolution, scalar gain, add per stratum and time" =>
            scaled(0.7, gain),
        "Recurrence, identity coupling" => rec(Recurrence(pmf)),
        "Recurrence, Diagonal coupling" =>
            rec(Recurrence(pmf; coupling = Diagonal(fill(0.8, S)))),
        "Recurrence, dense coupling" => rec(Recurrence(pmf; coupling = C)),
        "Recurrence, coupling over time" =>
            rec(Recurrence(TimeVarying(G); coupling = TimeVarying(CT))),
        "Recurrence, pools and a shift" => rec(
            Recurrence(pmf; modifiers = (pools..., CR.Transform(+, 0.5)))
        ),
        "Recurrence, feedback from recent outputs" => rec(
            Recurrence(pmf; coupling = C, modifiers = (feedback,))
        ),
        "Recurrence, feedback from recent outputs across strata" => rec(
            Recurrence(pmf; modifiers = (across,))
        ),
        "Recurrence, routes of two lengths" => rec(Recurrence(routes)),
        "Recurrence, a user modifier with a scalar parameter" =>
            rec(Recurrence(pmf; coupling = C, modifiers = (_DevShrink(0.1),))),
        "Recurrence, time-varying kernel" => rec(Recurrence(TimeVarying(G))),
        "Recurrence, per-stratum time-varying kernel" =>
            rec(Recurrence(TimeVarying(PerStratum(GS)))),
        "Recurrence, ragged kernel by output" =>
            rec(Recurrence(TimeVarying(by_output, CR.Primary())); start = L + 1),
        "Recurrence, pairwise kernel" => rec(Recurrence(Pairwise(PP))),
        "Recurrence, pairwise kernel over time" =>
            rec(Recurrence(TimeVarying(Pairwise(PT)))),
        "Recurrence, two pools" => stepped(two_pools),
        "Recurrence, two draws on one pool" => stepped(two_draws),
        "Recurrence, a queue" => stepped(queued),
        "Recurrence, grouped totals" => stepped(totals),
        "Recurrence, grouped totals with imports and a spill" =>
            stepped(imported),
        "Recurrence, a matrix of moves" => stepped(moves),
        "Recurrence, movement of a kernel and an intensity" =>
            stepped(movement),
        "Recurrence, traces of pools per stratum" => traced(pools...),
        "Recurrence, traces of two pools and of a queue" =>
            traced(two_pools, queued),
        "Recurrence, trace of two draws on one pool" => traced(two_draws),
        "Recurrence, traces of pools beside a matrix of moves" =>
            traced(pools..., moves),
        "Recurrence, movement read from recent outputs" =>
            stepped(from_recent),
        "Convolution, kernel from a hazard and a survival" =>
            conv(computed(confirmed)),
        "Convolution, survival per stratum" => conv(computed(stratified)),
        "Recurrence, kernel shortened by a mapped hazard" =>
            rec(Recurrence(computed(mapped); coupling = C); start = L + 1),
        # The transposes of a fixed kernel and of one over time by output,
        # each over a series extended past its end.
        "Convolution transpose, fixed kernel" =>
            (transpose(Convolution(pmf)), (x, tail, 1, nothing)),
        "Convolution transpose, kernel over time by output" => (
            transpose(Convolution(TimeVarying(G, CR.Primary()))),
            (x, tail, 2, nothing),
        ),
        # Ends that go back, so a time falls in two windows.
        "Window sums, time last" =>
            (CR._WindowSums([4, 11, 7, 30], T, 2), (x,)),
        "Window sums, time first" =>
            (CR._WindowSums([4, 11, 7, 30], T, 1), (permutedims(x),)),
    ]
    return cases, x
end

# Runs every rule case on arrays made by `A`, at a few strata and at more
# strata than kernel blocks, so the blocks' copies of shared cotangents
# are summed.
function device_rule_tests(title, A)
    return @testset "$title" begin
        for S in (4, CR._KERNEL_BLOCKS + 1)
            cases, x = _rule_cases(S)
            for (name, (op, args)) in cases
                @testset "$name, $S strata" begin
                    y0, x̄0, p̄0 = _rule_passes(op, args, identity)
                    y1, x̄1, p̄1 = _rule_passes(op, args, A)
                    @test y1 ≈ y0
                    @test x̄1 ≈ x̄0
                    @test length(p̄1) == length(p̄0)
                    @test all(map(≈, p̄1, p̄0))
                end
            end
        end
    end
end
