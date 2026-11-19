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

# The output, the input's cotangent and the leaves of the parameter mirror
# after the rule's passes with output cotangent `Ȳ`, for `op` on arrays made
# by `A`. A convolution's gain, add input and history take cotangents too.
function _rule_passes(op0, args0, Ȳ0, A)
    op = A === identity ? op0 : adapt(A, op0)
    move(x) = x isa AbstractArray ? A(x) : x
    args = map(move, args0)
    y, cache = CR._run_forward(op, args...)
    x̄ = zero(args[1])
    rest = map(a -> op isa Convolution ? _mirror(a) : nothing, Base.tail(args))
    piece = CR._zero_mirror(op)
    grads = (; piece, y = move(Ȳ0), args = (x̄, rest...))
    CR._run_pullback!(grads, op, cache)
    return Array(y), Array(x̄), vcat(_leaves(piece), _leaves(rest))
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
    flow = CR.Flow(:S => 0, 0.1; form = CR.Share())
    pools = (
        CR.Depletion(200.0, CR.Hazard(), flow),
        CR.Depletion(PerStratum(fill(150.0, S)), CR.Floor()),
    )
    conv(k) = (Convolution(k), (x, true, nothing, nothing, 1, nothing))
    # A gain or add input per stratum and time, per time or shared.
    gain, add = 0.5 .* x, collect(range(0.1, 1.0; length = T))
    scaled(g, a) = (Convolution(pmf), (x, g, a, fill(1.0, S, 2), 1, nothing))
    rec(r) = (r, (CR._run_args(r, x, h, nothing, nothing, 1)..., nothing))
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
    stepped(m) = rec(Recurrence(pmf; modifiers = (m,)))
    cases = [
        "Convolution, vector kernel" => conv(pmf),
        "Convolution, per-stratum kernel" => conv(PerStratum(repeat(pmf', S))),
        "Convolution, time-varying kernel" => conv(TimeVarying(G)),
        "Convolution, per-stratum time-varying kernel" =>
            conv(TimeVarying(PerStratum(GS))),
        "Convolution, per-stratum time-varying kernel by output" =>
            conv(TimeVarying(PerStratum(GS), CR.Primary())),
        "Convolution, gain per stratum and time, add per time" =>
            scaled(gain, add),
        "Convolution, scalar gain, add per stratum and time" =>
            scaled(0.7, gain),
        "Recurrence, identity coupling" => rec(Recurrence(pmf)),
        "Recurrence, Diagonal coupling" =>
            rec(Recurrence(pmf; coupling = Diagonal(fill(0.8, S)))),
        "Recurrence, dense coupling" => rec(Recurrence(pmf; coupling = C)),
        "Recurrence, pools and a shift" => rec(
            Recurrence(pmf; modifiers = (pools..., CR.Transform(+, 0.5)))
        ),
        "Recurrence, time-varying kernel" => rec(Recurrence(TimeVarying(G))),
        "Recurrence, per-stratum time-varying kernel" =>
            rec(Recurrence(TimeVarying(PerStratum(GS)))),
        "Recurrence, two pools" => stepped(two_pools),
        "Recurrence, two draws on one pool" => stepped(two_draws),
        "Recurrence, a queue" => stepped(queued),
        "Recurrence, grouped totals" => stepped(totals),
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
            Ȳ = cos.((1:S) .* 0.3 .+ (1:size(x, 2))' .* 0.1)
            for (name, (op, args)) in cases
                @testset "$name, $S strata" begin
                    y0, x̄0, p̄0 = _rule_passes(op, args, Ȳ, identity)
                    y1, x̄1, p̄1 = _rule_passes(op, args, Ȳ, A)
                    @test y1 ≈ y0
                    @test x̄1 ≈ x̄0
                    @test length(p̄1) == length(p̄0)
                    @test all(map(≈, p̄1, p̄0))
                end
            end
        end
    end
end
