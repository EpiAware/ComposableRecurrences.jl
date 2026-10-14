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

@testitem "Use case: a pool filling its stock gives the values of Capacity with Beds" tags = [:usecase] begin
    using ComposableRecurrences, ForwardDiff
    CR = ComposableRecurrences
    beds(C, δ; overflow = :stratum, form = CR.Truncate(), initial = nothing) = CR.Pool(
        C; stocks = (:O,), initial, draw = form => :O, flows_first = true,
        flows = CR.Flow(:O => 0, δ; form = CR.Share()), overflow
    )
    # Was `Capacity(10.0, Beds(0.1); pairs = [1 => 2])`.
    demand = [4.0 3.0 5.0 6.0 2.0; 0.0 0.0 0.0 0.0 0.0]
    r = Recurrence([0.0]; modifiers = (beds(10.0, 0.1),))
    y = r(; history = zeros(2, 1), add = demand)
    @test y ≈ [4.0 3.0 4.06 1.0 1.0; 0.0 0.0 0.94 5.0 1.0] rtol = 1.0e-12
    # Was `Capacity(2.0, Beds(0.5); pairs = [1], overflow = Hold())`.
    r = Recurrence([0.0]; modifiers = (beds(2.0, 0.5; overflow = :queue),))
    y, st = CR.with_state(r; history = [0.0], add = [3.0, 1.0, 4.0, 0.0, 0.5, 0.0])
    @test y ≈ [2.0, 1.0, 1.0, 1.0, 1.0, 1.0] rtol = 1.0e-12
    @test st.states[1] ≈ [2.0, 1.5] rtol = 1.0e-12
    # Was `Capacity(TimeVarying(PerStratum(C)), Beds(PerStratum([0.2, 0.3]));
    # pairs = [1 => 3, 2 => 4], form = SoftTruncate(0.1),
    # initial = PerStratum([2.0, 1.0]))`.
    C = [5.0 5.0 4.0 4.0 6.0 6.0; 3.0 3.0 3.0 2.0 2.0 2.0]
    m = beds(
        TimeVarying(PerStratum(C)), PerStratum([0.2, 0.3]);
        form = CR.SoftTruncate(0.1), initial = PerStratum([2.0, 1.0])
    )
    dem = [
        4.0 3.0 5.0 6.0 2.0 1.0; 2.0 2.0 2.0 2.0 2.0 2.0;
        0.0 0.0 0.0 0.0 0.0 0.0; 0.5 0.5 0.5 0.5 0.5 0.5
    ]
    y = Recurrence([0.0]; modifiers = (m,))(; history = zeros(4, 1), add = dem)
    expected = [
        [
            3.3394431851281987, 1.0484426022889142, 2.2796868215380073e-6,
            0.799999999857938, 1.9932140502709161, 0.9997819750307493,
        ],
        [
            1.9563065905182935, 1.1401711600150635, 0.9002592100651623, 0.0,
            0.5300149762533081, 0.5999997090890467,
        ],
        [
            0.6605568148718013, 1.9515573977110858, 4.9999977203131785,
            5.200000000142062, 0.006785949729083862, 0.00021802496925071857,
        ],
        [
            0.5436934094817065, 1.3598288399849365, 1.5997407899348377, 2.5,
            1.969985023746692, 1.9000002909109535,
        ],
    ]
    for k in 1:4
        @test y[k, :] ≈ expected[k] rtol = 1.0e-10
    end
    # Was `Capacity(θ[2], Beds(θ[3]); pairs = [1 => 2])` on a renewal whose
    # admitted cases transmit less.
    g = [0.1, 0.3, 0.3, 0.2, 0.1]
    seed = [1.0 2.0 3.0 4.0 5.0; 0.0 0.0 0.0 0.0 0.0]
    R = [2.0 + 0.3 * cos(t / 6) for t in 1:40]
    function run(θ)
        G = PerStratum([(1 - θ[1]) .* g'; g'])
        r = Recurrence(G; coupling = [1.0 1.0; 0.0 0.0], modifiers = (beds(θ[2], θ[3]),))
        return r(repeat(R', 2); history = seed)
    end
    θ = [0.4, 40.0, 0.15]
    y = run(θ)
    @test y[1, 1:10] ≈ [
        4.270267923212113, 5.380388975023696, 6.001008691912503,
        6.566844938180772, 7.166818458783206, 7.770738833782063,
        8.432146585260512, 8.992016918726485, 9.52009174041529, 6.140828399229655,
    ] rtol = 1.0e-12
    @test all(==(6.0), y[1, 11:end])
    @test y[2, 10] ≈ 3.8536799762198104 rtol = 1.0e-12
    @test y[2, end] ≈ 6762.515477827001 rtol = 1.0e-12
    @test ForwardDiff.gradient(θ -> sum(run(θ)), θ) ≈
        [-618713.3057836883, -1582.4750230049747, -297304.06579611194] rtol = 1.0e-10
end

@testitem "Use case: a pool granted by flows gives the values of Capacity with Budget" tags = [:usecase] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    starts = [rem(t - 1, 7) == 0 for t in 1:14]
    grant = CR.Flow(0 => :B, TimeVarying(5.0 .* starts); form = CR.Truncate())
    reset = CR.Flow(:B => 0, TimeVarying(float.(starts)); form = CR.Share())
    budget(flows; kw...) = CR.Pool(;
        stocks = (:B,), draw = :B => CR.Truncate(), flows_first = true, flows,
        overflow = :stratum, kw...
    )
    demand = [fill(0.5, 1, 7) fill(2.0, 1, 7); zeros(1, 14)]
    run(m) = Recurrence([0.0]; modifiers = (m,))(; history = zeros(2, 1), add = demand)
    # Was `Capacity(5.0, Budget(7); pairs = [1 => 2])`.
    @test run(budget(grant)) == [
        0.5 0.5 0.5 0.5 0.5 0.5 0.5 2.0 2.0 2.0 0.5 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.5 2.0 2.0 2.0
    ]
    # Was `Capacity(5.0, Budget(7; carry_over = false); pairs = [1 => 2])`.
    @test run(budget((reset, grant))) == [
        0.5 0.5 0.5 0.5 0.5 0.5 0.5 2.0 2.0 1.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 2.0 2.0 2.0 2.0
    ]
    # Was `Capacity(5.0, Budget(Inf); pairs = [1 => 2])`.
    @test run(budget((); initial = 5.0)) == [
        0.5 0.5 0.5 0.5 0.5 0.5 0.5 1.5 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.5 2.0 2.0 2.0 2.0 2.0 2.0
    ]
    # Was `Capacity(2.0, Budget(Inf); pairs = [1], overflow = Drop())`.
    doses = CR.Pool(; stocks = (:B,), initial = 2.0, draw = :B => CR.Truncate())
    @test Recurrence([0.0]; modifiers = (doses,))(; history = [0.0], add = [1.5, 1.5]) ==
        [1.5, 0.5]
end
