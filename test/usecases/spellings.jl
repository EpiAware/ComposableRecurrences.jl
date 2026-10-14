# Each stock-and-flow model in the spelling that replaced an earlier one
# gives the values the earlier spelling gave, recorded to full precision
# before the change. The models are the docstring examples, so these
# items keep their numbers whatever the doctests round to.

@testitem "Use case: a pool without a draw gives the values of Flows with Rate kinds" tags = [:usecase] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # Was `Flows(Flow(1 => 2, 0.3), Flow(1 => 0, 0.4), Flow(2 => 0, 0.1))`,
    # each a `Rate`; a bare demand is still a hazard rate.
    ward = CR.Pool(;
        stocks = (:U, :C), draw = nothing,
        flows = (CR.Flow(:U => :C, 0.3), CR.Flow(:U => 0, 0.4), CR.Flow(:C => 0, 0.1))
    )
    r = Recurrence([1.0]; modifiers = (ward,))
    admitted = [fill(10.0, 1, 4); zeros(1, 4)]
    y, st = CR.with_state(r; history = zeros(2, 1), add = admitted)
    @test y[1, :] ≈ [
        4.965853037914095, 7.431822677330159, 8.65638695985998, 9.264487586112159,
    ] rtol = 1.0e-12
    @test y[2, :] ≈ [
        2.157491555179673, 5.181049242759134, 8.448908241308272, 11.669988049894325,
    ] rtol = 1.0e-12
    @test st.states[1] ≈ [0.0, 4.0250997316062085] rtol = 1.0e-12
end

@testitem "Use case: share and count flows give the values of the Linear and Amount kinds" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    # Was `Flows` with `Flow(1 => 0, Linear(TimeVarying(fill(0.1, 6))))` and
    # `Flow(2 => 0, Amount(TimeVarying(PerStratum(fill(0.5, 2, 6)))))`.
    ward = CR.Pool(;
        stocks = 2, draw = nothing, flows = (
            CR.Flow(1 => 2, PerStratum([0.3, 0.2])),
            CR.Flow(1 => 0, TimeVarying(fill(0.1, 6)); form = CR.Share()),
            CR.Flow(2 => 0, 0.1),
            CR.Flow(
                2 => 0, TimeVarying(PerStratum(fill(0.5, 2, 6)));
                form = CR.Truncate()
            ),
        )
    )
    adm = [
        10.0 8.0 6.0 4.0 2.0 1.0; 5.0 5.0 5.0 5.0 5.0 5.0;
        0.0 0.0 0.0 0.0 0.0 0.0; 1.0 0.0 0.0 0.0 0.0 0.0
    ]
    r = Recurrence([1.0]; modifiers = (ward,))
    y = r(; history = zeros(4, 1), add = adm)
    expected = [
        [
            6.4081822068171785, 9.233025685030572, 9.761600415080197,
            8.818684291724482, 6.932810017940134, 5.083489200702503,
        ],
        [
            3.5936537653899094, 6.1765232424901235, 8.032910966868494,
            9.367153914015681, 10.326115352207765, 11.015350428852306,
        ],
        [
            2.0918177931828215, 5.127093312090112, 8.08730857598837,
            10.384455492605085, 11.700249740250024, 12.142863580787354,
        ],
        [
            1.3111836526460503, 2.244173177192005, 3.5565718146485867,
            5.080585213992058, 6.701426777546594, 8.341855090686984,
        ],
    ]
    for k in 1:4
        @test y[k, :] ≈ expected[k] rtol = 1.0e-12
    end
    # Was `Flow(1 => 0, Linear(θ[2]))` and `Flow(2 => 0, Amount(θ[4]))`.
    function run(θ)
        fl = CR.Pool(;
            stocks = 2, draw = nothing, flows = (
                CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]; form = CR.Share()),
                CR.Flow(2 => 0, θ[3]), CR.Flow(2 => 0, θ[4]; form = CR.Truncate()),
            )
        )
        r = Recurrence([1.0]; modifiers = (fl,))
        return r(; history = zeros(2, 1), add = [fill(10.0, 1, 8); zeros(1, 8)])
    end
    @test ForwardDiff.gradient(θ -> sum(run(θ)), [0.3, 0.1, 0.1, 0.5]) ≈ [
        2.8407073275040133, -568.1334926059575, -229.0565344570363,
        -29.04541828738811,
    ] rtol = 1.0e-10
    # Was `Depletion(1000.0; removals = 3.0, flows = (Flow(1 => 0, 0.01),
    # Flow(1 => 0, Linear(0.002))))`.
    d = CR.Pool(
        1000.0; flows = (
            CR.Flow(:S => 0, 3.0; form = CR.Truncate()), CR.Flow(:S => 0, 0.01),
            CR.Flow(:S => 0, 0.002; form = CR.Share()),
        )
    )
    y = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 8); history = [5.0])
    @test y ≈ [
        2.9955044966270243, 6.652927267489164, 8.596099981869761, 12.120707723783651,
        16.73655431043126, 22.273150166745683, 29.044080713035257, 36.44220649764632,
    ] rtol = 1.0e-12
    # Was `Depletion(100.0, Truncate(); removals = 3.0, protected =
    # Protected(0.2), flows = (Flow(2 => 1, Linear(0.05)),
    # Flow(2 => 0, Amount(1.0))))`. The pool is small enough that the draw
    # binds from the seventh step.
    d = CR.Pool(
        100.0; stocks = (:S, :V), draw = (:S => 1, :V => 0.2) => CR.Truncate(),
        flows = (
            CR.Flow(:S => :V, 3.0; form = CR.Truncate()),
            CR.Flow(:V => :S, 0.05; form = CR.Share()),
            CR.Flow(:V => 0, 1.0; form = CR.Truncate()),
        )
    )
    r = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))
    y, st = CR.with_state(r, fill(2.0, 8); history = [5.0])
    @test y ≈ [
        3.0, 6.8, 9.08, 13.448, 19.8688, 29.00128, 5.902108198293716,
        1.179962360341256,
    ] rtol = 1.0e-12
    @test st.states[1] ≈ [0.0, 3.7198494413650236] rtol = 1.0e-12
