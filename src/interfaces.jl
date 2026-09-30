# Interfaces.jl declarations. Test objects are `Arguments` bundles holding
# the object under test and the inputs its components call it with.

@interface OperatorInterface Any (
    mandatory = (
        shape = "the output has the shape of the input" =>
            a -> size(a.op(a.input; a.kwargs...)) == size(a.input),
        pure = "the call leaves its input unchanged" => function (a)
            x = copy(a.input)
            a.op(a.input; a.kwargs...)
            return a.input == x
        end,
    ),
    optional = (
        resume = "resuming from the returned state continues the run" =>
            function (a)
            n = size(a.input, ndims(a.input)) ÷ 2
            y1, state = a.op(a.input; a.kwargs..., stop = n, return_state = true)
            rest = Base.structdiff(a.kwargs, NamedTuple{(:history,)})
            y2 = a.op(a.input; rest..., state)
            return cat(y1, y2; dims = ndims(a.input)) ≈
                a.op(a.input; a.kwargs...)
        end,
    ),
) "An operator called on a strata × time input, returning the same shape.

Test objects are `Arguments(; op, input, kwargs)`."

@interface CouplingInterface Any (
    mandatory = (
        pressure = "pressure! fills and returns q, one entry per stratum" =>
            function (a)
            q = zeros(length(a.p))
            out = pressure!(q, a.coupling, a.p, a.window, a.t)
            return out === q && all(isfinite, q)
        end,
        pure = "pressure! leaves p and the window unchanged" => function (a)
            p, w = copy(a.p), copy(a.window)
            pressure!(zeros(length(p)), a.coupling, a.p, a.window, a.t)
            return a.p == p && a.window == w
        end,
    ),
    optional = (
        linear = "the pressure is linear in p and the window jointly" =>
            function (a)
            q1 = pressure!(zeros(length(a.p)), a.coupling, a.p, a.window, a.t)
            q2 = pressure!(
                zeros(length(a.p)), a.coupling, 2 .* a.p, 2 .* a.window, a.t
            )
            return q2 ≈ 2 .* q1
        end,
    ),
) "A coupling of a `Recurrence`, applied by `pressure!`.

Test objects are `Arguments(; coupling, p, window, t)`."

@interface ModifierInterface Any (
    mandatory = (
        init_state = "init_state gives one entry per stratum" =>
            a -> length(init_state(a.modifier, a.history)) == length(a.v),
        apply! = "apply! keeps one value and one state per stratum" =>
            function (a)
            v = float(copy(a.v))
            s = float(collect(init_state(a.modifier, a.history)))
            apply!(a.modifier, v, s, a.t)
            return length(v) == length(a.v) && length(s) == length(a.v)
        end,
    ),
    optional = (
        pointwise = "apply! matches the scalar apply on each stratum" =>
            function (a)
            m = a.modifier
            v = float(copy(a.v))
            s = float(collect(init_state(m, a.history)))
            pairs = [apply(m, v[k], s[k], a.t, k) for k in eachindex(v)]
            apply!(m, v, s, a.t)
            return ispointwise(m) && v ≈ first.(pairs) && s ≈ last.(pairs)
        end,
    ),
) "A modifier of a `Recurrence` step, applied by `apply!` in tuple order.

Test objects are `Arguments(; modifier, history, v, t)`."

@implements OperatorInterface{(:resume,)} Recurrence [
    Arguments(;
        op = Recurrence([0.2, 0.3, 0.5]), input = [1.1, 0.9, 1.2, 1.0],
        kwargs = (; history = [1.0, 2.0, 3.0])
    ),
    Arguments(;
        op = Recurrence([0.4, 0.6]; coupling = [0.9 0.1; 0.2 0.8]),
        input = [1.1 0.9 1.2 1.0; 0.8 1.3 1.1 0.9],
        kwargs = (; history = [1.0 2.0; 3.0 1.0])
    ),
]

@implements OperatorInterface Convolution [
    Arguments(;
        op = Convolution([0.1, 0.6, 0.3]), input = [1.0, 2.0, 3.0, 4.0],
        kwargs = (;)
    ),
    Arguments(;
        op = Convolution([0.1, 0.6, 0.3]), input = [1.0 2.0 3.0; 4.0 5.0 6.0],
        kwargs = (; history = [1.0 1.0; 2.0 2.0])
    ),
]

@implements CouplingInterface{(:linear,)} UniformScaling [
    Arguments(; coupling = I, p = [1.0, 2.0], window = ones(3, 2), t = 1),
    Arguments(; coupling = 0.5I, p = [1.0, 2.0], window = ones(3, 2), t = 1),
]

@implements CouplingInterface{(:linear,)} AbstractMatrix [
    Arguments(;
        coupling = [0.9 0.1; 0.2 0.8], p = [1.0, 2.0], window = ones(3, 2),
        t = 1
    ),
    Arguments(;
        coupling = Diagonal([0.5, 2.0]), p = [1.0, 2.0], window = ones(3, 2),
        t = 1
    ),
]

@implements CouplingInterface{(:linear,)} TimeVarying [
    Arguments(;
        coupling = TimeVarying(reshape(collect(1.0:8.0), 2, 2, 2)),
        p = [1.0, 2.0], window = ones(3, 2), t = 2
    ),
]

@implements CouplingInterface{(:linear,)} Pairwise [
    Arguments(;
        coupling = Pairwise(reshape(collect(1.0:12.0), 2, 2, 3)),
        p = [1.0, 2.0], window = [1.0 2.0; 3.0 4.0; 5.0 6.0], t = 1
    ),
]

@implements ModifierInterface{(:pointwise,)} Depletion [
    Arguments(;
        modifier = Depletion([100.0, 50.0]; seeded = true),
        history = [1.0 2.0; 3.0 1.0], v = [2.0, 3.0], t = 1
    ),
    Arguments(;
        modifier = Depletion(80.0; form = :floor, heterogeneity = 1.5),
        history = ones(2, 3), v = [2.0, 3.0], t = 1
    ),
]

@implements ModifierInterface{(:pointwise,)} Imports [
    Arguments(;
        modifier = Imports([0.5 1.0; 0.2 0.1]), history = ones(2, 3),
        v = [2.0, 3.0], t = 2
    ),
]

@implements ModifierInterface Redistribute [
    Arguments(;
        modifier = Redistribute([0.0 0.3; 0.2 0.0], [0.1, 0.2]),
        history = ones(2, 3), v = [2.0, 3.0], t = 1
    ),
]

@implements ModifierInterface{(:pointwise,)} Clamp [
    Arguments(;
        modifier = Clamp(0.0, 2.5), history = ones(2, 3), v = [2.0, 3.0],
        t = 1
    ),
]
