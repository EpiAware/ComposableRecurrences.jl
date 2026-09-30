|                                                                                      | 45399acb831aa6...   |
|:-------------------------------------------------------------------------------------|:-------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0636 ± 0.0071 ms  |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 30.1 ± 0.69 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 10.2 ± 0.79 μs      |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.209 ± 0.018 ms    |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0392 ± 0.0012 ms  |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 6.1 ± 0.06 μs       |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0486 ± 0.0013 ms  |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.681 ± 0.035 ms    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 28 ± 3.6 μs         |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0691 ± 0.0031 ms  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.72 ± 0.12 ms      |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0378 ± 0.0013 ms  |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 13.7 ± 0.24 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.112 ± 0.023 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0755 ± 0.0079 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0355 ± 0.00066 ms |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 14.3 ± 1.4 μs       |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.232 ± 0.051 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0478 ± 0.0024 ms  |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.62 ± 0.09 μs      |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0614 ± 0.0015 ms  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.464 ± 0.046 ms    |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0557 ± 0.0027 ms  |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0499 ± 0.0093 ms  |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.28 ± 0.13 ms      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0644 ± 0.0018 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.033 ± 0.00031 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.37 ± 0.069 ms     |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.373 ± 0.041 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0488 ± 0.0019 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0668 ± 0.012 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.18 ± 0.19 ms      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0709 ± 0.0046 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 21.6 ± 0.95 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.207 ± 0.04 ms     |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0706 ± 0.0078 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0343 ± 0.00065 ms |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 14 ± 1.4 μs         |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.229 ± 0.039 ms    |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0469 ± 0.0025 ms  |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.84 ± 0.092 μs     |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0614 ± 0.002 ms   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.139 ± 0.012 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 25.7 ± 1.2 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0586 ± 0.0045 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.403 ± 0.03 ms     |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0377 ± 0.00093 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 29.1 ± 0.48 μs      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.303 ± 0.071 ms    |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.299 ± 0.027 ms    |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 30.3 ± 7.9 μs       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.898 ± 0.083 ms    |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0656 ± 0.003 ms   |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 23.6 ± 0.18 μs      |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.247 ± 0.054 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0695 ± 0.0022 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.117 ± 0.05 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.22 ± 0.097 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0792 ± 0.0044 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0375 ± 0.0032 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.335 ± 0.074 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.31 ± 0.15 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0559 ± 0.0039 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.128 ± 0.015 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 3.92 ± 0.36 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0727 ± 0.0034 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 22.1 ± 0.36 μs      |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.251 ± 0.046 ms    |
| time_to_load                                                                         | 0.238 ± 0.0035 s    |

|                                                                                      | 45399acb831aa6...         |
|:-------------------------------------------------------------------------------------|:-------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.628 k allocs: 0.0349 MB |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 0.149 k allocs: 8 kB      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 0.042 k allocs: 12.1 kB   |
| AD gradients/Convolution delay with history/Mooncake forward                         | 3.25 k allocs: 0.109 MB   |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.596 k allocs: 19.4 kB   |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 2  allocs: 0.219 kB       |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.778 k allocs: 30.7 kB   |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 5.4 k allocs: 0.518 MB    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 0.117 k allocs: 12.4 kB   |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.422 k allocs: 0.288 MB  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 23.4 k allocs: 1.45 MB    |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.421 k allocs: 18.3 kB   |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 2  allocs: 1.48 kB        |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 1.63 k allocs: 0.0651 MB  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.815 k allocs: 0.0409 MB |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.175 k allocs: 7.5 kB    |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 0.068 k allocs: 13.5 kB   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 3.81 k allocs: 0.129 MB   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.767 k allocs: 24.8 kB   |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 2  allocs: 0.219 kB       |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 1.01 k allocs: 0.0374 MB  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 3.45 k allocs: 0.293 MB   |
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
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.789 k allocs: 0.0394 MB |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.17 k allocs: 7.31 kB    |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 0.066 k allocs: 13.4 kB   |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 3.73 k allocs: 0.126 MB   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.749 k allocs: 23.9 kB   |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 2  allocs: 0.219 kB       |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 1.01 k allocs: 0.0374 MB  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 1.37 k allocs: 0.12 MB    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 0.19 k allocs: 14.7 kB    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.162 k allocs: 0.0761 MB |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 4.71 k allocs: 0.287 MB   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.333 k allocs: 14.4 kB   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 3  allocs: 0.406 kB       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 4.31 k allocs: 0.155 MB   |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 2.5 k allocs: 0.19 MB     |
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
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 11 k allocs: 0.879 MB     |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.371 k allocs: 24 kB     |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.818 k allocs: 0.338 MB  |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 0.047 M allocs: 2.36 MB   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.799 k allocs: 31.7 kB   |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 2  allocs: 1.8 kB         |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 3.2 k allocs: 0.126 MB    |
| time_to_load                                                                         | 0.2 k allocs: 11.8 kB     |

