|                                                                                      | 59f7b2fa9580a5...   |
|:-------------------------------------------------------------------------------------|:-------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0624 ± 0.0061 ms  |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 29.6 ± 0.61 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 9.03 ± 0.55 μs      |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.24 ± 0.038 ms     |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0505 ± 0.0014 ms  |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.84 ± 0.044 μs     |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0505 ± 0.001 ms   |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.634 ± 0.027 ms    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 29.5 ± 3.6 μs       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0765 ± 0.1 ms     |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.92 ± 0.2 ms       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0552 ± 0.0015 ms  |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 13 ± 0.17 μs        |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.125 ± 0.021 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0732 ± 0.0076 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0366 ± 0.00061 ms |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13.5 ± 1.2 μs       |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.24 ± 0.05 ms      |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0609 ± 0.0028 ms  |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.25 ± 0.56 μs      |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0629 ± 0.0013 ms  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.416 ± 0.025 ms    |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0579 ± 0.0024 ms  |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.055 ± 0.015 ms    |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.26 ± 0.11 ms      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0878 ± 0.0023 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0385 ± 0.00026 ms |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.446 ± 0.06 ms     |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.37 ± 0.029 ms     |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0521 ± 0.0035 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0722 ± 0.014 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.29 ± 0.23 ms      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0912 ± 0.0032 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 20.3 ± 0.18 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.222 ± 0.03 ms     |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0705 ± 0.0053 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0355 ± 0.00065 ms |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 13.3 ± 1.2 μs       |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.24 ± 0.046 ms     |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0602 ± 0.0024 ms  |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.23 ± 0.068 μs     |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.063 ± 0.0012 ms   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.142 ± 0.015 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 26.7 ± 1.2 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0536 ± 0.0044 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.387 ± 0.03 ms     |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0526 ± 0.0013 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 0.032 ± 0.00017 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.313 ± 0.056 ms    |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.31 ± 0.025 ms     |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.0663 ± 0.0097 ms  |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.964 ± 0.12 ms     |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0865 ± 0.0028 ms  |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 26.8 ± 0.25 μs      |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.26 ± 0.041 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0752 ± 0.0028 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.107 ± 0.05 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.25 ± 0.12 ms      |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.103 ± 0.0041 ms   |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.037 ± 0.00048 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.356 ± 0.059 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.22 ± 0.16 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0604 ± 0.0049 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.13 ± 0.041 ms     |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 4.06 ± 0.43 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0957 ± 0.0047 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 23.6 ± 0.24 μs      |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.263 ± 0.03 ms     |
| time_to_load                                                                         | 0.236 ± 0.00081 s   |

|                                                                                      | 59f7b2fa9580a5...         |
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

