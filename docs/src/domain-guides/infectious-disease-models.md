# [Infectious disease models](@id infectious-disease-models)

Many infectious disease models are recurrences and convolutions.
This table maps common model parts to the code that builds them, with the tutorial that uses each.
``I_t`` is infections, ``R_t`` the reproduction number and ``w_l`` the generation interval on lag ``l``.

| Model part | Maths | Code | Tutorial |
|---|---|---|---|
| Renewal process | ``I_t = R_t \sum_{l=1}^{L} w_l I_{t-l}`` | [`Recurrence(w)`](@ref Recurrence), called as `r(R; history)` | [Renewal then delay](@ref tutorial-renewal-delay) |
| Susceptible depletion | ``I_t = S_{t-1} \big(1 - e^{-v_t / N}\big)``, ``S_t = S_{t-1} - I_t`` | [`Depletion(N)`](@ref ComposableRecurrences.Depletion), or `Depletion(N, Floor())` | [Renewal then delay](@ref tutorial-renewal-delay) |
| A stock of doses or places used up in full | ``x_t = \min(v_t, s_{t-1})``, ``s_t = s_{t-1} - x_t`` | [`Depletion(b, Truncate())`](@ref ComposableRecurrences.Truncate), or `SoftTruncate(κ)` for a smooth minimum | – |
| All-or-nothing vaccination, efficacy ``e``, doses ``d_t`` | a share ``e`` of doses leaves ``S``: ``S_t \mathrel{-}= \min(e\, d_t, S_t)`` | [`Depletion(N; removals = TimeVarying(e .* d), protected = Protected(0))`](@ref ComposableRecurrences.Protected) | [Renewal then delay](@ref tutorial-renewal-delay) |
| Leaky vaccination, efficacy ``e``, doses ``d_t`` | infections from ``S + (1 - e) V``, doses move from ``S`` to ``V`` | [`Depletion(N; removals = TimeVarying(d), protected = Protected(1 - e))`](@ref ComposableRecurrences.Protected) | [Renewal then delay](@ref tutorial-renewal-delay) |
| Births ``b_t`` into a changing population ``N_t`` | ``S_t \mathrel{+}= b_t``, the hazard divides by ``N_t`` | [`Depletion(TimeVarying(N); removals = TimeVarying(-b))`](@ref ComposableRecurrences.Depletion) | the [`Depletion`](@ref ComposableRecurrences.Depletion) example |
| Imported cases ``\iota_t`` | ``v_t = R_t \sum_l w_l I_{t-l} + \iota_t`` | `add = ι`, or [`Add(TimeVarying(ι))`](@ref ComposableRecurrences.Add) after depletion | [Renewal then delay](@ref tutorial-renewal-delay) |
| Reporting delay ``d_l`` | ``C_t = \sum_{l=0}^{L-1} d_l I_{t-l}`` | [`Convolution(d)`](@ref Convolution) | [Renewal then delay](@ref tutorial-renewal-delay) |
| Log reproduction number as a latent process | ``\log R_t = \rho \log R_{t-1} + \epsilon_t`` | `Recurrence([ρ])(; history, add = ϵ)` | [Latent processes driving R_t](@ref tutorial-latent-rt) |
| Delay that changes over time | ``C_t = \sum_l d_l(t) I_{t-l}`` or ``\sum_l d_l(t - l) I_{t-l}`` | [`Convolution(TimeVarying(D))`](@ref TimeVarying), or `TimeVarying(D, Primary())` | [Time-varying delays and kernels](@ref tutorial-time-varying-kernels) |
| Mixing between places or groups | ``I_{t,i} = R_{t,i} \sum_j M_{ij} \sum_l w_l I_{t-l,j}`` | `Recurrence(w; coupling = M)` | [Spatial and multi-type models](@ref tutorial-spatial-strata) |
| Generation interval per group or pair | ``w_{i,l}`` or ``w_{ij,l}`` | [`PerStratum(W)`](@ref PerStratum), [`Pairwise(A)`](@ref Pairwise) | [Spatial and multi-type models](@ref tutorial-spatial-strata) |
| Importation between patches | a share ``\varepsilon_j K_{ij}`` of patch ``j``'s infections occurs in patch ``i`` | [`Redistribute(K, ε)`](@ref ComposableRecurrences.Redistribute) | [Spatial and multi-type models](@ref tutorial-spatial-strata) |
| Districts sharing a patch total ``\bar I_{t,p}`` fixed elsewhere | ``I_{t,i} = \bar I_{t,p}\, u_{t,i} / \sum_{j \in p} u_{t,j}``, with ``u_{t,i}`` district ``i``'s own renewal value | [`Allocate(groups, TimeVarying(PerStratum(Ī)))`](@ref ComposableRecurrences.Allocate) | [Spatial and multi-type models](@ref tutorial-spatial-strata) |
| Isolation | ``w_l \big(1 - p\, b\, F(l)\big)`` | a thinned kernel `w .* (1 .- p * b .* F)` | [Spatial and multi-type models](@ref tutorial-spatial-strata) |
| Isolation that starts on a set day, by infection day | ``I_t = R_t \sum_l w_l(t - l) I_{t-l}``, ``w_l(c) = w_l \big(1 - p\, b\, P(D \le l,\ c + D \ge t_0)\big)`` | [`Recurrence(TimeVarying(W, Primary()))`](@ref ComposableRecurrences.Primary), seeded with `start = m + 1` | [Time-varying delays and kernels](@ref tutorial-time-varying-kernels) |
| Branching-process extinction by generation | ``q_t = G(q_{t-1})``, ``q_0 = 0``, with ``G`` the offspring probability generating function | [`Recurrence([1.0]; modifiers = (Transform(G, θ),))`](@ref ComposableRecurrences.Transform), called as `r(; history = [0.0], stop)` | [Transforms inside a recurrence](@ref tutorial-transform) |
| Behavioural response to incidence | ``I_t = v_t / (1 + v_t / \kappa)`` | [`Transform((v, κ) -> v / (1 + v / κ), κ)`](@ref ComposableRecurrences.Transform), before `Depletion` | [Transforms inside a recurrence](@ref tutorial-transform) |
| Bed occupancy | ``O_t = (1 - \delta) O_{t-1} + A_t`` | `Recurrence([1 - δ])(; history, add = A)`, or `Convolution((1 - δ) .^ (0:T-1))` | [Occupancy and capacity](@ref tutorial-occupancy) |
| Bed cap | ``O_t = \min(O_t, B)`` | [`Clamp(0, B)`](@ref ComposableRecurrences.Clamp) | [Occupancy and capacity](@ref tutorial-occupancy) |
| Isolation beds with overflow | ``x_t = \min\big(d_t, \max(C - (1 - \delta) O_{t-1}, 0)\big)`` of demand ``d_t`` admitted, ``d_t - x_t`` left in the community | [`Capacity(C, Beds(δ); pairs = [1 => 2])`](@ref ComposableRecurrences.Capacity) | [Occupancy and capacity](@ref tutorial-occupancy) |
| Ring vaccination with a weekly budget | ``x_t = \min(d_t, B_t)``, with ``B_t`` refilled by ``b`` each week | [`Capacity(b, Budget(7); pairs = [1 => 2])`](@ref ComposableRecurrences.Capacity) | [Occupancy and capacity](@ref tutorial-occupancy) |
| Forecast after a fit | continue ``I_t`` from the fitted days | [`with_state`](@ref ComposableRecurrences.with_state), then `r(R; state)` | [Renewal then delay](@ref tutorial-renewal-delay) |
| Seed days returned with the run | ``I_1, \dots, I_m`` then the renewal | [`r(R; history, prepend = true)`](@ref Recurrence) | [Renewal then delay](@ref tutorial-renewal-delay) |
| Seed on an exponential growth path | ``h_l = I_0 e^{r (l - L)}``, with ``r`` matching ``R`` | [`exponential_history(I0, r, L)`](@ref ComposableRecurrences.exponential_history) | [Renewal then delay](@ref tutorial-renewal-delay) |

Random walks, autoregressions and moving averages are listed with the [time-series processes](@ref overview-time-series) on the [API overview](@ref api-overview).
