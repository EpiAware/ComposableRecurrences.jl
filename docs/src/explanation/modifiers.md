# [Modifiers](@id explanation-modifiers)

This page explains how modifiers compose: their order, their state, and how far each one reads.
The [modifiers table](@ref overview-modifiers) lists the built-ins, and each one's docstring gives its maths.

```@example modifiers
using ComposableRecurrences
using ComposableRecurrences: Depletion, Clamp, Add, with_state
```

## [Order](@id explanation-modifier-order)

The modifiers of a [`Recurrence`](@ref) act on each step's value in tuple order, after the gain and `add`.
With modifiers ``M_1, \dots, M_R``, each with its own state ``s^{(n)}``, a step computes

```math
u^{(0)}_t = v_t, \qquad
\big(u^{(n)}_t,\ s^{(n)}_t\big) = M_n\big(u^{(n-1)}_t,\ s^{(n)}_{t-1}\big), \qquad
y_t = u^{(R)}_t,
```

where ``v_t`` is the value after the gain and `add`, ``u^{(n)}_t`` the value modifier ``n`` passes on, and ``y_t`` the output.
Each sees the value the one before it passed on, so the order is part of the model.
A cap applied before depletion draws the capped value from the pool, and a cap applied after it only limits what is reported.
With the cap ``c(v) = \min(\max(v, 0), 8)`` and the hazard form of a pool ``s_t`` of ``N``, the two orders give

```math
\begin{aligned}
\text{cap first:} \quad & y_t = s_{t-1} \big(1 - e^{-c(v_t)/N}\big), & s_t &= s_{t-1} \, e^{-c(v_t)/N}, \\
\text{cap last:} \quad & y_t = c\big(s_{t-1} \big(1 - e^{-v_t/N}\big)\big), & s_t &= s_{t-1} \, e^{-v_t/N}.
\end{aligned}
```

The [`Hazard`](@ref ComposableRecurrences.Hazard) and [`Floor`](@ref ComposableRecurrences.Floor) docstrings give the depletion forms.

```@example modifiers
k = [0.3, 0.4, 0.3]
gain = fill(2.5, 15)
seed = [1.0, 2.0, 3.0]
pool(N) = Depletion(N; pool0 = N - sum(seed))
cap_first = Recurrence(k; modifiers = (Clamp(0.0, 8.0), pool(100.0)))
cap_last = Recurrence(k; modifiers = (pool(100.0), Clamp(0.0, 8.0)))
round.(cap_first(gain; history = seed)[end-2:end]; digits = 2),
round.(cap_last(gain; history = seed)[end-2:end]; digits = 2)
```

The [Renewal then delay](@ref tutorial-renewal-delay) tutorial shows the same choice for imports, through `add` or [`Add`](@ref ComposableRecurrences.Add).

## [State](@id explanation-modifier-state)

Each modifier keeps its own state ``s^{(n)}_t`` from step to step, such as the remaining pool of a [`Depletion`](@ref ComposableRecurrences.Depletion).
The state starts from the call's history through the modifier's `Init`, or at zero.
It is carried in the [`State`](@ref ComposableRecurrences.State) a call returns, so a resumed call carries on with it, as [History and state](@ref explanation-history-state) shows.

```@example modifiers
r = Recurrence(k; modifiers = (pool(100.0),))
y, state = with_state(r, gain; history = seed)
state.states
```

A modifier's state is one entry per series unless [`nstate`](@ref ComposableRecurrences.nstate) says otherwise.
A modifier that needs no state leaves it at zero.

## [Scope](@id explanation-modifier-scope)

A modifier's step reads one series, one group of series or every series.
[`ispointwise`](@ref ComposableRecurrences.ispointwise) marks the first and [`blocks`](@ref ComposableRecurrences.blocks) the second; any other modifier reads every series.
The scope sets how much the step can do, and how well it runs under [`Threaded`](@ref ComposableRecurrences.Threaded): strata run apart only when every modifier is pointwise.

| Built-in | Step reads | State holds | Place it |
|---|---|---|---|
| [`Depletion`](@ref ComposableRecurrences.Depletion) | one series, or one series with its protected pool | the pool, then the protected pool | after anything that should draw from the pool |
| [`Redistribute`](@ref ComposableRecurrences.Redistribute) | every series | what each series received | before a `Depletion` that should deplete where values are realised |
| [`Add`](@ref ComposableRecurrences.Add) | one series | nothing | where the addition should enter |
| [`Clamp`](@ref ComposableRecurrences.Clamp) | one series | nothing | after what it bounds |
| [`Flows`](@ref ComposableRecurrences.Flows) | one group of compartments | what flowed into each compartment | on a kernel of `[1.0]`, which carries the compartments forward |
| [`Allocate`](@ref ComposableRecurrences.Allocate) | one group of series, or every series with `imports` | nothing, or the import pattern after the spilled values | after what it rescales; an `Add` after it adds to the totals; a spill whose pattern reads the values before it goes in its `spill` |
| [`Capacity`](@ref ComposableRecurrences.Capacity) | each admitted series and its overflow | the occupancy or allowance, then the queue with `Hold()` | after what makes the demand |
| [`Transform`](@ref ComposableRecurrences.Transform) | one series | nothing | where the map applies |

A modifier acts on a [`Recurrence`](@ref) only; a [`Convolution`](@ref) has none.
Its parameters take every form in [Slots](@ref explanation-slots).

## [Choosing a modifier](@id explanation-choosing-modifier)

Several needs have more than one fit.

- To bound values, `Clamp` cuts them and `Capacity` routes, queues or drops what is cut, so it keeps account of the excess.
- To move values between series, `Redistribute` moves them after the gain through a movement matrix whose columns sum to one, `Flows` moves between compartments within a group, and a [coupling](@ref explanation-coupling) mixes before the gain.
- To map values, `Transform` takes any function, and a [new modifier](@ref extending-pointwise) is worth writing when the map keeps state or reads other series.

A new modifier composes with the built-ins in the same tuple; [Writing new types](@ref extending) gives the contract.
