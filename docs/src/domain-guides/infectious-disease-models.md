# [Infectious disease models](@id infectious-disease-models)

Many infectious disease models are recurrences and convolutions.
Each table maps model features to the code that builds them, with the tutorial that uses each.
[Three towns, step by step](@ref tutorial-three-towns) builds a renewal process, a reporting delay, a coupling and depletion into one model.
``I_t`` is infections, ``R_t`` the reproduction number and ``g_l`` the generation interval on lag ``l``.

## [Transmission](@id domain-transmission)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Renewal process | ``I_t = R_t \sum_{l=1}^{L} g_l I_{t-l}`` | [`Recurrence(g)`](@ref Recurrence), called as `r(R; history)` | [Three towns](@ref overview-build) |
| Control measure from ``t_0`` to ``t_1`` cutting transmission by ``c`` | ``R_t \big(1 - c\, \mathbb{1}[t_0 \le t \le t_1]\big)``, or any multiplier ``m_t`` as ``R_t m_t`` | the gain `R .* measure` | [Three towns](@ref overview-build) ramps the reduction in over six days |
| Imported cases ``\iota_t`` | ``v_t = R_t \sum_l g_l I_{t-l} + \iota_t`` | `add = ι`, or [`Transform(+, TimeVarying(ι))`](@ref ComposableRecurrences.Transform) after depletion | [Imported cases](@ref tutorial-imports) |
| Instantaneous or effective reproduction number from a run | the infections over the pressure, as the [call table](@ref explanation-calls) gives | `y ./ pressure(r, y; history)`, with [`pressure`](@ref ComposableRecurrences.pressure) | [The reproduction number from a run](@ref tutorial-reproduction-number) |
| Log reproduction number as a latent process | ``\log R_t = \phi \log R_{t-1} + \epsilon_t`` | `Recurrence([φ])(; history, add = ϵ)` | [Latent processes driving R_t](@ref tutorial-latent-rt) |
| Behavioural response to incidence | – | [`Transform`](@ref ComposableRecurrences.Transform), before `Depletion` | [Latent processes driving R_t](@ref tutorial-latent-rt) |

Random walks and autoregressions are [recurrences](@ref explanation-time-series), and moving averages are convolutions.

## [Susceptible depletion and vaccination](@id domain-depletion)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Susceptible depletion | the [depletion forms](@ref explanation-depletion-forms) | [`Depletion(N)`](@ref ComposableRecurrences.Depletion), or `Depletion(N, Floor())` | [Renewal then delay](@ref tutorial-renewal-delay) |
| Doses or places used up in full | ``x_t = \min(v_t, S_{t-1})``, ``S_t = S_{t-1} - x_t`` | [`Depletion(Truncate(); pools = (S = b,))`](@ref ComposableRecurrences.Truncate), or `Truncate(κ)` for a smooth minimum | [`Truncate`](@ref ComposableRecurrences.Truncate) docstring |
| All-or-nothing vaccination, efficacy ``\eta``, doses ``d_t`` | a share ``\eta`` of doses leaves ``S``: ``S_t \mathrel{-}= \min(\eta\, d_t, S_t)`` | [`Depletion(N, Hazard(; weights = (S = 1, V = 0)), Flow(:S => :V, TimeVarying(η .* d); form = Truncate()); pools = (:S, :V))`](@ref ComposableRecurrences.Depletion) | [Vaccination](@ref tutorial-vaccination) |
| Leaky vaccination, efficacy ``\eta``, doses ``d_t`` | infections from ``S + (1 - \eta) V``, doses move from ``S`` to ``V`` | [`Depletion(N, Hazard(; weights = (S = 1, V = 1 - η)), Flow(:S => :V, TimeVarying(d); form = Truncate()); pools = (:S, :V))`](@ref ComposableRecurrences.Depletion) | [Vaccination](@ref tutorial-vaccination) |
| Waning protection at rate ``\omega`` | ``V_t \mapsto e^{-\omega} V_t``, ``S_t \mapsto S_t + (1 - e^{-\omega}) V_t`` after each day's infections, before the day's doses | the leaky `Depletion` with [`Flow(:V => :S, ω)`](@ref ComposableRecurrences.Flow) beside the doses' flow | [Vaccination](@ref tutorial-vaccination) |
| Births ``b_t`` into a changing population ``N_t`` | ``S_t \mathrel{+}= b_t``, the hazard divides by ``N_t`` | [`Depletion(TimeVarying(N), Hazard(), Flow(0 => :S, TimeVarying(b); form = Truncate()))`](@ref ComposableRecurrences.Depletion) | [Depletion in practice](@ref explanation-depletion-examples) |
| Vaccine doses from a weekly budget | ``x_t = \min(d_t, Z_t)``, with ``Z_t`` refilled by ``b`` each week | [`Depletion(Flow(0 => :Z, TimeVarying(b); form = Truncate()), Truncate(; overflow = :stratum); pools = (:Z,))`](@ref ComposableRecurrences.Depletion), with `b` the weekly grants | [Depletion in practice](@ref explanation-depletion-examples) |