end

@testitem "Use case: a pool with two stocks gives the values of Depletion with Protected" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    leaky(N, σ, doses, flows...; initial = nothing, form = CR.Hazard()) = CR.Pool(
        N; stocks = (:S, :V), initial, draw = (:S => 1, :V => σ) => form,
        flows = (CR.Flow(:S => :V, doses; form = CR.Truncate()), flows...)
    )
    g = [0.3, 0.5, 0.2]
    # Was `Depletion(1000.0; removals = TimeVarying(fill(5.0, 10)),
    # protected = Protected(0.3))`.
    d = leaky(1000.0, 0.3, TimeVarying(fill(5.0, 10)))
    y = Recurrence(g; modifiers = (d,))(fill(2.0, 10); history = [5.0])
    @test y ≈ [
        2.9955044966270243, 6.730251097454152, 8.842623960309435,
        12.765026691442971, 18.150172258587972, 25.032849274164587,
        33.976490148497284, 44.51742666556528, 55.963852173872965,
        66.66759063907847,
    ] rtol = 1.0e-12
    # Was `Depletion(1000.0; removals = 5.0, protected = Protected(0.3),
    # flows = Flow(2 => 1, 0.1))`.
    d = leaky(1000.0, 0.3, 5.0, CR.Flow(:V => :S, 0.1))
    y, st = CR.with_state(Recurrence(g; modifiers = (d,)), fill(2.0, 6); history = [5.0])
    @test y ≈ [
        2.9955044966270243, 6.730251097454152, 8.845613154354453,
        12.779376124126909, 18.196111201531917, 25.150708995762596,
    ] rtol = 1.0e-12
    @test st.states[1] ≈ [901.8895137406164, 23.412921189526504] rtol = 1.0e-12
    # Was `Depletion(PerStratum([500.0, 800.0]), Floor(); removals =
    # PerStratum([4.0, 6.0]), protected = Protected(PerStratum([0.0, 0.5]);
    # pool0 = PerStratum([50.0, 100.0])))`.
    d = leaky(
        PerStratum([500.0, 800.0]), PerStratum([0.0, 0.5]), PerStratum([4.0, 6.0]);
        initial = (nothing, PerStratum([50.0, 100.0])), form = CR.Floor()
    )
    y = Recurrence(g; modifiers = (d,))(fill(2.0, 2, 8); history = [5.0 4.0; 3.0 2.0])
    @test y[1, :] ≈ [
        7.4, 10.201968, 14.346916826072372, 19.85657326997257, 26.226989305617774,
        33.22787079960978, 39.46945926738032, 43.3074457989293,
    ] rtol = 1.0e-12
    @test y[2, :] ≈ [
        4.4625, 6.1909819726562505, 9.35493462131601, 13.956343856909744,
        20.335677749008322, 29.249469028420837, 40.83435968982367, 54.88064661859447,
    ] rtol = 1.0e-12
    # Was `Depletion(1000.0; removals = TimeVarying(fill(θ[1], 10)),
    # protected = Protected(θ[2]), flows = Flow(2 => 1, θ[3]))`.
    function run(θ)
        d = leaky(1000.0, θ[2], TimeVarying(fill(θ[1], 10)), CR.Flow(:V => :S, θ[3]))
        return Recurrence(g; modifiers = (d,))(fill(2.0, 10); history = [5.0])
    end
    @test ForwardDiff.gradient(θ -> sum(run(θ)), [5.0, 0.3, 0.1]) ≈ [
        -2.6050995531441092, 19.321408591358114, 27.16492339422564,
    ] rtol = 1.0e-10
end
