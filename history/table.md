|                                                                                      | 0ca43ac0c014a9...  |
|:-------------------------------------------------------------------------------------|:------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0547 ± 0.0058 ms |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 24.1 ± 0.75 μs     |
| AD gradients/Convolution delay with history/ForwardDiff                              | 6.8 ± 0.42 μs      |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.145 ± 0.015 ms   |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 28.9 ± 1.4 μs      |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 4.4 ± 0.9 μs       |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0395 ± 0.0024 ms |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.5 ± 0.031 ms     |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 23.4 ± 2.1 μs      |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0899 ± 0.006 ms  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.14 ± 0.18 ms     |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 28.3 ± 1.9 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 7.98 ± 0.2 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.0975 ± 0.014 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0647 ± 0.0075 ms |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 29.3 ± 0.89 μs     |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 10.6 ± 0.62 μs     |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.157 ± 0.033 ms   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0346 ± 0.002 ms  |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 5.09 ± 0.07 μs     |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0504 ± 0.0027 ms |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.357 ± 0.022 ms   |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0472 ± 0.0026 ms |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0502 ± 0.0074 ms |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 0.863 ± 0.081 ms   |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0475 ± 0.0025 ms |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 23.9 ± 0.77 μs     |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.303 ± 0.045 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.304 ± 0.025 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0407 ± 0.0018 ms |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.058 ± 0.0062 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 0.827 ± 0.08 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0524 ± 0.0029 ms |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 14.9 ± 0.46 μs     |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.164 ± 0.025 ms   |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0618 ± 0.006 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 28.6 ± 1.1 μs      |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 10.3 ± 0.59 μs     |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.155 ± 0.029 ms   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0339 ± 0.0019 ms |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 5.16 ± 0.062 μs    |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0509 ± 0.0029 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.107 ± 0.01 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 21.5 ± 1.2 μs      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0383 ± 0.0025 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.267 ± 0.024 ms   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 28.1 ± 0.92 μs     |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 19.6 ± 0.34 μs     |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.239 ± 0.043 ms   |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.244 ± 0.019 ms   |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 31.5 ± 5.1 μs      |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.606 ± 0.059 ms   |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0473 ± 0.002 ms  |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 17 ± 0.16 μs       |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.193 ± 0.033 ms   |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0577 ± 0.0033 ms |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.079 ± 0.02 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 0.826 ± 0.073 ms   |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0565 ± 0.0033 ms |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 23.5 ± 0.29 μs     |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.266 ± 0.043 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.02 ± 0.056 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0467 ± 0.0028 ms |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.126 ± 0.013 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 2.59 ± 0.3 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0527 ± 0.0039 ms |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 15.3 ± 0.23 μs     |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.2 ± 0.031 ms     |
| time_to_load                                                                         | 0.205 ± 0.0027 s   |

|                                                                                      | 0ca43ac0c014a9...         |
|:-------------------------------------------------------------------------------------|:-------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.631 k allocs: 0.0351 MB |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 0.149 k allocs: 8 kB      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 0.042 k allocs: 12.1 kB   |
| AD gradients/Convolution delay with history/Mooncake forward                         | 3.25 k allocs: 0.109 MB   |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.596 k allocs: 19.4 kB   |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 2  allocs: 0.219 kB       |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.778 k allocs: 30.7 kB   |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 4.48 k allocs: 0.49 MB    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 0.117 k allocs: 12.4 kB   |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.422 k allocs: 0.288 MB  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 23.4 k allocs: 1.45 MB    |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.421 k allocs: 18.3 kB   |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 2  allocs: 1.48 kB        |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 1.63 k allocs: 0.0651 MB  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.818 k allocs: 0.0411 MB |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.175 k allocs: 7.5 kB    |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 0.068 k allocs: 13.5 kB   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 3.81 k allocs: 0.129 MB   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.767 k allocs: 24.8 kB   |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 2  allocs: 0.219 kB       |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 1.01 k allocs: 0.0374 MB  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 3.33 k allocs: 0.289 MB   |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.426 k allocs: 24.3 kB   |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.303 k allocs: 0.136 MB  |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 16.1 k allocs: 0.766 MB   |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.638 k allocs: 24.5 kB   |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 2  allocs: 0.75 kB        |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 4.71 k allocs: 0.185 MB   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 2.91 k allocs: 0.239 MB   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.223 k allocs: 16 kB     |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.266 k allocs: 0.116 MB  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 14.3 k allocs: 0.641 MB   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 1.09 k allocs: 0.0377 MB  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 2  allocs: 0.562 kB       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 2.85 k allocs: 0.107 MB   |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.792 k allocs: 0.0396 MB |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.17 k allocs: 7.31 kB    |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 0.066 k allocs: 13.4 kB   |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 3.73 k allocs: 0.126 MB   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.749 k allocs: 23.9 kB   |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 2  allocs: 0.219 kB       |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 1.01 k allocs: 0.0374 MB  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 1.38 k allocs: 0.12 MB    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 0.19 k allocs: 14.7 kB    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.162 k allocs: 0.0761 MB |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 4.71 k allocs: 0.287 MB   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.333 k allocs: 14.4 kB   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 3  allocs: 0.406 kB       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 4.31 k allocs: 0.155 MB   |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 2.51 k allocs: 0.19 MB    |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.217 k allocs: 0.0927 MB |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 11.1 k allocs: 0.513 MB   |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.96 k allocs: 0.0333 MB  |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 2  allocs: 0.516 kB       |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 3.46 k allocs: 0.125 MB   |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.352 k allocs: 22.6 kB   |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.326 k allocs: 0.134 MB  |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 15 k allocs: 0.696 MB     |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 1.12 k allocs: 0.0392 MB  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 2  allocs: 0.562 kB       |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 4.47 k allocs: 0.167 MB   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 9.83 k allocs: 0.844 MB   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.371 k allocs: 24 kB     |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.818 k allocs: 0.338 MB  |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 0.047 M allocs: 2.36 MB   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.799 k allocs: 31.7 kB   |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 2  allocs: 1.8 kB         |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 3.2 k allocs: 0.126 MB    |
| time_to_load                                                                         | 0.2 k allocs: 11.8 kB     |

