# The forward pass on GPU arrays, run on JLArrays without a GPU: every
# operator, coupling and built-in modifier gives the CPU values with every
# array on the device, without scalar indexing, and returns device arrays.

@testmodule GPUCases begin
    using ComposableRecurrences
    using ComposableRecurrences: Add, Allocate, Clamp, Depletion, Floor,
        Primary, Protected, Redistribute, Transform, contributions, with_state
    using JLArrays: JLSparseMatrixCSR
    using LinearAlgebra: Diagonal, I
    using SparseArrays: sparse

    const S, T, L = 3, 20, 4
    const g0 = [0.4, 0.3, 0.2, 0.1]
    const R0 = collect(range(0.9, 1.2; length = T))
    const RS = [0.9 + 0.1 * k + 0.01 * t for k in 1:S, t in 1:T]
    const H1 = [1.0, 2.0, 1.5, 1.0]
    const HS = [1.0 + 0.5 * k + 0.1 * i for k in 1:S, i in 1:L]
    const K0 = [0.8 0.1 0.1; 0.2 0.7 0.1; 0.1 0.2 0.7]
    const x0 = collect(range(1.0, 3.0; length = T))
    const HX = [0.5, 1.0, 1.5]
    # Time-varying kernels: lags × time, strata × lags × time and
    # strata × strata × lags × time.
    const TVK = repeat(g0, 1, T) .* (1 .+ 0.01 .* (1:T)')
    const TVPS = repeat(reshape(TVK, 1, L, T), S) .* (1:S) ./ S
    const TVPW = reshape(K0, S, S, 1, 1) .* reshape(TVK, 1, 1, L, T)
    const NS = [60.0, 50.0, 40.0]
    const TOT = [4.0 + 0.2 * t + p for p in 1:2, t in 1:T]

    # A sparse coupling on the host, or in CSR form on the device.
    _sparse(d, K) = d === identity ? sparse(K) : JLSparseMatrixCSR(sparse(K))

    # Each case maps `d`, which moves an array to the device (or leaves it
    # on the host), to the output of one call with every array moved.
    const CASES = [
        "Recurrence, fixed kernel" =>
            d -> Recurrence(d(g0))(d(R0); history = d(H1)),
        "Recurrence, scalar gain and add" =>
            d -> Recurrence(d([0.5, 0.2]))(
            1.0; history = d(H1), add = d(0.1 .* sin.(1:T))
        ),
        "Recurrence, strata with add" =>
            d -> Recurrence(d(g0))(d(RS); history = d(HS), add = d(0.1 .* RS)),
        "Recurrence, start and prepend" =>
            d -> Recurrence(d(g0))(d(R0); history = d(H1), start = 5, prepend = true),
        "Recurrence, PerStratum kernel" =>
            d -> Recurrence(PerStratum(d(repeat(g0', S) .* (1:S) ./ S)))(
            d(RS); history = d(HS)
        ),
        "Recurrence, Pairwise kernel" =>
            d -> Recurrence(Pairwise(d(reshape(K0, S, S, 1) .* reshape(g0, 1, 1, L))))(
            d(RS); history = d(HS)
        ),
        "Recurrence, TimeVarying kernel" =>
            d -> Recurrence(TimeVarying(d(TVK)))(d(R0); history = d(H1)),
        "Recurrence, TimeVarying PerStratum kernel" =>
            d -> Recurrence(TimeVarying(PerStratum(d(TVPS))))(d(RS); history = d(HS)),
        "Recurrence, TimeVarying Pairwise kernel" =>
            d -> Recurrence(TimeVarying(Pairwise(d(TVPW))))(d(RS); history = d(HS)),
        "Recurrence, Primary kernel" =>
            d -> Recurrence(TimeVarying(d(TVK), Primary()))(
            d(R0); history = d(H1), start = 5
        ),
        "Recurrence, Primary PerStratum kernel" =>
            d -> Recurrence(TimeVarying(PerStratum(d(TVPS)), Primary()))(
            d(RS); history = d(HS), start = 5
        ),
        "Recurrence, Primary Pairwise kernel" =>
            d -> Recurrence(TimeVarying(Pairwise(d(TVPW)), Primary()))(
            d(RS); history = d(HS), start = 5
        ),
        "Recurrence, inputs as views" =>
            d -> Recurrence(d(g0))(view(d(RS), :, 1:T); history = d(HS)),
        "Recurrence, dense coupling" =>
            d -> Recurrence(d(g0); coupling = d(K0))(d(RS); history = d(HS)),
        "Recurrence, sparse coupling" =>
            d -> Recurrence(d(g0); coupling = _sparse(d, K0))(d(RS); history = d(HS)),
        "Recurrence, Diagonal coupling" =>
            d -> Recurrence(d(g0); coupling = Diagonal(d([0.5, 1.0, 1.5])))(
            d(RS); history = d(HS)
        ),
        "Recurrence, scaled I coupling" =>
            d -> Recurrence(d(g0); coupling = 0.5I)(d(RS); history = d(HS)),
        "Recurrence, TimeVarying coupling" =>
            d -> Recurrence(d(g0); coupling = TimeVarying(d(repeat(K0, 1, 1, T))))(
            d(RS); history = d(HS)
        ),
        "Convolution, fixed kernel" =>
            d -> Convolution(d(g0))(d(x0); history = d(HX)),
        "Convolution, strata with gain and history" =>
            d -> Convolution(d(g0))(d(RS); history = d(HS[:, 1:3]), gain = d(RS)),
        "Convolution, gain and add" =>
            d -> Convolution(d(g0))(d(x0); gain = d(R0), add = d(0.1 .* x0)),
        "Convolution, start and stop" =>
            d -> Convolution(d(g0))(d(x0); start = 3, stop = 15),
        "Convolution, PerStratum kernel" =>
            d -> Convolution(PerStratum(d(repeat(g0', S))))(d(RS)),
        "Convolution, TimeVarying kernel, Secondary()" =>
            d -> Convolution(TimeVarying(d(TVK)))(d(x0); history = d(HX)),
        "Convolution, TimeVarying kernel, Primary()" =>
            d -> Convolution(TimeVarying(d(TVK), Primary()))(d(x0)),
        "Convolution, TimeVarying PerStratum kernel, Secondary()" =>
            d -> Convolution(TimeVarying(PerStratum(d(TVPS))))(d(RS)),
        "Convolution, TimeVarying PerStratum kernel, Primary()" =>
            d -> Convolution(TimeVarying(PerStratum(d(TVPS)), Primary()))(d(RS)),
        "contributions" =>
            d -> contributions(Convolution(d(g0)), d(x0)),
        "Depletion (Hazard)" =>
            d -> Recurrence(d(g0); modifiers = (Depletion(60.0),))(
            d(1.5 .* R0); history = d(H1)
        ),
        "Depletion (Floor), PerStratum population" =>
            d -> Recurrence(d(g0); modifiers = (Depletion(PerStratum(d(NS)), Floor()),))(
            d(RS); history = d(HS)
        ),
        "Depletion, heterogeneity and starting pool" =>
            d -> Recurrence(
            d(g0); modifiers = (Depletion(60.0; heterogeneity = 2.0, pool0 = 50.0),)
        )(d(R0); history = d(H1)),
        "Depletion with removals" =>
            d -> Recurrence(
            d(g0);
            modifiers = (Depletion(60.0; removals = TimeVarying(d(0.5 .+ 0.2 .* sin.(1:T)))),)
        )(d(1.5 .* R0); history = d(H1)),
        "Depletion with a protected pool" =>
            d -> Recurrence(
            d(g0);
            modifiers = (
                Depletion(
                    PerStratum(d(NS));
                    removals = TimeVarying(PerStratum(d(fill(0.3, S, T)))),
                    protected = Protected(
                        PerStratum(d([0.3, 0.2, 0.1])); pool0 = PerStratum(d([1.0, 2.0, 3.0]))
                    )
                ),
            )
        )(d(RS); history = d(HS)),
        "Allocate" =>
            d -> Recurrence(
            d(g0); modifiers = (Allocate([1:2, 3:3], TimeVarying(PerStratum(d(TOT)))),)
        )(d(RS); history = d(HS)),
        "Allocate, one total per group" =>
            d -> Recurrence(
            d(g0); modifiers = (Allocate([[1, 3], [2]], PerStratum(d([6.0, 3.0]))),)
        )(d(RS); history = d(HS)),
        "Transform" =>
            d -> Recurrence(
            d(g0);
            modifiers = (
                Transform((v, c) -> c * v / (c + v), TimeVarying(d(5.0 .+ 0.1 .* (1:T)))),
            )
        )(d(R0); history = d(H1)),
        "Transform with a tuple and Derived" =>
            d -> Recurrence(
            d(g0);
            modifiers = (
                Transform(
                    (v, θ) -> θ[1] * v + θ[2],
                    (
                        0.8 * Derived(exp, TimeVarying(d(0.03 .* sin.(1:T)))),
                        PerStratum(d([0.1, 0.2, 0.3])),
                    )
                ),
            )
        )(d(RS); history = d(HS)),
        "Add" =>
            d -> Recurrence(d(g0); modifiers = (Add(TimeVarying(d(0.1 .* cos.(1:T)))),))(
            d(R0); history = d(H1)
        ),
        "Clamp" =>
            d -> Recurrence(
            d(g0);
            modifiers = (
                Clamp(TimeVarying(PerStratum(d(fill(1.2, S, T)))), PerStratum(d([1.5, 1.6, 1.7]))),
            )
        )(d(RS); history = d(HS)),
        "Redistribute" =>
            d -> Recurrence(
            d(g0); modifiers = (Redistribute(d(K0 - 0.5I), TimeVarying(d(0.1 .+ 0.001 .* (1:T)))),)
        )(d(RS); history = d(HS)),
        "Redistribute, one intensity per stratum" =>
            d -> Recurrence(
            d(g0); modifiers = (Redistribute(d(K0 - 0.5I), PerStratum(d([0.1, 0.2, 0.3]))),)
        )(d(RS); history = d(HS)),
        "Modifiers in a chain with a dense coupling" =>
            d -> Recurrence(
            d(g0); coupling = d(K0),
            modifiers = (
                Add(0.1), Depletion(PerStratum(d(NS))),
                Allocate([1:2, 3:3], TimeVarying(PerStratum(d(TOT)))), Clamp(0.0, 10.0),
            )
        )(d(RS); history = d(HS)),
    ]

    # A run stopped part way and resumed from its state, with the states of
    # pointwise and vector-step modifiers.
    function resumed(d)
        r = Recurrence(
            d(g0);
            modifiers = (
                Depletion(PerStratum(d(NS))), Redistribute(d(K0 - 0.5I), 0.1),
                Depletion(60.0; removals = 0.2, protected = Protected(0.3)),
                Allocate([1:2, 3:3], TimeVarying(PerStratum(d(TOT)))),
            )
        )
        y1, state = with_state(r, d(RS); history = d(HS), stop = 8)
        return y1, state, r(d(RS); state)
    end
end

@testitem "JLArrays: every operator, coupling and modifier runs forward on the device" setup = [GPUCases] begin
    using JLArrays
    JLArrays.allowscalar(false)
    for (name, f) in GPUCases.CASES
        @testset "$name" begin
            y = f(JLArray)
            @test y isa JLArray
            @test Array(y) ≈ f(identity)
        end
    end
end

@testitem "JLArrays: a run resumed from a device state matches the CPU" setup = [GPUCases] begin
    using JLArrays
    JLArrays.allowscalar(false)
    y1, state, y2 = GPUCases.resumed(JLArray)
    c1, cstate, c2 = GPUCases.resumed(identity)
    @test y1 isa JLArray
    @test y2 isa JLArray
    @test state.history isa JLArray
    @test all(s -> s isa JLArray, state.states)
    @test Array(y1) ≈ c1
    @test Array(y2) ≈ c2
    @test Array(state.history) ≈ cstate.history
    @test all(map((s, c) -> Array(s) ≈ c, state.states, cstate.states))
    @test state.t == cstate.t
end

@testitem "JLArrays: dual numbers carry tangents through the device forward pass" setup = [GPUCases] begin
    using ForwardDiff: Dual, partials, value
    using JLArrays
    JLArrays.allowscalar(false)
    # One tangent direction on the inputs, pushed forward on the device and
    # on the CPU.
    dual(x, v) = Dual.(x, v)
    for name in (
            "Recurrence, dense coupling", "Recurrence, TimeVarying kernel",
            "Convolution, TimeVarying kernel, Primary()", "Depletion with a protected pool",
            "Redistribute", "Modifiers in a chain with a dense coupling",
        )
        f = Dict(GPUCases.CASES)[name]
        @testset "$name" begin
            cpu = f(x -> dual(x, ones(size(x))))
            y = f(x -> JLArray(dual(x, ones(size(x)))))
            @test y isa JLArray
            @test value.(Array(y)) ≈ value.(cpu)
            @test map(d -> partials(d, 1), Array(y)) ≈ map(d -> partials(d, 1), cpu)
        end
    end
end

@testitem "JLArrays: host parameters and ragged kernels on device inputs are errors" begin
    using ComposableRecurrences, JLArrays, SparseArrays
    using ComposableRecurrences: Depletion, Primary
    JLArrays.allowscalar(false)
    # JLArrays run kernels on the CPU, where a host array inside a kernel
    # works; on a GPU it does not, so the call refuses it.
    x, h = JLArray(ones(2, 5)), JLArray(ones(2, 2))
    g = JLArray([0.5, 0.5])
    for r in (
            Recurrence([0.5, 0.5]),
            Recurrence(g; coupling = [0.8 0.2; 0.1 0.9]),
            Recurrence(g; coupling = sparse([0.8 0.2; 0.1 0.9])),
            Recurrence(g; modifiers = (Depletion(PerStratum([50.0, 60.0])),)),
        )
        @test_throws ArgumentError r(x; history = h)
    end
    @test_throws ArgumentError Convolution([0.5, 0.5])(x)
    ks = [[0.5, 0.5], [1.0], [0.25, 0.75]]
    @test_throws ArgumentError Convolution(TimeVarying(ks, Primary()))(JLArray(ones(3)))
    @test_throws ArgumentError Recurrence(TimeVarying(ks))(
        JLArray(ones(3)); history = JLArray(ones(2))
    )
end

@testitem "JLArrays: wrappers and built-in modifiers adapt every array they hold" setup = [GPUCases] begin
    using Adapt: adapt
    using ComposableRecurrences
    using ComposableRecurrences: Add, Allocate, Clamp, Depletion, Protected,
        Redistribute, Transform
    using JLArrays
    # Inside a kernel each wrapper and modifier must hold device arrays only:
    # no `JLArray`, the host-side handle, is left after adapting.
    holds_host(x::AbstractArray) = x isa JLArray
    holds_host(x::Union{Number, Function, Nothing, Symbol}) = false
    holds_host(x::Tuple) = any(holds_host, x)
    holds_host(x::T) where {T} = any(i -> holds_host(getfield(x, i)), 1:fieldcount(T))
    v, m = JLArray([1.0, 2.0, 3.0]), JLArray(ones(3, 3))
    tv = TimeVarying(JLArray(ones(20)))
    for x in (
            PerStratum(v), Pairwise(JLArray(ones(3, 3, 2))), tv,
            TimeVarying(PerStratum(JLArray(ones(3, 20)))),
            ComposableRecurrences._oldest_first(Pairwise(JLArray(ones(3, 3, 2)))),
            Depletion(PerStratum(v); removals = tv, protected = Protected(PerStratum(v))),
            Add(tv), Clamp(PerStratum(v), tv), Redistribute(m, PerStratum(v)),
            Transform(*, 0.8 * Derived(exp, tv)),
        )
        @test holds_host(x)
        y = adapt(JLArrays.Adaptor(), x)
        @test typeof(y).name === typeof(x).name
        @test !holds_host(y)
    end
end
