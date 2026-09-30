# Enzyme with static activity: a constant series or history and an active
# kernel, the usual observation-layer call.

@testitem "Enzyme reverse with a constant input and an active kernel" tags = [:ad, :enzyme, :enzyme_reverse] begin
    using ComposableRecurrences
    using Enzyme: Enzyme, Const
    using ForwardDiff: ForwardDiff
    import ComposableRecurrences as CR

    # Locals, so each closure captures concrete types.
    cases = let s = collect(range(1.0, 3.0; length = 12)),
            S = collect(reshape(range(0.5, 2.0; length = 24), 2, 12)),
            h = [0.5, 1.5], L = 3,
            P = collect(reshape(range(0.1, 0.5; length = L * 12), L, 12))
        [
            ("fixed", θ -> sum(Convolution(θ)(s)), [0.2, 0.5, 0.3]),
            (
                "fixed, history", θ -> sum(Convolution(θ)(s; history = h)),
                [0.2, 0.5, 0.3],
            ),
            (
                "fixed, strata", θ -> sum(Convolution(θ)(S; history = [h h]')),
                [0.2, 0.5, 0.3],
            ),
            (
                "Secondary",
                θ -> sum(Convolution(TimeVarying(reshape(θ, L, 12)))(s)),
                vec(P),
            ),
            (
                "Primary",
                θ -> sum(
                    Convolution(TimeVarying(reshape(θ, L, 12), CR.Primary()))(s)
                ),
                vec(P),
            ),
            (
                "Recurrence, constant history",
                θ -> sum(Recurrence(θ)(fill(1.1, 8); history = [1.0, 2.0])),
                [0.3, 0.4],
            ),
            (
                "Recurrence, strata",
                θ -> sum(
                    Recurrence(θ)(fill(1.1, 2, 8); history = [1.0 2.0; 0.5 1.0])
                ),
                [0.3, 0.4],
            ),
        ]
    end
    @testset "$name" for (name, f, θ) in cases
        g = only(Enzyme.gradient(Enzyme.Reverse, Const(f), θ))
        @test g ≈ ForwardDiff.gradient(f, θ)
    end
end