Within one step a hazard flow acts before a count flow, so waning comes before the day's doses.

## [Reporting and clinical delays](@id domain-delays)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Reporting delay ``w_l`` | ``C_t = \sum_{l=0}^{L-1} w_l I_{t-l}`` | [`Convolution(w)`](@ref Convolution) | [Three towns](@ref overview-build) |
| Clinical transitions, each with probability ``h`` | ``A_t = h \sum_l w_l O_{t-l}``, one `Convolution` per transition | `Convolution(w)(O; gain = h)`, chained | [Clinical outcomes](@ref tutorial-clinical-outcomes) |
| Delay that changes over time | ``C_t = \sum_l w_l(t) I_{t-l}`` or ``\sum_l w_l(t - l) I_{t-l}`` | [`Convolution(TimeVarying(W))`](@ref TimeVarying), or `TimeVarying(W, Primary())` | [Time-varying delays and kernels](@ref tutorial-time-varying-kernels) |
| Hazard ``h_1, \dots, h_n`` read a day late and held past the data | ``\lambda_t = h_{\min(\max(t - 1, 1), n)}`` | change points `TimeVarying(Pair.([1; 2:(n + 1)], vcat(h[1], h)))` inside [`Survival`](@ref ComposableRecurrences.Survival) or a `Derived` kernel: the last value holds, so no padding is needed | [`TimeVarying`](@ref) docstring |

## [Places and groups](@id domain-places)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Mixing between places or groups | ``I_{t,i} = R_{t,i} \sum_j K_{ij} \sum_l g_l I_{t-l,j}`` | `Recurrence(g; coupling = K)` | [Spatial models](@ref tutorial-spatial-strata) |
| Generation interval per group or pair | ``g_{i,l}`` or ``g_{ij,l}`` | [`PerStratum(W)`](@ref PerStratum), [`Pairwise(A)`](@ref Pairwise) | [Spatial models](@ref tutorial-spatial-strata) |
| Transmission routes, such as community and funeral contacts | ``I_{t,i} = R_{t,i} \sum_r \sum_j K^{(r)}_{ij} \sum_l g^{(r)}_l I_{t-l,j}`` | [`Recurrence(Pairwise(K₁ => g₁, K₂ => g₂))`](@ref Pairwise) | [Spatial models](@ref tutorial-spatial-strata) |
| Importation between patches | a share ``M_{ij}`` of patch ``j``'s infections occurs in patch ``i``, with ``M = I - \operatorname{diag}(\varepsilon \odot o) + K \operatorname{diag}(\varepsilon)`` for a movement matrix ``K`` with column sums ``o`` | [`Redistribute(K, ε)`](@ref ComposableRecurrences.Redistribute) | [Spatial models](@ref tutorial-spatial-strata) |
| Districts sharing a patch total ``\bar I_{t,p}`` fixed elsewhere | ``I_{t,i} = \bar I_{t,p}\, u_{t,i} / \sum_{j \in p} u_{t,j}``, with ``u_{t,i}`` district ``i``'s own new infections before the split | [`Allocate(groups, TimeVarying(PerStratum(Ī)))`](@ref ComposableRecurrences.Allocate) | [Spatial models](@ref tutorial-spatial-strata) |

