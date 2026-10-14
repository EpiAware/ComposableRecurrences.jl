# [Operators](@id explanation-operators)

This page explains how the two operators handle time.
It covers the lag origin, the time base, history and state, seeding, and what a call returns.
The [API overview](@ref api-overview) gives the full step and the calls, and [`Recurrence`](@ref) and [`Convolution`](@ref) give every argument.

```@example operators
using ComposableRecurrences
using ComposableRecurrences: with_state, exponential_history, Depletion
```

## [A recurrence is a convolution of its own outputs](@id explanation-lag-origin)

A recurrence reads its own past outputs, and a convolution reads an input series.
So a recurrence with kernel ``g`` is a convolution of its outputs with ``g`` shifted by one lag, times the gain ``R_t``:

```math
y_t = R_t \sum_{l=1}^{L} g_l \, y_{t-l} = R_t \sum_{l=0}^{L} \tilde g_l \, y_{t-l},
\qquad \tilde g = (0, g_1, \dots, g_L),
```

where ``y_t`` is the output on day ``t`` and ``\tilde g`` is the convolution kernel `vcat(0, g)`.
The [FAQ](@ref faq-lag-origin) says why the two kernels start at different lags.

```@example operators
g = [0.2, 0.5, 0.3]
R = fill(1.3, 10)
seed = [1.0, 1.0, 1.0]
y = Recurrence(g)(R; history = seed)
p = Convolution(vcat(0, g))(y; history = seed)
y ≈ R .* p
```

The same identity recovers any quantity inside a step from the outputs.
Operators return only their outputs, so recompute an intermediate this way rather than asking the operator for it.

## [Time base](@id explanation-time-base)

Every time-indexed input is read at absolute time ``t``, counted from 1.
This holds for `gain`, `add`, a convolution's `x` and every [`TimeVarying`](@ref) kernel, coupling or parameter.
`start` and `stop` choose which times are computed, not how the inputs are read.
So a call from `start = 4` reads `R[4]` at its first step, and the output has `stop - start + 1` entries.
With ``h_{t}`` the history value at time ``t``, that first step is

```math
y_4 = R_4 \sum_{l=1}^{3} g_l \, h_{4-l}.
```

```@example operators
R = collect(range(1.5, 0.8; length = 10))
r = Recurrence(g)
y_late = r(R; history = seed, start = 4)
length(y_late), y_late[1] ≈ R[4] * sum(g .* reverse(seed))
```

One time base means a series built in parts lines up with one built whole.
A resumed call, a later `start` and a forecast past the data all read the same column for the same day.

## [History and state](@id explanation-history-state)

The `history` holds the values before `start`, oldest first.
The recursion reads only the last ``L`` of them, and zeros stand for any that are missing.
A modifier's `Init` reads the whole history, so a modifier can set its starting state from more than ``L`` values.

A [`State`](@ref ComposableRecurrences.State) holds everything the next step reads: the last ``L`` outputs, the state of each modifier and the next time.
So a call that resumes from a `State` gives the values one call over both ranges would.
This is what makes a forecast a second call rather than a second model.

```@example operators
modifiers = (Depletion(50.0; pool0 = 50.0 - sum(seed)),)
r = Recurrence(g; modifiers)
whole = r(fill(1.6, 20); history = seed)
fit, state = with_state(r, fill(1.6, 20); history = seed, stop = 12)
forecast = r(fill(1.6, 20); state)
whole ≈ vcat(fit, forecast)
```

The pool in the `State` carries the depletion over, so the forecast starts from the pool the fit left.
A modifier parameter read from past outputs, [`Recent`](@ref), deepens the window past ``L``, and the `State` keeps the deeper window.

## [Seeding](@id explanation-seeding)

A recurrence needs values before its first step.
There are two places to put them.

- Before time 1, as `history` with `start = 1`.
  The run starts at time 1, so the gain and other inputs cover the run only.
- At times 1 to ``m``, as `history` with `start = m + 1`.
  The inputs then cover the seed days too, which a [`Primary`](@ref ComposableRecurrences.Primary) kernel needs, since only times from 1 have a column.

[`exponential_history`](@ref ComposableRecurrences.exponential_history) builds a seed that grows at a fixed rate, as at the start of an epidemic.
A seed drawn from a finite pool should leave the pool smaller; the `pool0` keyword of [`Depletion`](@ref ComposableRecurrences.Depletion) does this.

```@example operators
seed = exponential_history(2.0, 0.1, length(g))
R = fill(1.2, 13)
before = Recurrence(g)(R[4:end]; history = seed)
after = Recurrence(g)(R; history = seed, start = 4)
before ≈ after
```

The two placements give the same run whenever the inputs over the seed days are not read.

## [What a call returns](@id explanation-returns)

A recurrence returns the run alone by default, from `start` to `stop`.
With `prepend = true` it returns the seed followed by the run, which is the whole series a later operator should see.
A convolution never prepends: its `history` holds inputs before time 1, which it reads but does not return.

So a delay after a recurrence takes the seed as its own history.
Delaying the seed and run together and dropping the seed days gives the same reports.

```@example operators
delay = Convolution([0.1, 0.4, 0.3, 0.2])
infections = Recurrence(g)(R; history = seed)
reports = delay(infections; history = seed)
joined = Recurrence(g)(R; history = seed, prepend = true)
reports ≈ delay(joined)[(length(seed) + 1):end]
```

Pass the seed as history when the reports should cover the run only, and prepend it when they should cover the seed days too.
The [Renewal then delay](@ref tutorial-renewal-delay) tutorial builds a full model this way.
