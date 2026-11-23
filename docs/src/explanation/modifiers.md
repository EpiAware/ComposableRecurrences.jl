# [Modifiers](@id explanation-modifiers)

Modifiers change each step's value of a recurrence, in order, each with its own state; the [API overview](@ref api-overview) shows where they fit.

```@example modifiers
using ComposableRecurrences
using ComposableRecurrences: Depletion, Floor, Transform
```

## [Built-in modifiers](@id explanation-builtin-modifiers)

A [`Depletion`](@ref ComposableRecurrences.Depletion) of a population draws each step's value from the people left to infect.
Over 40 steps with a gain of 2, a population of 1000 holds the total infections below 1000:

```@example modifiers
N, gain, seed = 1000.0, fill(2.0, 40), [1.0, 2.0, 3.0]
depleted = Recurrence([0.3, 0.4, 0.3]; modifiers = (Depletion(N),))
total(r) = round(sum(r(gain; history = seed)))
total(depleted)
```

- `Depletion(N, parts...; pools)` draws each step's value from named pools, such as `(S = N, V = 0.0)`, through its parts: draws and [`Flow`](@ref ComposableRecurrences.Flow)s, in the order given.
  A draw is a [depletion form](@ref explanation-depletion-forms), [`Hazard()`](@ref ComposableRecurrences.Hazard) by default, and its `overflow` keyword sends what a small pool cannot give to a second stratum, a queue or nowhere.
  A `Flow(from => to, rate)` moves values between pools, with `0` for outside the model; with flows and no draw a `Depletion` only moves values.
- [`Redistribute(M; leak)`](@ref ComposableRecurrences.Redistribute) moves a share of each stratum's value to others through a matrix whose columns sum to one, or less with `leak = true`; `Redistribute(K, ε)` moves `ε[q] * K[p, q]` of stratum `q` to `p`.
- [`Allocate(groups, total)`](@ref ComposableRecurrences.Allocate) rescales each group of strata to a known total, keeping each stratum's share.
- [`Transform(f, θ)`](@ref ComposableRecurrences.Transform) maps each value through ``f(v, \theta)``, such as `Transform(+, b)` or `Transform(clamp, lo, hi)`.

Each modifier here has its own [hand-written gradient](@ref adjoint-routing).
A `Transform` has one when it is given a `derivative`, or when `f` holds no numbers of its own.

## [Depletion forms](@id explanation-depletion-forms)

A depletion form sets how a pool gives up what a step asks for.
Each form is a type, passed as an instance.
The same run with [`Floor`](@ref ComposableRecurrences.Floor) in place of the default hazard form gives a different total:

```@example modifiers
floored = Recurrence([0.3, 0.4, 0.3]; modifiers = (Depletion(N, Floor()),))
total(floored)
```

| Name | What it does |
|:--|:--|
| [`Hazard(α)`](@ref ComposableRecurrences.Hazard) | draws the value as a hazard, so the pool never goes negative; the default |
| [`Floor(α)`](@ref ComposableRecurrences.Floor) | scales the value by the share of the pool left, with a floor |
| [`Truncate(κ)`](@ref ComposableRecurrences.Truncate) | draws what is asked for, up to what is left; `κ` in [0, 1) smooths the cap |
| [`Share()`](@ref ComposableRecurrences.Share) | a flow that moves a share of its pool at each step |

- `α` in `Hazard(α)` and `Floor(α)` is the heterogeneity exponent, one by default.
  Above one, infections slow sooner as the pool shrinks, as when the most susceptible are infected first.
- A flow's form is `Hazard()` by default, a rate that competes with the pool's other flows.
  With `Truncate()` or `Truncate(κ)` a flow is a count, capped by what remains.
- The docstring of each form gives its formula, and [A depletion form](@ref extending-form) shows how to write a new one.

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

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
# Imports added after the depletion, so not drawn from the pool.
imports = CR.Transform(+, TimeVarying([1.0, 0.0, 2.0]))
mods = (CR.Depletion(50.0, CR.Floor()), imports)
Recurrence([1.0]; modifiers = mods)(1.0; history = [2.0], stop = 3)

# output

3-element Vector{Float64}:
 3.0
 2.88
 4.598912
```

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

A modifier's step reads one [stratum](@ref explanation-step), one group of strata or every stratum.
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

A modifier's parameters take every form in [Slots](@ref explanation-slots).

## [Allocate with imports](@id explanation-allocate-imports)

[`Allocate`](@ref ComposableRecurrences.Allocate) with `imports` places a share of each group's total by an import pattern, read before an optional `spill`.
A fifth of the first group's total lands where the third stratum sends, read before the first two strata spill a tenth of their values to each other; the second group imports nothing:

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
P = [0.0 0.0 0.2; 0.0 0.0 0.8; 0.0 0.0 0.0]
within = CR.Redistribute([0.9 0.1 0.0; 0.1 0.9 0.0; 0.0 0.0 1.0])
split = CR.Allocate(
    [1:2, 3:3], PerStratum([10.0, 2.0]);
    imports = (PerStratum([0.2, 0.0]), P), spill = within
)
r = Recurrence([1.0]; modifiers = (split,))
y = r(ones(3, 1); history = [3.0; 1.0; 1.0;;])
round.(y; digits = 3)

# output

3×1 Matrix{Float64}:
 6.0
 4.0
 2.0
```

## [Choosing a modifier](@id explanation-choosing-modifier)

- To bound values, `Transform(clamp, lo, hi)` cuts them, and a `Depletion` filled up to a capacity keeps account of what is cut.
- To mix strata before the gain use a [coupling](@ref explanation-coupling), and after it a `Redistribute`.
- To map values, `Transform` takes any function; a [new modifier](@ref extending-pointwise) suits a map that keeps state or reads other strata, and composes with the built-ins in the same tuple.

