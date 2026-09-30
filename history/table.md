|                                                                                      | f67ce07f3155c2...  |
|:-------------------------------------------------------------------------------------|:------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0556 ± 0.0049 ms |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 24.5 ± 1.1 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 7.07 ± 0.49 μs     |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.173 ± 0.022 ms   |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0332 ± 0.0023 ms |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 4.21 ± 0.12 μs     |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0403 ± 0.0028 ms |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.543 ± 0.03 ms    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 25.2 ± 1.8 μs      |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.103 ± 0.011 ms   |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.42 ± 0.16 ms     |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0329 ± 0.0018 ms |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 8.19 ± 0.16 μs     |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.101 ± 0.015 ms   |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0689 ± 0.0046 ms |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 30 ± 1.3 μs        |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 10.6 ± 0.7 μs      |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.17 ± 0.034 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0374 ± 0.0017 ms |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 5.23 ± 0.088 μs    |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0526 ± 0.0029 ms |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.351 ± 0.024 ms   |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.049 ± 0.0063 ms  |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0654 ± 0.012 ms  |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 0.892 ± 0.082 ms   |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0498 ± 0.0026 ms |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 24.5 ± 1.1 μs      |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.325 ± 0.039 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.325 ± 0.029 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0428 ± 0.0017 ms |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0686 ± 0.0092 ms |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 0.89 ± 0.074 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0549 ± 0.0033 ms |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 15.1 ± 0.24 μs     |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.168 ± 0.016 ms   |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0668 ± 0.0052 ms |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 29.4 ± 0.88 μs     |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 10.3 ± 0.63 μs     |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.167 ± 0.031 ms   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0368 ± 0.0014 ms |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 5.29 ± 0.092 μs    |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0518 ± 0.0033 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.125 ± 0.014 ms   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 24.7 ± 1.1 μs      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0425 ± 0.0051 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.309 ± 0.033 ms   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0336 ± 0.0012 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 22 ± 0.3 μs        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.26 ± 0.033 ms    |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.277 ± 0.026 ms   |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.0344 ± 0.0069 ms |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.715 ± 0.071 ms   |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0551 ± 0.0023 ms |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 18.7 ± 0.25 μs     |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.214 ± 0.025 ms   |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0679 ± 0.0052 ms |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.0872 ± 0.022 ms  |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 0.922 ± 0.1 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0654 ± 0.004 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 25.8 ± 2.1 μs      |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.286 ± 0.038 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.15 ± 0.11 ms     |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0514 ± 0.0048 ms |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.156 ± 0.028 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 2.97 ± 0.36 ms     |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0571 ± 0.0058 ms |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 15.6 ± 0.23 μs     |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.222 ± 0.022 ms   |
| time_to_load                                                                         | 0.213 ± 0.00041 s  |

|                                                                                      | f67ce07f3155c2...         |
|:-------------------------------------------------------------------------------------|:-------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.631 k allocs: 0.0348 MB |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 0.147 k allocs: 7.97 kB   |
| AD gradients/Convolution delay with history/ForwardDiff                              | 0.042 k allocs: 12.1 kB   |
| AD gradients/Convolution delay with history/Mooncake forward                         | 4.19 k allocs: 0.138 MB   |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.69 k allocs: 22 kB      |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 2  allocs: 0.219 kB       |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.779 k allocs: 30.8 kB   |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 4.7 k allocs: 0.506 MB    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 0.122 k allocs: 12.5 kB   |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.437 k allocs: 0.289 MB  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 0.0319 M allocs: 1.73 MB  |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.533 k allocs: 22 kB     |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 2  allocs: 1.48 kB        |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 1.64 k allocs: 0.0653 MB  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.862 k allocs: 0.0431 MB |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.181 k allocs: 7.84 kB   |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 0.072 k allocs: 14.3 kB   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 4.17 k allocs: 0.141 MB   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.818 k allocs: 26.2 kB   |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 2  allocs: 0.219 kB       |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 1.01 k allocs: 0.0375 MB  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 3.15 k allocs: 0.279 MB   |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.246 k allocs: 20 kB     |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.303 k allocs: 0.154 MB  |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 17.3 k allocs: 0.828 MB   |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.68 k allocs: 25.9 kB    |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 2  allocs: 0.75 kB        |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 4.85 k allocs: 0.19 MB    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 3.18 k allocs: 0.262 MB   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.233 k allocs: 17.1 kB   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.29 k allocs: 0.13 MB    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 15.7 k allocs: 0.709 MB   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 1.14 k allocs: 0.0395 MB  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 2  allocs: 0.562 kB       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 2.86 k allocs: 0.107 MB   |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.836 k allocs: 0.0416 MB |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.176 k allocs: 7.66 kB   |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 0.07 k allocs: 14.2 kB    |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 4.09 k allocs: 0.137 MB   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.8 k allocs: 25.3 kB     |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 2  allocs: 0.219 kB       |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 1.01 k allocs: 0.0375 MB  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 1.5 k allocs: 0.132 MB    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 0.198 k allocs: 15.6 kB   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.174 k allocs: 0.0836 MB |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 5.38 k allocs: 0.321 MB   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.381 k allocs: 16 kB     |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 2  allocs: 0.359 kB       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 4.29 k allocs: 0.155 MB   |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 2.74 k allocs: 0.209 MB   |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.237 k allocs: 0.105 MB  |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 12.3 k allocs: 0.571 MB   |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 1.02 k allocs: 0.0351 MB  |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 2  allocs: 0.516 kB       |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 3.47 k allocs: 0.125 MB   |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.362 k allocs: 23.6 kB   |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.338 k allocs: 0.149 MB  |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 16.1 k allocs: 0.752 MB   |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 1.17 k allocs: 0.0409 MB  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 2  allocs: 0.562 kB       |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 4.47 k allocs: 0.167 MB   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 10.7 k allocs: 0.917 MB   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.383 k allocs: 25 kB     |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.886 k allocs: 0.384 MB  |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 0.0515 M allocs: 2.58 MB  |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.854 k allocs: 0.0328 MB |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 2  allocs: 1.8 kB         |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 3.21 k allocs: 0.126 MB   |
| time_to_load                                                                         | 0.2 k allocs: 11.8 kB     |

