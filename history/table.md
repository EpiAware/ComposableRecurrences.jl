|                                                                                      | 369d71036f0dee...   |
|:-------------------------------------------------------------------------------------|:-------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0616 ± 0.0061 ms  |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 30.2 ± 0.68 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 8.86 ± 0.61 μs      |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.198 ± 0.026 ms    |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0427 ± 0.0026 ms  |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.74 ± 0.04 μs      |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0498 ± 0.001 ms   |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.597 ± 0.029 ms    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 28.2 ± 3.6 μs       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0709 ± 0.0032 ms  |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.62 ± 0.11 ms      |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0437 ± 0.0015 ms  |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 11.3 ± 0.15 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.125 ± 0.022 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0724 ± 0.0075 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0367 ± 0.00073 ms |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13 ± 1.2 μs         |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.226 ± 0.044 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0557 ± 0.004 ms   |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.49 ± 0.06 μs      |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0631 ± 0.0014 ms  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.447 ± 0.032 ms    |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0588 ± 0.0042 ms  |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0473 ± 0.0074 ms  |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.23 ± 0.091 ms     |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0815 ± 0.0031 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0331 ± 0.0005 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.383 ± 0.057 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.359 ± 0.034 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0518 ± 0.0033 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.064 ± 0.0096 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.16 ± 0.13 ms      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.082 ± 0.0032 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 22.2 ± 0.32 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.213 ± 0.031 ms    |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0699 ± 0.0072 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0351 ± 0.00065 ms |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 12.4 ± 0.99 μs      |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.219 ± 0.038 ms    |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0522 ± 0.0016 ms  |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.78 ± 0.41 μs      |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0632 ± 0.0022 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.136 ± 0.014 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 25.5 ± 1.1 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0503 ± 0.0035 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.368 ± 0.027 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0456 ± 0.0015 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 30.3 ± 1.9 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.317 ± 0.059 ms    |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.296 ± 0.024 ms    |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 29.2 ± 6.4 μs       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.89 ± 0.075 ms     |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.077 ± 0.0027 ms   |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 25.3 ± 2.1 μs       |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.254 ± 0.041 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0719 ± 0.0034 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.105 ± 0.043 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.22 ± 0.11 ms      |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0902 ± 0.0033 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.039 ± 0.0016 ms   |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.345 ± 0.058 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.18 ± 0.071 ms     |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0595 ± 0.0053 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.123 ± 0.013 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 3.84 ± 0.47 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0875 ± 0.0067 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 25 ± 0.35 μs        |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.264 ± 0.041 ms    |
| time_to_load                                                                         | 0.237 ± 0.0027 s    |

|                                                                                      | 369d71036f0dee...         |
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