## [Depletion in practice](@id explanation-depletion-examples)

A [`Depletion`](@ref ComposableRecurrences.Depletion) builds each model below from a draw and flows, in the order given.

| model | parts |
|:----- |:------ |
| a population with births and deaths | a `TimeVarying` `N`, `Hazard()`, then the births as a count `Flow(0 => :S, b; form = Truncate())` and the deaths as one out of `:S` |
| leaky protection at relative susceptibility ``\sigma`` | `Hazard(; weights = (S = 1, V = σ))`, then the doses as `Flow(:S => :V, d; form = Truncate())` |
| beds that a share ``\delta`` leaves each step | `Flow(:O => 0, δ; form = Share())`, then `Truncate(; into = :O)`, with `N` the beds |
| an allowance granted ``b_t`` at each period start | `Flow(0 => :B, TimeVarying(b); form = Truncate())`, then `Truncate()` |
| the same without carry over | as above, with `Flow(:B => 0, starts; form = Share())` before the grant |

The step reads `N` at its own time, and a pool is not rescaled when `N` changes: arrivals enter it only through the flows.
Here `starts` is a `TimeVarying` share of one at each period start and zero otherwise, and a lifetime allowance is a starting pool alone.
A second pool gives [leaky, all-or-nothing and waning protection](@ref tutorial-vaccination); a delay from dose to protection is a [`Convolution`](@ref) of the doses before the call.
A share ``\delta`` leaving the beds is a geometric length of stay, with survival ``(1 - \delta)^k`` after ``k`` steps.
For another stay, convolve the admissions with its survival, as a [`ComposableRecurrences.Primary`](@ref) indexed [`TimeVarying`](@ref) kernel for cohorts, and bound the sum with `Transform(clamp, lo, hi)` or a `Depletion` that fills a pool.

A herd of 100 with 3 births a step: `N` grows by the births, and the births enter the pool as a count from outside after the draw.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
births = fill(3.0, 8)
N = TimeVarying(100.0 .+ cumsum(births))
herd = CR.Depletion(
    N, CR.Hazard(), CR.Flow(0 => :S, TimeVarying(births); form = CR.Truncate());
    pools = (S = 90.0,)
)
r = Recurrence([0.5, 0.5]; modifiers = (herd,))
y = r(fill(1.5, 8); history = [5.0, 5.0])
round.(y; digits = 3)

# output

8-element Vector{Float64}:
 6.32
 6.672
 7.099
 6.951
 6.563
 5.876
 5.085
 4.261
```

Leaky vaccination: 5 doses a step move susceptibles into a pool drawn at a third of the rate, and the protection wanes back at rate 0.1.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
leaky = CR.Depletion(
    1000.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
    CR.Flow(:S => :V, 5.0; form = CR.Truncate()), CR.Flow(:V => :S, 0.1);
    pools = (:S, :V)
)
r = Recurrence([0.3, 0.5, 0.2]; modifiers = (leaky,))
y = r(fill(2.0, 6); history = [5.0])
round.(y; digits = 3)

# output

6-element Vector{Float64}:
  2.996
  6.73
  8.846
 12.779
 18.196
 25.151
```

Ten beds, a tenth of patients leaving each step before the admissions: demand above the free beds goes to the community stratum.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
beds = CR.Depletion(
    10.0, CR.Flow(:O => 0, 0.1; form = CR.Share()),
    CR.Truncate(; into = :O, overflow = :stratum); pools = (O = 0.0,)
)
demand = [4.0 3.0 5.0 6.0 2.0; 0.0 0.0 0.0 0.0 0.0]
r = Recurrence([0.0]; modifiers = (beds,))
y = r(; history = zeros(2, 1), add = demand)
round.(y; digits = 3)

# output

2×5 Matrix{Float64}:
 4.0  3.0  4.06  1.0  1.0
 0.0  0.0  0.94  5.0  1.0
```

A budget of 5 doses a week: the 1.5 doses left in the first week carry over to the second.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
grants = TimeVarying([rem(t - 1, 7) == 0 ? 5.0 : 0.0 for t in 1:14])
doses = CR.Depletion(
    CR.Flow(0 => :B, grants; form = CR.Truncate()),
    CR.Truncate(; overflow = :stratum); pools = (:B,)
)
demand = [fill(0.5, 1, 7) fill(2.0, 1, 7); zeros(1, 14)]
r = Recurrence([0.0]; modifiers = (doses,))
y = r(; history = zeros(2, 1), add = demand)
y[1, :]'

# output

1×14 adjoint(::Vector{Float64}) with eltype Float64:
 0.5  0.5  0.5  0.5  0.5  0.5  0.5  2.0  2.0  2.0  0.5  0.0  0.0  0.0
```

A ward without a draw: suspected patients are confirmed or ruled out, and confirmed patients are discharged, each at a hazard rate.

```jldoctest
using ComposableRecurrences
CR = ComposableRecurrences
ward = CR.Depletion(
    CR.Flow(:suspected => :confirmed, 0.3), CR.Flow(:suspected => 0, 0.4),
    CR.Flow(:confirmed => 0, 0.1); pools = (:suspected, :confirmed)
)
admitted = [fill(10.0, 1, 4); zeros(1, 4)]
r = Recurrence([1.0]; modifiers = (ward,))
y = r(; history = zeros(2, 1), add = admitted)
round.(y; digits = 3)

# output

2×4 Matrix{Float64}:
 4.966  7.432  8.656   9.264
 2.157  5.181  8.449  11.67
```
