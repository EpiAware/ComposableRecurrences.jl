|                                                                                      | v0.1.0             | df1893fb8a6392...   | v0.1.0 / df1893fb8a6392... |
|:-------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0456 ± 0.0027 ms | 0.0509 ± 0.0031 ms  | 0.895 ± 0.076              |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 20.4 ± 0.54 μs     | 20.1 ± 0.6 μs       | 1.02 ± 0.041               |
| AD gradients/Convolution delay with history/ForwardDiff                              | 6.23 ± 0.88 μs     | 6.32 ± 0.7 μs       | 0.986 ± 0.18               |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.143 ± 0.027 ms   | 0.148 ± 0.02 ms     | 0.968 ± 0.22               |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 26.7 ± 1.5 μs      | 27.7 ± 2.5 μs       | 0.967 ± 0.1                |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 3.31 ± 0.04 μs     | 3.37 ± 0.086 μs     | 0.982 ± 0.028              |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0335 ± 0.0019 ms | 0.0338 ± 0.0018 ms  | 0.991 ± 0.077              |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.473 ± 0.028 ms   | 0.48 ± 0.03 ms      | 0.986 ± 0.085              |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 21 ± 1.1 μs        | 20.7 ± 1.1 μs       | 1.02 ± 0.076               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0889 ± 0.043 ms  | 0.0933 ± 0.046 ms   | 0.954 ± 0.66               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.24 ± 0.13 ms     | 1.27 ± 0.19 ms      | 0.98 ± 0.18                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 27.7 ± 4.8 μs      | 28.2 ± 1.4 μs       | 0.982 ± 0.18               |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 6.43 ± 0.3 μs      | 7.38 ± 0.29 μs      | 0.871 ± 0.054              |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.0831 ± 0.014 ms  | 0.0855 ± 0.011 ms   | 0.972 ± 0.21               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 1.02 ± 0.064 ms    | 1.04 ± 0.1 ms       | 0.98 ± 0.11                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 0.9 ± 0.07 ms      | 0.9 ± 0.1 ms        | 1 ± 0.14                   |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.0488 ± 0.0044 ms | 0.0478 ± 0.0035 ms  | 1.02 ± 0.12                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.0685 ± 0.0034 ms | 0.0701 ± 0.0036 ms  | 0.977 ± 0.07               |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 0.416 ± 0.044 ms   | 0.373 ± 0.055 ms    | 1.12 ± 0.2                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 0.446 ± 0.046 ms   | 0.444 ± 0.054 ms    | 1.01 ± 0.16                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.0648 ± 0.0031 ms | 0.0665 ± 0.017 ms   | 0.975 ± 0.25               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 0.0959 ± 0.025 ms  | 0.103 ± 0.023 ms    | 0.935 ± 0.32               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 0.616 ± 0.066 ms   | 0.677 ± 0.13 ms     | 0.91 ± 0.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 0.675 ± 0.13 ms    | 0.698 ± 0.11 ms     | 0.967 ± 0.24               |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 1.02 ± 0.063 ms    | 1.05 ± 0.096 ms     | 0.969 ± 0.11               |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 0.913 ± 0.087 ms   | 0.891 ± 0.098 ms    | 1.02 ± 0.15                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.0508 ± 0.0066 ms | 0.0482 ± 0.0037 ms  | 1.05 ± 0.16                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.0713 ± 0.0035 ms | 0.0743 ± 0.0051 ms  | 0.959 ± 0.08               |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 0.45 ± 0.07 ms     | 0.378 ± 0.049 ms    | 1.19 ± 0.24                |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 0.446 ± 0.045 ms   | 0.46 ± 0.055 ms     | 0.97 ± 0.15                |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.0685 ± 0.0092 ms | 0.0652 ± 0.003 ms   | 1.05 ± 0.15                |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 0.0876 ± 0.02 ms   | 0.0937 ± 0.019 ms   | 0.935 ± 0.28               |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 0.631 ± 0.065 ms   | 0.628 ± 0.065 ms    | 1 ± 0.15                   |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 0.666 ± 0.083 ms   | 0.667 ± 0.078 ms    | 0.998 ± 0.17               |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0541 ± 0.0017 ms | 0.0621 ± 0.004 ms   | 0.871 ± 0.063              |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 25.2 ± 0.52 μs     | 24.6 ± 0.7 μs       | 1.03 ± 0.036               |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 8.95 ± 0.49 μs     | 8.93 ± 0.43 μs      | 1 ± 0.073                  |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.146 ± 0.015 ms   | 0.149 ± 0.017 ms    | 0.978 ± 0.15               |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 29.9 ± 0.87 μs     | 30.5 ± 1.2 μs       | 0.98 ± 0.048               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 4.15 ± 0.056 μs    | 4.2 ± 0.062 μs      | 0.989 ± 0.02               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0479 ± 0.0045 ms | 0.0446 ± 0.0049 ms  | 1.08 ± 0.15                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.319 ± 0.023 ms   | 0.317 ± 0.021 ms    | 1.01 ± 0.099               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0393 ± 0.003 ms  | 0.0397 ± 0.0044 ms  | 0.989 ± 0.13               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0549 ± 0.0045 ms | 0.0549 ± 0.0087 ms  | 1 ± 0.18                   |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 0.763 ± 0.086 ms   | 0.8 ± 0.11 ms       | 0.953 ± 0.17               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.042 ± 0.0047 ms  | 0.0412 ± 0.0016 ms  | 1.02 ± 0.12                |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 19 ± 0.22 μs       | 19.2 ± 0.21 μs      | 0.989 ± 0.016              |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.289 ± 0.04 ms    | 0.274 ± 0.039 ms    | 1.05 ± 0.21                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.283 ± 0.026 ms   | 0.286 ± 0.023 ms    | 0.99 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0369 ± 0.0057 ms | 0.0351 ± 0.00095 ms | 1.05 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0615 ± 0.012 ms  | 0.0588 ± 0.018 ms   | 1.05 ± 0.39                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 0.778 ± 0.091 ms   | 0.759 ± 0.14 ms     | 1.03 ± 0.22                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0443 ± 0.0022 ms | 0.0475 ± 0.0042 ms  | 0.934 ± 0.094              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 11.6 ± 0.17 μs     | 11.9 ± 0.2 μs       | 0.974 ± 0.022              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.144 ± 0.03 ms    | 0.144 ± 0.019 ms    | 0.999 ± 0.25               |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0612 ± 0.0015 ms | 0.056 ± 0.0053 ms   | 1.09 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 24.5 ± 0.54 μs     | 24.1 ± 0.7 μs       | 1.02 ± 0.037               |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 9.61 ± 0.85 μs     | 8.7 ± 0.43 μs       | 1.11 ± 0.11                |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.14 ± 0.02 ms     | 0.15 ± 0.02 ms      | 0.934 ± 0.18               |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0339 ± 0.0051 ms | 31.3 ± 2.4 μs       | 1.08 ± 0.18                |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 4.37 ± 0.065 μs    | 4.22 ± 0.059 μs     | 1.03 ± 0.021               |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0425 ± 0.0036 ms | 0.0472 ± 0.0073 ms  | 0.901 ± 0.16               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.118 ± 0.02 ms    | 0.107 ± 0.013 ms    | 1.1 ± 0.23                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 18.5 ± 0.73 μs     | 17.8 ± 0.75 μs      | 1.04 ± 0.06                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 24.7 ± 3.5 μs      | 25 ± 13 μs          | 0.986 ± 0.52               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.255 ± 0.027 ms   | 0.244 ± 0.029 ms    | 1.05 ± 0.17                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 24.8 ± 0.86 μs     | 25.4 ± 0.88 μs      | 0.979 ± 0.048              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 15.6 ± 0.25 μs     | 15.9 ± 0.2 μs       | 0.978 ± 0.02               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.225 ± 0.037 ms   | 0.202 ± 0.044 ms    | 1.11 ± 0.3                 |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.224 ± 0.02 ms    | 0.225 ± 0.023 ms    | 0.994 ± 0.13               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.0464 ± 0.018 ms  | 0.0454 ± 0.019 ms   | 1.02 ± 0.58                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.56 ± 0.063 ms    | 0.575 ± 0.064 ms    | 0.973 ± 0.15               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0419 ± 0.0019 ms | 0.0432 ± 0.0036 ms  | 0.97 ± 0.092               |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 13.3 ± 0.19 μs     | 13.1 ± 0.19 μs      | 1.01 ± 0.02                |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.177 ± 0.037 ms   | 0.167 ± 0.025 ms    | 1.06 ± 0.27                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0497 ± 0.0074 ms | 0.0454 ± 0.0053 ms  | 1.09 ± 0.21                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.0663 ± 0.025 ms  | 0.0637 ± 0.022 ms   | 1.04 ± 0.54                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 0.769 ± 0.11 ms    | 0.733 ± 0.092 ms    | 1.05 ± 0.2                 |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0488 ± 0.0019 ms | 0.0494 ± 0.0016 ms  | 0.989 ± 0.05               |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 18.9 ± 0.42 μs     | 18.8 ± 0.25 μs      | 1 ± 0.026                  |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.25 ± 0.031 ms    | 0.229 ± 0.041 ms    | 1.09 ± 0.24                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 0.997 ± 0.064 ms   | 0.994 ± 0.081 ms    | 1 ± 0.1                    |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0402 ± 0.0019 ms | 0.0403 ± 0.002 ms   | 0.997 ± 0.068              |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.14 ± 0.031 ms    | 0.139 ± 0.028 ms    | 1 ± 0.3                    |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 2.47 ± 0.37 ms     | 2.57 ± 0.45 ms      | 0.959 ± 0.22               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.05 ± 0.0064 ms   | 0.0472 ± 0.0021 ms  | 1.06 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 12 ± 0.23 μs       | 12.6 ± 0.22 μs      | 0.953 ± 0.024              |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.174 ± 0.022 ms   | 0.172 ± 0.022 ms    | 1.01 ± 0.18                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.0434 ± 0.0016 ms | 0.0432 ± 0.0017 ms  | 1.01 ± 0.054               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 3.46 ± 0.27 μs     | 3.46 ± 0.25 μs      | 1 ± 0.11                   |
| Evaluation/Matrix overview T200_L20_S3                                               | 24.9 ± 1.1 μs      | 24.7 ± 0.77 μs      | 1.01 ± 0.054               |
| Evaluation/Matrix renewal T200_L20_S1                                                | 6 ± 0.37 μs        | 8.71 ± 0.33 μs      | 0.69 ± 0.049               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.0333 ± 0.001 ms  | 0.0338 ± 0.0013 ms  | 0.984 ± 0.05               |
| time_to_load                                                                         | 0.168 ± 0.0015 s   | 0.174 ± 0.00027 s   | 0.969 ± 0.0087             |

