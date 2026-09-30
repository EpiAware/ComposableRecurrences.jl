|                                                                                      | 04eb582f4207c1...   |
|:-------------------------------------------------------------------------------------|:-------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0606 ± 0.0076 ms  |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 29.6 ± 0.57 μs      |
| AD gradients/Convolution delay with history/ForwardDiff                              | 9.09 ± 0.56 μs      |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.239 ± 0.037 ms    |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0496 ± 0.0022 ms  |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.81 ± 0.045 μs     |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.049 ± 0.0011 ms   |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.625 ± 0.036 ms    |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 29.5 ± 3.7 μs       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.078 ± 0.1 ms      |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 2 ± 0.19 ms         |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0545 ± 0.0018 ms  |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 12.7 ± 0.13 μs      |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.121 ± 0.021 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0727 ± 0.0079 ms  |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0369 ± 0.00078 ms |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13.7 ± 1.3 μs       |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.244 ± 0.052 ms    |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0613 ± 0.0035 ms  |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.26 ± 0.22 μs      |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0628 ± 0.0013 ms  |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.421 ± 0.024 ms    |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0566 ± 0.0013 ms  |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0569 ± 0.016 ms   |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.26 ± 0.12 ms      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0855 ± 0.0029 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0347 ± 0.0036 ms  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.407 ± 0.061 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.375 ± 0.035 ms    |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0525 ± 0.003 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0724 ± 0.015 ms   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.26 ± 0.23 ms      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0884 ± 0.0031 ms  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 21.7 ± 0.19 μs      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.214 ± 0.032 ms    |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0703 ± 0.0082 ms  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0358 ± 0.00074 ms |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 13.3 ± 1.3 μs       |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.235 ± 0.047 ms    |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0592 ± 0.0029 ms  |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.76 ± 0.12 μs      |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0622 ± 0.0012 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.144 ± 0.015 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 26.5 ± 1.2 μs       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.0547 ± 0.0045 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.398 ± 0.036 ms    |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0514 ± 0.0014 ms  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 0.0319 ± 0.00099 ms |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.314 ± 0.057 ms    |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.308 ± 0.024 ms    |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.066 ± 0.032 ms    |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.94 ± 0.12 ms      |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0853 ± 0.0037 ms  |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 25.6 ± 2.9 μs       |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.257 ± 0.041 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0755 ± 0.0029 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.108 ± 0.048 ms    |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.26 ± 0.13 ms      |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0987 ± 0.0037 ms  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0362 ± 0.00031 ms |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.348 ± 0.06 ms     |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.22 ± 0.15 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0598 ± 0.0052 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.132 ± 0.042 ms    |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 4.05 ± 0.44 ms      |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0929 ± 0.0038 ms  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 22.8 ± 1.8 μs       |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.262 ± 0.033 ms    |
| time_to_load                                                                         | 0.238 ± 0.0016 s    |

|                                                                                      | 04eb582f4207c1...         |
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

