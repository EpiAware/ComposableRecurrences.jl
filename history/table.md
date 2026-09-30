|                                                                                      | d305c78b9523d4...  |
|:-------------------------------------------------------------------------------------|:------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0404 ± 0.0042 ms |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 18.7 ± 0.6 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 6.45 ± 0.49 μs     |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.12 ± 0.018 ms    |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 23.6 ± 2.2 μs      |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 3.21 ± 0.072 μs    |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 25.5 ± 1.3 μs      |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.441 ± 0.033 ms   |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 17.9 ± 2 μs        |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0525 ± 0.0035 ms |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 0.976 ± 0.28 ms    |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 21.9 ± 1.3 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 6.06 ± 0.39 μs     |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.0701 ± 0.015 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0497 ± 0.0058 ms |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 22.5 ± 0.65 μs     |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 8.23 ± 0.57 μs     |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.129 ± 0.032 ms   |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 28.5 ± 2.7 μs      |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 4.24 ± 0.13 μs     |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0351 ± 0.0028 ms |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.306 ± 0.019 ms   |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0352 ± 0.0015 ms |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0352 ± 0.0047 ms |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 0.716 ± 0.11 ms    |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0372 ± 0.0028 ms |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 16.9 ± 0.11 μs     |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.221 ± 0.052 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.244 ± 0.023 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 30.8 ± 1.5 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.035 ± 0.0046 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 0.675 ± 0.072 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0402 ± 0.0025 ms |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 11.7 ± 0.3 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.122 ± 0.028 ms   |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0483 ± 0.005 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 21.4 ± 0.7 μs      |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 7.84 ± 0.57 μs     |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.127 ± 0.025 ms   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 27.7 ± 2.3 μs      |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 4.33 ± 0.12 μs     |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0335 ± 0.0019 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.0883 ± 0.0085 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 16 ± 0.99 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0352 ± 0.0033 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.236 ± 0.024 ms   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 21 ± 1.1 μs        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 15.6 ± 0.13 μs     |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.179 ± 0.045 ms   |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.192 ± 0.018 ms   |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 18.7 ± 5.3 μs      |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.513 ± 0.069 ms   |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0394 ± 0.0038 ms |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 13.2 ± 0.11 μs     |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.143 ± 0.035 ms   |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0432 ± 0.0019 ms |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.0659 ± 0.0028 ms |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 0.683 ± 0.085 ms   |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0471 ± 0.0044 ms |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 18.4 ± 0.14 μs     |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.189 ± 0.044 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 0.839 ± 0.053 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0358 ± 0.0025 ms |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.0885 ± 0.01 ms   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 2.28 ± 0.35 ms     |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0409 ± 0.003 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 11.4 ± 0.15 μs     |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.15 ± 0.031 ms    |
| time_to_load                                                                         | 0.14 ± 0.0014 s    |

|                                                                                      | d305c78b9523d4...         |
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

