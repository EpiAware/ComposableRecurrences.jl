|                                                                                      | 202376198636a0...   |
|:-------------------------------------------------------------------------------------|:-------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.06 ± 0.0083 ms    |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 30.2 ± 0.63 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 8.8 ± 0.6 μs        |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.203 ± 0.021 ms    |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0436 ± 0.0022 ms  |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.65 ± 0.042 μs     |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0494 ± 0.0012 ms  |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.588 ± 0.028 ms    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 28 ± 3.8 μs         |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0677 ± 0.0029 ms  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.56 ± 0.093 ms     |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0452 ± 0.0016 ms  |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 12.8 ± 0.14 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.128 ± 0.021 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0702 ± 0.0074 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0363 ± 0.00067 ms |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 12.9 ± 1 μs         |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.226 ± 0.044 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0564 ± 0.0032 ms  |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.21 ± 0.072 μs     |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0629 ± 0.0018 ms  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.53 ± 0.031 ms     |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0583 ± 0.0035 ms  |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0482 ± 0.0076 ms  |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.24 ± 0.11 ms      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0835 ± 0.0035 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0384 ± 0.00026 ms |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.393 ± 0.057 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.361 ± 0.035 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0512 ± 0.0031 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.063 ± 0.0095 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.15 ± 0.15 ms      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0843 ± 0.0039 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 20.2 ± 0.17 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.213 ± 0.032 ms    |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0706 ± 0.0076 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0351 ± 0.00063 ms |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 12.7 ± 0.91 μs      |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.217 ± 0.039 ms    |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0535 ± 0.0016 ms  |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.29 ± 0.058 μs     |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0633 ± 0.0026 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.137 ± 0.011 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 25.9 ± 2.3 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0507 ± 0.0035 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.376 ± 0.026 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0467 ± 0.0015 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 0.0323 ± 0.00036 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.315 ± 0.059 ms    |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.302 ± 0.026 ms    |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 28.9 ± 6.5 μs       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.899 ± 0.076 ms    |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0804 ± 0.004 ms   |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 22.5 ± 0.2 μs       |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.255 ± 0.04 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0726 ± 0.003 ms   |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.107 ± 0.045 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.22 ± 0.088 ms     |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0936 ± 0.0044 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0353 ± 0.00034 ms |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.346 ± 0.059 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.16 ± 0.18 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0589 ± 0.0051 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.125 ± 0.014 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 3.8 ± 0.43 ms       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0889 ± 0.0078 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 22.5 ± 1.6 μs       |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.263 ± 0.04 ms     |
| time_to_load                                                                         | 0.235 ± 0.0024 s    |

|                                                                                      | 202376198636a0...         |
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

