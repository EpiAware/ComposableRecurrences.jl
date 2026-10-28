# [Operators](@id explanation-operators)

```@example operators
using ComposableRecurrences
using ComposableRecurrences: exponential_history, Depletion
```

## [A recurrence is a convolution of its own outputs](@id explanation-lag-origin)

A recurrence reads its own past outputs, and a convolution reads an input series.
So a recurrence with kernel ``k`` is a convolution of its outputs with ``k`` shifted by one lag, times the gain ``\gamma_t``:

```math
y_t = \gamma_t \sum_{l=1}^{L} k_l \, y_{t-l} = \gamma_t \sum_{l=0}^{L} \tilde k_l \, y_{t-l},
\qquad \tilde k = (0, k_1, \dots, k_L),
```

where ``y_t`` is the output at time ``t``, ``k_l`` the kernel weight on lag ``l``, and ``\tilde k`` the convolution kernel `vcat(0, k)`.
A recurrence's value cannot depend on itself in the same step, so its first weight is on the previous value.
A convolution can weight the input at the current time, as a reporting delay of zero does.
Both are written as the quantity is usually written, so a generation interval or a delay goes in unchanged.

```@example operators
k = [0.2, 0.5, 0.3]
gain = fill(1.3, 10)
seed = [1.0, 1.0, 1.0]
y = Recurrence(k)(gain; history = seed)
p = Convolution(vcat(0, k))(y; history = seed)
y ≈ gain .* p
```

The same identity recovers any quantity inside a step from the outputs.
Operators return only their outputs, so recompute an intermediate this way rather than asking the operator for it.

## [Time base](@id explanation-time-base)

Every time-indexed input is read at absolute time ``t``, counted from 1.
This holds for `gain`, `add`, a convolution's `x` and every [`TimeVarying`](@ref) kernel, coupling or parameter.
`start` and `stop` choose which times are computed, not how the inputs are read.
So a call from `start = 4` reads `gain[4]` at its first step, and the output has `stop - start + 1` entries.
With ``h_{t}`` the history value at time ``t``, that first step is

```math
y_4 = g_4 \sum_{l=1}^{3} k_l \, h_{4-l}.
```

```@example operators
gain = collect(range(1.5, 0.8; length = 10))
r = Recurrence(k)
y_late = r(gain; history = seed, start = 4)
length(y_late), y_late[1] ≈ gain[4] * sum(k .* reverse(seed))
```

One time base means a series built in parts lines up with one built whole.
A resumed call, a later `start` and a forecast past the data all read the same column for the same time.

## [History and state](@id explanation-history-state)

The `history` holds the values before `start`, oldest first.
The recursion reads only the last ``L`` of them, and zeros stand for any that are missing.
A modifier's `Init` reads the whole history, so a modifier can set its starting state from more than ``L`` values.

A [`State`](@ref ComposableRecurrences.State) holds everything the next step reads: the last ``L`` outputs, the state of each modifier and the next time.
So a call that resumes from a `State` gives the values one call over both ranges would.
A forecast is then a second call, not a second model.

```@example operators
modifiers = (Depletion(50.0; pools = (S = 50.0 - sum(seed),)),)
r = Recurrence(k; modifiers)
whole = r(fill(1.6, 20); history = seed)
fit, state = r(fill(1.6, 20); history = seed, stop = 12, state = true)
forecast, _ = r(fill(1.6, 20); state)
whole ≈ vcat(fit, forecast)
```

The pool in the `State` carries the depletion over, so the forecast starts from the pool the fit left.
A modifier parameter read from past outputs, [`Recent`](@ref ComposableRecurrences.Recent), deepens the window past ``L``, and the `State` keeps the deeper window.

## [Seeding](@id explanation-seeding)

A recurrence needs values before its first step, in one of two places.

- Before time 1, as `history` with `start = 1`.
  The run starts at time 1, so the gain and other inputs cover the run only.
- At times 1 to ``m``, as `history` with `start = m + 1`.
  The inputs then cover the seed times too, which a [`Primary`](@ref ComposableRecurrences.Primary) kernel needs, since only times from 1 have a column.

[`exponential_history`](@ref ComposableRecurrences.exponential_history) builds a seed that grows at a fixed rate, as at the start of an epidemic.
A seed drawn from a finite pool should leave the pool smaller; the `pools` keyword of [`Depletion`](@ref ComposableRecurrences.Depletion) does this.

```@example operators
seed = exponential_history(2.0, 0.1, length(k))
gain = fill(1.2, 13)
before = Recurrence(k)(gain[4:end]; history = seed)
after = Recurrence(k)(gain; history = seed, start = 4)
before ≈ after
```

The two placements give the same run whenever the inputs over the seed times are not read.

## [What a call returns](@id explanation-returns)

A recurrence returns the run alone, from `start` to `stop`.
`vcat(seed, y)`, or `hcat(seed, y)` for strata, joins the seed in front, which is the whole series a later operator should see.
ReverseDiff needs `cat(seed, y; dims = ndims(y))`, and Enzyme needs a copied history, not a view, for `vcat`.
A convolution's `history` holds inputs before time 1, which it reads but does not return.

So a delay after a recurrence takes the seed as its own history.
Delaying the seed and run together and dropping the seed times gives the same reports.

```@example operators
delay = Convolution([0.1, 0.4, 0.3, 0.2])
infections = Recurrence(k)(gain; history = seed)
reports = delay(infections; history = seed)
joined = vcat(seed, infections)
reports ≈ delay(joined)[(length(seed) + 1):end]
```

Pass the seed as history when the reports should cover the run only, and join it in front when they should cover the seed times too.
