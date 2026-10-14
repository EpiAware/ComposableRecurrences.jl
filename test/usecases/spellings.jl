# Each stock-and-flow model in the spelling that replaced an earlier one
# gives the values the earlier spelling gave, recorded to full precision
# before the change. The models are the docstring examples, so these
# items keep their numbers whatever the doctests round to.

@testitem "Use case: hazard-rate flows give the values of the Rate kind" tags = [:usecase] begin
    using ComposableRecurrences
    CR = ComposableRecurrences
    # Was `Flows(Flow(1 => 2, 0.3), Flow(1 => 0, 0.4), Flow(2 => 0, 0.1))`,
    # each a `Rate`; a bare demand is still a hazard rate.
    flows = CR.Flows(
        CR.Flow(1 => 2, 0.3), CR.Flow(1 => 0, 0.4), CR.Flow(2 => 0, 0.1)
    )
    ward = Recurrence([1.0]; modifiers = (flows,))
    admitted = [fill(10.0, 1, 4); zeros(1, 4)]
    y, st = CR.with_state(ward; history = zeros(2, 1), add = admitted)
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
    # Was `Flow(1 => 0, Linear(TimeVarying(fill(0.1, 6))))` and
    # `Flow(2 => 0, Amount(TimeVarying(PerStratum(fill(0.5, 2, 6)))))`.
    flows = CR.Flows(
        CR.Flow(1 => 2, PerStratum([0.3, 0.2])),
        CR.Flow(1 => 0, TimeVarying(fill(0.1, 6)); form = CR.Share()),
        CR.Flow(2 => 0, 0.1),
        CR.Flow(
            2 => 0, TimeVarying(PerStratum(fill(0.5, 2, 6)));
            form = CR.Truncate()
        ),
    )
    adm = [
        10.0 8.0 6.0 4.0 2.0 1.0; 5.0 5.0 5.0 5.0 5.0 5.0;
        0.0 0.0 0.0 0.0 0.0 0.0; 1.0 0.0 0.0 0.0 0.0 0.0
    ]
    r = Recurrence([1.0]; modifiers = (flows,))
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
    function ward(θ)
        fl = CR.Flows(
            CR.Flow(1 => 2, θ[1]), CR.Flow(1 => 0, θ[2]; form = CR.Share()),
            CR.Flow(2 => 0, θ[3]), CR.Flow(2 => 0, θ[4]; form = CR.Truncate())
        )
        r = Recurrence([1.0]; modifiers = (fl,))
        return r(; history = zeros(2, 1), add = [fill(10.0, 1, 8); zeros(1, 8)])
    end
    @test ForwardDiff.gradient(θ -> sum(ward(θ)), [0.3, 0.1, 0.1, 0.5]) ≈ [
        2.8407073275040133, -568.1334926059575, -229.0565344570363,
        -29.04541828738811,
    ] rtol = 1.0e-10
    # The depletion's flows: was `Flow(1 => 0, Linear(0.002))`, and
    # `Flow(2 => 1, Linear(0.05))` with `Flow(2 => 0, Amount(1.0))`.
    d = CR.Depletion(
        1000.0; removals = 3.0,
        flows = (CR.Flow(1 => 0, 0.01), CR.Flow(1 => 0, 0.002; form = CR.Share()))
    )
    y = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 8); history = [5.0])
    @test y ≈ [
        2.9955044966270243, 6.652927267489164, 8.596099981869761, 12.120707723783651,
        16.73655431043126, 22.273150166745683, 29.044080713035257, 36.44220649764632,
    ] rtol = 1.0e-12
    d = CR.Depletion(
        1000.0, CR.Truncate(); removals = 3.0, protected = CR.Protected(0.2),
        flows = (
            CR.Flow(2 => 1, 0.05; form = CR.Share()),
            CR.Flow(2 => 0, 1.0; form = CR.Truncate()),
        )
    )
    y = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))(fill(2.0, 8); history = [5.0])
    @test y ≈ [
        3.0, 6.8, 9.08, 13.448, 19.8688, 29.00128, 42.648768, 62.5380608,
    ] rtol = 1.0e-12
end