|                                                                                      | v0.1.0                    | df1893fb8a6392...         | v0.1.0 / df1893fb8a6392... |
|:-------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.631 k allocs: 0.0348 MB | 0.631 k allocs: 0.0348 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 0.147 k allocs: 7.97 kB   | 0.147 k allocs: 7.61 kB   | 1.05                       |
| AD gradients/Convolution delay with history/ForwardDiff                              | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                         | 4.19 k allocs: 0.138 MB   | 4.19 k allocs: 0.138 MB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.69 k allocs: 22 kB      | 0.69 k allocs: 22 kB      | 1                          |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.982 k allocs: 0.0362 MB | 0.98 k allocs: 0.0361 MB  | 1.01                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 4.7 k allocs: 0.506 MB    | 4.7 k allocs: 0.506 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 0.122 k allocs: 12.5 kB   | 0.124 k allocs: 12.3 kB   | 1.02                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 0.0319 M allocs: 1.73 MB  | 0.0319 M allocs: 1.73 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.533 k allocs: 22 kB     | 0.533 k allocs: 22 kB     | 1                          |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 2  allocs: 1.48 kB        | 2  allocs: 1.48 kB        | 1                          |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 2 k allocs: 0.0762 MB     | 1.99 k allocs: 0.076 MB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 3.26 k allocs: 0.495 MB   | 3.25 k allocs: 0.494 MB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 9.4 k allocs: 0.381 MB    | 9.4 k allocs: 0.381 MB    | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 0.0393 MB | 1.01                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.874 k allocs: 0.0721 MB | 0.874 k allocs: 0.0721 MB | 1                          |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 1.53 k allocs: 0.294 MB   | 1.44 k allocs: 0.291 MB   | 1.01                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 5.84 k allocs: 0.353 MB   | 5.84 k allocs: 0.353 MB   | 1                          |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.18 k allocs: 0.0375 MB  | 0.18 k allocs: 0.0373 MB  | 1                          |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 2.31 k allocs: 0.0849 MB  | 2.31 k allocs: 0.0849 MB  | 1                          |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 1.53 k allocs: 0.308 MB   | 1.53 k allocs: 0.307 MB   | 1                          |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 9.06 k allocs: 0.369 MB   | 9.06 k allocs: 0.369 MB   | 1                          |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 3.28 k allocs: 0.496 MB   | 3.28 k allocs: 0.496 MB   | 1                          |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 9.43 k allocs: 0.382 MB   | 9.43 k allocs: 0.382 MB   | 1                          |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.166 k allocs: 0.0397 MB | 0.166 k allocs: 0.0394 MB | 1.01                       |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.9 k allocs: 0.073 MB    | 0.9 k allocs: 0.073 MB    | 1                          |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 1.53 k allocs: 0.294 MB   | 1.44 k allocs: 0.291 MB   | 1.01                       |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 5.84 k allocs: 0.353 MB   | 5.84 k allocs: 0.353 MB   | 1                          |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.185 k allocs: 0.0377 MB | 0.185 k allocs: 0.0375 MB | 1                          |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 2.33 k allocs: 0.086 MB   | 2.33 k allocs: 0.086 MB   | 1                          |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 1.55 k allocs: 0.309 MB   | 1.54 k allocs: 0.308 MB   | 1                          |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 9.1 k allocs: 0.371 MB    | 9.1 k allocs: 0.371 MB    | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.862 k allocs: 0.0431 MB | 0.862 k allocs: 0.0431 MB | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.181 k allocs: 7.84 kB   | 0.181 k allocs: 7.67 kB   | 1.02                       |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 0.072 k allocs: 14.3 kB   | 0.072 k allocs: 14.3 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 4.17 k allocs: 0.141 MB   | 4.17 k allocs: 0.141 MB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.818 k allocs: 26.2 kB   | 0.818 k allocs: 26.2 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 1.25 k allocs: 0.045 MB   | 1.25 k allocs: 0.0449 MB  | 1                          |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 3.15 k allocs: 0.279 MB   | 3.15 k allocs: 0.279 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.246 k allocs: 20 kB     | 0.242 k allocs: 19.5 kB   | 1.02                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.303 k allocs: 0.154 MB  | 0.303 k allocs: 0.154 MB  | 1                          |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 17.3 k allocs: 0.828 MB   | 17.3 k allocs: 0.828 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.68 k allocs: 25.9 kB    | 0.68 k allocs: 25.9 kB    | 1                          |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 2  allocs: 0.75 kB        | 2  allocs: 0.75 kB        | 1                          |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 5.91 k allocs: 0.223 MB   | 5.91 k allocs: 0.223 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 3.18 k allocs: 0.262 MB   | 3.18 k allocs: 0.262 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.233 k allocs: 17.1 kB   | 0.229 k allocs: 16.5 kB   | 1.04                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.29 k allocs: 0.13 MB    | 0.29 k allocs: 0.13 MB    | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 15.7 k allocs: 0.709 MB   | 15.7 k allocs: 0.709 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 1.14 k allocs: 0.0395 MB  | 1.14 k allocs: 0.0395 MB  | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 2  allocs: 0.562 kB       | 2  allocs: 0.562 kB       | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 3.55 k allocs: 0.128 MB   | 3.55 k allocs: 0.128 MB   | 1                          |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.836 k allocs: 0.0416 MB | 0.836 k allocs: 0.0416 MB | 1                          |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.176 k allocs: 7.66 kB   | 0.176 k allocs: 7.48 kB   | 1.02                       |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 0.07 k allocs: 14.2 kB    | 0.07 k allocs: 14.2 kB    | 1                          |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 4.09 k allocs: 0.137 MB   | 4.09 k allocs: 0.137 MB   | 1                          |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.8 k allocs: 25.3 kB     | 0.8 k allocs: 25.3 kB     | 1                          |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 1.25 k allocs: 0.045 MB   | 1.25 k allocs: 0.0449 MB  | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 1.5 k allocs: 0.132 MB    | 1.5 k allocs: 0.132 MB    | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 0.198 k allocs: 15.6 kB   | 0.194 k allocs: 15 kB     | 1.04                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.174 k allocs: 0.0836 MB | 0.174 k allocs: 0.0836 MB | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 5.38 k allocs: 0.321 MB   | 5.38 k allocs: 0.321 MB   | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.381 k allocs: 16 kB     | 0.381 k allocs: 16 kB     | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 2  allocs: 0.359 kB       | 2  allocs: 0.359 kB       | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 5.21 k allocs: 0.182 MB   | 5.21 k allocs: 0.182 MB   | 1                          |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 2.74 k allocs: 0.209 MB   | 2.74 k allocs: 0.209 MB   | 1                          |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.237 k allocs: 0.105 MB  | 0.237 k allocs: 0.105 MB  | 1                          |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 12.3 k allocs: 0.571 MB   | 12.3 k allocs: 0.571 MB   | 1                          |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 1.02 k allocs: 0.0351 MB  | 1.02 k allocs: 0.0351 MB  | 1                          |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 2  allocs: 0.516 kB       | 2  allocs: 0.516 kB       | 1                          |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 4.27 k allocs: 0.15 MB    | 4.27 k allocs: 0.15 MB    | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.362 k allocs: 23.6 kB   | 0.358 k allocs: 23.1 kB   | 1.02                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.338 k allocs: 0.149 MB  | 0.338 k allocs: 0.149 MB  | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 16.1 k allocs: 0.752 MB   | 16.1 k allocs: 0.752 MB   | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 1.17 k allocs: 0.0409 MB  | 1.17 k allocs: 0.0409 MB  | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 2  allocs: 0.562 kB       | 2  allocs: 0.562 kB       | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 5.52 k allocs: 0.199 MB   | 5.52 k allocs: 0.199 MB   | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 10.7 k allocs: 0.917 MB   | 10.7 k allocs: 0.917 MB   | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.383 k allocs: 25 kB     | 0.379 k allocs: 24.5 kB   | 1.02                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.886 k allocs: 0.384 MB  | 0.886 k allocs: 0.384 MB  | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 0.0515 M allocs: 2.58 MB  | 0.0515 M allocs: 2.58 MB  | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.854 k allocs: 0.0328 MB | 0.854 k allocs: 0.0328 MB | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 2  allocs: 1.8 kB         | 2  allocs: 1.8 kB         | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 3.87 k allocs: 0.146 MB   | 3.87 k allocs: 0.146 MB   | 1                          |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.091 k allocs: 0.0452 MB | 0.091 k allocs: 0.0452 MB | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                               | 0.052 k allocs: 0.0399 MB | 0.052 k allocs: 0.0399 MB | 1                          |
| Evaluation/Matrix renewal T200_L20_S1                                                | 0.034 k allocs: 7.98 kB   | 0.034 k allocs: 7.98 kB   | 1                          |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.072 k allocs: 0.0443 MB | 0.072 k allocs: 0.0443 MB | 1                          |
| time_to_load                                                                         | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

