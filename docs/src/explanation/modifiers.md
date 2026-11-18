# [Modifiers](@id explanation-modifiers)

```@example modifiers
using ComposableRecurrences
using ComposableRecurrences: Depletion, Transform
```

## [Order](@id explanation-modifier-order)

The modifiers of a [`Recurrence`](@ref) act on each step's value in tuple order, after the gain and `add`.
With modifiers ``M_1, \dots, M_m``, each with its own state ``s^{(n)}``, a step computes

```math
v^{(0)}_t = v_t, \qquad
\big(v^{(n)}_t,\ s^{(n)}_t\big) = M_n\big(v^{(n-1)}_t,\ s^{(n)}_{t-1}\big), \qquad
y_t = v^{(m)}_t,
```

where ``v_t`` is the value after the gain and `add`, ``v^{(n)}_t`` the value modifier ``n`` passes on, and ``y_t`` the output.
Each sees the value the one before it passed on, so the order belongs to the model.
A cap applied before a `Depletion` draws the capped value from its pool, the quantity it carries from step to step, while a cap applied after it only limits what is reported.
With the cap ``c(v) = \min(\max(v, 0), 8)`` and the [hazard form](@ref ComposableRecurrences.Hazard) of a pool ``S_t`` of ``N``, the two orders give

```math
\begin{aligned}
\text{cap first:} \quad & y_t = S_{t-1} \big(1 - e^{-c(v_t)/N}\big), & S_t &= S_{t-1} \, e^{-c(v_t)/N}, \\
\text{cap last:} \quad & y_t = c\big(S_{t-1} \big(1 - e^{-v_t/N}\big)\big), & S_t &= S_{t-1} \, e^{-v_t/N}.
\end{aligned}
```

```@example modifiers
k = [0.3, 0.4, 0.3]
gain = fill(2.5, 15)
seed = [1.0, 2.0, 3.0]
pool(N) = Depletion(N; pools = (S = N - sum(seed),))
cap_first = Recurrence(k; modifiers = (Transform(clamp, 0.0, 8.0), pool(100.0)))
cap_last = Recurrence(k; modifiers = (pool(100.0), Transform(clamp, 0.0, 8.0)))
round.(cap_first(gain; history = seed)[end-2:end]; digits = 2),
round.(cap_last(gain; history = seed)[end-2:end]; digits = 2)
```

Imported infections have the same choice: through `add` they are drawn from the pool, and through a [`Transform(+, b)`](@ref ComposableRecurrences.Transform) after a `Depletion` they do not deplete it.

## [State](@id explanation-modifier-state)

Each modifier keeps its own state ``s^{(n)}_t`` from step to step, such as the remaining pool of a [`Depletion`](@ref ComposableRecurrences.Depletion).
The state starts from the call's history through the modifier's `Init`, or at zero.
It is carried in the [`State`](@ref ComposableRecurrences.State) a call returns, so a [resumed call](@ref explanation-history-state) carries on with it.

```@example modifiers
r = Recurrence(k; modifiers = (pool(100.0),))
y, state = r(gain; history = seed, record = (:state,))
state.states
```

A modifier's state is one entry per stratum unless its [`blocks`](@ref ComposableRecurrences.blocks) gives another count, which [`nstate`](@ref ComposableRecurrences.nstate) reads.
A modifier that needs no state leaves it at zero.

## [Scope](@id explanation-modifier-scope)

A modifier's step reads one [stratum](@ref overview-step), one group of strata or every stratum.
The trait [`blocks`](@ref ComposableRecurrences.blocks) is `(1, 1)` for the first, the values and state entries of each group for the second, and `nothing` for the third.
A pointwise modifier reads and writes each stratum on its own.
The scope sets how much the step can do, and how well it runs under [`Threaded`](@ref ComposableRecurrences.Threaded): strata run apart only when every modifier is pointwise.

| Built-in | Step reads | State holds | Place it |
|---|---|---|---|
| [`Depletion`](@ref ComposableRecurrences.Depletion) | one stratum with its pools | each pool, then the queue with `overflow = :queue` | after anything that should draw from the pool |
| [`Redistribute`](@ref ComposableRecurrences.Redistribute) | every stratum | what each stratum received | before a `Depletion` that should deplete where values are realised |
| [`Allocate`](@ref ComposableRecurrences.Allocate) | one group of strata, or every stratum with `imports` | nothing, or the import pattern after the spilled values | after what it rescales |
| [`Transform`](@ref ComposableRecurrences.Transform) | one stratum | nothing | where the map applies |

With `overflow = :stratum` a `Depletion` also reads a second stratum.
Without a draw it reads one group of pools held in the stratum, its state holds what flowed into each pool, and it sits on a kernel of `[1.0]`, which carries the pools forward.
A `Transform(+, b)` after an `Allocate` adds to its totals, and a spill whose pattern reads the values before the `Allocate` goes in its `spill`.
A `Transform(+, b)` goes where the addition should enter, and a `Transform(clamp, lo, hi)` after what it bounds.

A modifier acts on a [`Recurrence`](@ref) only; a [`Convolution`](@ref) has none.
Its parameters take every form in [Slots](@ref explanation-slots).

## [Choosing a modifier](@id explanation-choosing-modifier)

Several needs have more than one fit.

- To bound values, `Transform(clamp, lo, hi)` cuts them and a `Depletion` filled up to a capacity routes, queues or drops what is cut, so it keeps account of the excess.
- To move values between strata after the gain, `Redistribute` moves them through a movement matrix whose columns sum to one.
- To move values between the pools of a group, use a `Depletion` without a draw.
- To mix values between strata before the gain, use a [coupling](@ref explanation-coupling).
- To map values, `Transform` takes any function, and write a [new modifier](@ref extending-pointwise) when the map keeps state or reads other strata.

A [new modifier](@ref extending) composes with the built-ins in the same tuple.
