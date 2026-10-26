# [Time units](@id time-units)

A model has one time unit, its step.
This page says what is read at that step, and what to do when parameters, data or delays come at another cadence.
Each section gives the maths, then the line of code.

```@example time-units
using ComposableRecurrences, Distributions, CensoredDistributions
using ComposableRecurrences: Add
gi = Gamma(2.0, 2.5)   # a generation interval in days, mean 5 days
nothing # hide
```

## [The step is the unit](@id time-units-step)

A [`Recurrence`](@ref) steps once per index:

```math
y_t = R_t \sum_{l=1}^{L} g_l \, y_{t-l},
```

where ``t`` counts steps and ``g_l`` weights the value ``l`` steps back.
The kernel, the history, `gain` and `add` all have one value per step.
A daily model reads each of them by day.

A delay gives its masses on whole steps of its own unit:

```math
p_l = P\big(l \Delta \le D < (l + 1) \Delta\big), \qquad l = 0, \dots, L - 1,
```

where ``D`` is the delay in its own unit and ``\Delta`` is the step in that unit.
``\Delta`` is the `step` keyword of [`delay_masses`](@ref ComposableRecurrences.delay_masses), and `Recurrence` and [`Convolution`](@ref) pass it on.
It is 1 by default, so a delay in days gives masses on days.

```@example time-units
Recurrence(gi; lags = 15).kernel ≈ ComposableRecurrences.delay_masses(gi, 15)[2:end]
```

The [Distributions](@ref extension-distributions) and [CensoredDistributions](@ref extension-censored-distributions) extension pages say how a distribution gives its masses on a step.

## [Delays in sequence](@id time-units-chained)

A delay made of two delays in sequence, such as incubation then onset to report, has two forms.
Each is a different model.

When each delay rounds to whole steps before the next one starts, the chain's masses are the full linear convolution of the two delays' masses ``a_l`` and ``b_l``:

```math
(a \circledast b)_l = \sum_{j=0}^{l} a_j\, b_{l-j}, \qquad l = 0, \dots, L - 1.
```

A tuple of delays gives this, through the [`delay_masses`](@ref ComposableRecurrences.delay_masses) method for a tuple.
It also composes delays that are already masses, such as fitted PMFs.

When the delays add in continuous time, the sum ``D = D_1 + D_2`` is one continuous delay, censored once.
Compose the distributions as distributions, for example with ConvolvedDistributions, and pass the sum as one delay.
The [CensoredDistributions](@ref extension-censored-distributions) extension gives its masses.

A tuple of two continuous delays is the first form: each delay is censored on its own, then the masses are convolved.
The two forms give different masses, since each censored delay carries its own rounding.

```@example time-units
incubation, report = Gamma(5.0, 1.0), Gamma(2.0, 1.5)
chained = Convolution((incubation, report); lags = 20)
round(sum(chained.kernel); digits = 2)
```

## [Parameters coarser than the step](@id time-units-parameters)

A weekly reproduction number in a daily model holds each week's value over the days of that week:

```math
R_t = R^{\text{week}}_j, \qquad 7 (j - 1) < t \le 7 j.
```

The gain is data, one value per step, so it is the weekly values repeated:

```@example time-units
Rw = [1.4, 1.1, 0.8]
R = repeat(Rw; inner = 7)
nothing # hide
```

A kernel, coupling or modifier parameter that changes at a few times is given by its change points, `[t => value]` in [`TimeVarying`](@ref).
Each value holds from its start until the next.
Here imports fall each week:

```@example time-units
imports = Add(TimeVarying([1 => 2.0, 8 => 0.5, 15 => 0.0]))
renewal = Recurrence(gi; lags = 15, modifiers = (imports,))
y = renewal(R; history = ones(14))
nothing # hide
```

## [Data coarser than the step, observed](@id time-units-observed)

Weekly counts of a daily model are the sums of its days:

```math
C^{\text{week}}_j = \sum_{t = 7 (j - 1) + 1}^{7 j} C_t.
```

Keep the model daily and sum its outputs in the likelihood:

```@example time-units
weekly = vec(sum(reshape(y, 7, :); dims = 1))
```

This is the usual case.
Nothing is disaggregated: the weekly data constrain the daily series through its sums.

## [Data coarser than the step, driving](@id time-units-driving)

A weekly series that drives a daily model, such as a seed or an input ``w_j``, needs daily values ``x_t`` with

```math
\sum_{t = 7 (j - 1) + 1}^{7 j} x_t = w_j.
```

There are three choices.

1. Spread it uniformly, ``x_t = w_j / 7``.
   This costs nothing, but puts jumps at the week boundaries that the data do not show.
2. Infer the daily series as a latent process, with the weekly sums as its likelihood.
   This is the most faithful choice, and costs a latent series to fit.
3. Step at the data's cadence, with the delays censored on weeks through `step`.
   This needs no daily series, but loses the timing within a week.

The first is one line:

```@example time-units
w = [70.0, 140.0, 210.0]
x = repeat(w ./ 7; inner = 7)
nothing # hide
```

The third steps by week, with the delays censored on weeks:

```@example time-units
weekly_renewal = Recurrence(gi; lags = 4, step = 7)
k = weekly_renewal.kernel
round.(k; digits = 3), round(sum(k); digits = 2)
```

A `Recurrence` kernel starts at lag 1, so the mass within one step, ``p_0``, is left out.
With a generation interval shorter than the step much of the mass lies there.
Here the kernel sums to about 0.6, so the weekly model drops the 40% of transmission that happens within the week of infection.

## [Steps finer than the data's unit](@id time-units-finer)

A model on quarter days with delays in days has ``\Delta = 0.25``.
The kernel's `lags` count steps, not days, so 10 days of a delay are 40 lags:

```@example time-units
delay = Convolution(LogNormal(1.5, 0.75); lags = 40, step = 0.25)
length(delay.kernel), round(sum(delay.kernel); digits = 2)
```

The history, `gain` and `add` are then given per quarter day too.