## [Branching processes and isolation](@id domain-branching)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Multi-type offspring, mean matrix ``K`` | ``y_n = K y_{n-1}``, growth per generation tends to the spectral radius of ``K`` | `Recurrence([1.0]; coupling = K)` | [Branching processes](@ref tutorial-branching) |
| Isolation | ``g_l \big(1 - p\, b\, F(l)\big)`` | a thinned kernel `g .* (1 .- p * b .* F)` | [Branching processes](@ref tutorial-branching) |
| Isolation delay set by type | ``g_{j,l} \big(1 - p\, b\, F_j(l)\big)`` for infector type ``j`` | [`Recurrence(PerStratum(W); coupling = K)`](@ref PerStratum) | [Branching processes](@ref tutorial-branching) |
| Contact tracing, traced and untraced types (an approximation) | a share ``\psi`` of infectees is traced and uses the thinned kernel | [`Recurrence(Pairwise(A))`](@ref Pairwise) | [Branching processes](@ref tutorial-branching) |
| Isolation that starts on a set day, by infection day | ``I_t = R_t \sum_l g_l(t - l) I_{t-l}``, ``g_l(\tau) = g_l \big(1 - p\, b\, P(D \le l,\ \tau + D \ge t_0)\big)`` | [`Recurrence(TimeVarying(W, Primary()))`](@ref ComposableRecurrences.Primary), seeded with `start = m + 1` | [Time-varying delays and kernels](@ref tutorial-time-varying-kernels) |
| Branching-process extinction by generation | ``q_t = G(q_{t-1})``, ``q_0 = 0``, with ``G`` the offspring probability generating function | [`Recurrence([1.0]; modifiers = (Transform(G, θ),))`](@ref ComposableRecurrences.Transform), called as `r(; history = [0.0], stop)` | [Branching processes](@ref tutorial-branching) |

## [Hospital occupancy and capacity](@id domain-occupancy)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Bed occupancy, survival ``\bar F_l`` of the length of stay | ``O_t = \sum_{l \ge 0} \bar F_l A_{t-l}``; for a geometric stay, ``\bar F_l = (1 - \delta)^l`` and ``O_t = (1 - \delta) O_{t-1} + A_t`` | `Convolution(S)(A)`; for a geometric stay, `Recurrence([1 - δ])(; history, add = A)` | [Occupancy and capacity](@ref tutorial-occupancy) |
| Patients moving between the pools of a ward | ``U_t = e^{-(c + r)} (U_{t-1} + A_t)``, ``Q_t = e^{-d} Q_{t-1} + \tfrac{c}{c + r}\big(1 - e^{-(c + r)}\big)(U_{t-1} + A_t)`` | [`Recurrence([1.0]; modifiers = (Depletion(Flow(:U => :Q, c), Flow(:U => 0, r), Flow(:Q => 0, d); pools = (:U, :Q)),))`](@ref ComposableRecurrences.Depletion) | [Occupancy and capacity](@ref tutorial-occupancy) |
| Bed cap, geometric stay | ``O_t = \min(O_t, B)`` | [`Transform(clamp, 0, B)`](@ref ComposableRecurrences.Transform) | [Occupancy and capacity](@ref tutorial-occupancy) |
| Bed cap, any stay | ``x_t = \min\big(A_t, (B - \sum_{l \ge 1} \bar F_l x_{t-l}) / \bar F_0\big)`` admitted, ``A_t - x_t`` turned away, ``O_t = \sum_{l \ge 0} \bar F_l x_{t-l}`` | [`Recurrence([0.0]; modifiers = (Transform(min, (B - Recent(S[2:end])) / S[1]),))(; history = [0.0], add = A)`](@ref ComposableRecurrences.Transform), then `Convolution(S)` | [Occupancy and capacity](@ref tutorial-occupancy) |
| Isolation beds with overflow | ``x_t = \min\big(A_t, \max(B - (1 - \delta) O_{t-1}, 0)\big)`` of the admissions asked for, ``A_t``, admitted and ``A_t - x_t`` left in the community | [`Depletion(B, Flow(:O => 0, δ; form = Share()), Truncate(; into = :O, overflow = :stratum); pools = (:O,))`](@ref ComposableRecurrences.Depletion) | [Depletion in practice](@ref explanation-depletion-examples) |

## [Seeding and forecasting](@id domain-seeding)

| Model feature | Maths | Code | Tutorial |
|---|---|---|---|
| Seed days returned with the run | ``I_1, \dots, I_m`` then the renewal | `vcat(history, r(R; history))` | [What a call returns](@ref explanation-returns) |
| Seed on an exponential growth path | ``h_l = I_0 e^{r (l - L)}``, at a given rate ``r`` per step | [`exponential_history(I0, r, L)`](@ref ComposableRecurrences.exponential_history) | [Renewal then delay](@ref tutorial-renewal-delay) |
| Forecast after a fit | continue ``I_t`` from the fitted days | [`r(R; history, record = (:state,))`](@ref Recurrence), then `r(R; state)` | [Forecasting](@ref tutorial-forecasting) |
