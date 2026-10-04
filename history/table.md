|                                                                                      | v0.1.0              | f4fa9cfd359ca6...   | v0.1.0 / f4fa9cfd359ca6... |
|:-------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0614 ± 0.0043 ms  | 0.0611 ± 0.0072 ms  | 1.01 ± 0.14                |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 30 ± 0.64 μs        | 29.8 ± 0.52 μs      | 1.01 ± 0.028               |
| AD gradients/Convolution delay with history/ForwardDiff                              | 8.8 ± 0.54 μs       | 9.01 ± 0.53 μs      | 0.977 ± 0.083              |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.236 ± 0.036 ms    | 0.234 ± 0.028 ms    | 1.01 ± 0.2                 |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0501 ± 0.0024 ms  | 0.0492 ± 0.0014 ms  | 1.02 ± 0.056               |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.58 ± 0.05 μs      | 5.73 ± 0.042 μs     | 0.974 ± 0.011              |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0519 ± 0.0025 ms  | 0.0511 ± 0.0028 ms  | 1.02 ± 0.073               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.617 ± 0.031 ms    | 0.619 ± 0.03 ms     | 0.997 ± 0.069              |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 29.4 ± 2.3 μs       | 29.6 ± 2.5 μs       | 0.993 ± 0.11               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0773 ± 0.0087 ms  | 0.0756 ± 0.0049 ms  | 1.02 ± 0.13                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 2.01 ± 0.19 ms      | 1.97 ± 0.2 ms       | 1.02 ± 0.14                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0545 ± 0.002 ms   | 0.054 ± 0.0016 ms   | 1.01 ± 0.048               |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 11.5 ± 1.5 μs       | 12.7 ± 0.13 μs      | 0.906 ± 0.12               |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.116 ± 0.018 ms    | 0.114 ± 0.022 ms    | 1.02 ± 0.25                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 1.19 ± 0.05 ms      | 1.09 ± 0.046 ms     | 1.1 ± 0.066                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 1.22 ± 0.12 ms      | 1.22 ± 0.13 ms      | 0.999 ± 0.14               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.0639 ± 0.0055 ms  | 0.0621 ± 0.0054 ms  | 1.03 ± 0.13                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.11 ± 0.0061 ms    | 0.111 ± 0.0056 ms   | 0.993 ± 0.074              |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 0.579 ± 0.024 ms    | 0.487 ± 0.047 ms    | 1.19 ± 0.12                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 0.603 ± 0.057 ms    | 0.608 ± 0.049 ms    | 0.993 ± 0.12               |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.0995 ± 0.0047 ms  | 0.1 ± 0.0047 ms     | 0.992 ± 0.066              |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 0.151 ± 0.028 ms    | 0.15 ± 0.032 ms     | 1.01 ± 0.28                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 0.814 ± 0.062 ms    | 0.767 ± 0.029 ms    | 1.06 ± 0.09                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 0.854 ± 0.12 ms     | 0.843 ± 0.12 ms     | 1.01 ± 0.21                |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 1.21 ± 0.065 ms     | 1.06 ± 0.027 ms     | 1.13 ± 0.068               |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 1.24 ± 0.13 ms      | 1.23 ± 0.13 ms      | 1 ± 0.15                   |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.0659 ± 0.0055 ms  | 0.0643 ± 0.0054 ms  | 1.02 ± 0.12                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.114 ± 0.0053 ms   | 0.117 ± 0.0056 ms   | 0.979 ± 0.065              |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 0.586 ± 0.026 ms    | 0.49 ± 0.051 ms     | 1.2 ± 0.13                 |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 0.606 ± 0.069 ms    | 0.605 ± 0.048 ms    | 1 ± 0.14                   |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.103 ± 0.005 ms    | 0.102 ± 0.0049 ms   | 1.01 ± 0.069               |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 0.156 ± 0.03 ms     | 0.156 ± 0.032 ms    | 1 ± 0.28                   |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 0.809 ± 0.055 ms    | 0.734 ± 0.044 ms    | 1.1 ± 0.1                  |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 0.857 ± 0.12 ms     | 0.853 ± 0.12 ms     | 1 ± 0.2                    |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0734 ± 0.0046 ms  | 0.072 ± 0.0043 ms   | 1.02 ± 0.088               |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0372 ± 0.00071 ms | 0.0379 ± 0.00074 ms | 0.981 ± 0.027              |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13.4 ± 1.2 μs       | 13.7 ± 1.2 μs       | 0.982 ± 0.13               |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.242 ± 0.044 ms    | 0.243 ± 0.043 ms    | 0.996 ± 0.25               |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0608 ± 0.0031 ms  | 0.0604 ± 0.0028 ms  | 1.01 ± 0.069               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.28 ± 0.07 μs      | 7.13 ± 0.19 μs      | 1.02 ± 0.029               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0655 ± 0.0033 ms  | 0.0661 ± 0.0031 ms  | 0.991 ± 0.067              |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.416 ± 0.025 ms    | 0.416 ± 0.023 ms    | 1 ± 0.082                  |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0573 ± 0.0033 ms  | 0.0559 ± 0.0013 ms  | 1.03 ± 0.063               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0601 ± 0.013 ms   | 0.0596 ± 0.015 ms   | 1.01 ± 0.34                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.23 ± 0.13 ms      | 1.25 ± 0.13 ms      | 0.989 ± 0.15               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0858 ± 0.0027 ms  | 0.0856 ± 0.0023 ms  | 1 ± 0.042                  |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0347 ± 0.0036 ms  | 0.036 ± 0.00036 ms  | 0.964 ± 0.1                |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.413 ± 0.083 ms    | 0.417 ± 0.078 ms    | 0.99 ± 0.27                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.362 ± 0.032 ms    | 0.367 ± 0.046 ms    | 0.984 ± 0.15               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0526 ± 0.0014 ms  | 0.0523 ± 0.0018 ms  | 1 ± 0.044                  |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0712 ± 0.012 ms   | 0.073 ± 0.014 ms    | 0.976 ± 0.25               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.27 ± 0.092 ms     | 1.25 ± 0.092 ms     | 1.02 ± 0.1                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0889 ± 0.0028 ms  | 0.0904 ± 0.004 ms   | 0.983 ± 0.053              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 20.5 ± 0.18 μs      | 20.6 ± 1.1 μs       | 0.994 ± 0.051              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.221 ± 0.051 ms    | 0.223 ± 0.051 ms    | 0.988 ± 0.32               |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0703 ± 0.0017 ms  | 0.0701 ± 0.0049 ms  | 1 ± 0.073                  |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0359 ± 0.00065 ms | 0.0357 ± 0.00067 ms | 1.01 ± 0.026               |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 13 ± 1.2 μs         | 13.3 ± 1.2 μs       | 0.974 ± 0.13               |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.241 ± 0.044 ms    | 0.24 ± 0.043 ms     | 1 ± 0.26                   |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0586 ± 0.0019 ms  | 0.0599 ± 0.0029 ms  | 0.978 ± 0.057              |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.48 ± 0.17 μs      | 7.43 ± 0.083 μs     | 1.01 ± 0.026               |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0646 ± 0.0023 ms  | 0.0647 ± 0.0015 ms  | 0.998 ± 0.042              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.139 ± 0.011 ms    | 0.141 ± 0.014 ms    | 0.985 ± 0.13               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 26.9 ± 0.88 μs      | 26.8 ± 0.81 μs      | 1 ± 0.045                  |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 27.5 ± 7.7 μs       | 27 ± 8 μs           | 1.02 ± 0.42                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.386 ± 0.035 ms    | 0.392 ± 0.033 ms    | 0.985 ± 0.12               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0508 ± 0.0013 ms  | 0.051 ± 0.0012 ms   | 0.996 ± 0.035              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 29.3 ± 2.7 μs       | 31.5 ± 0.25 μs      | 0.932 ± 0.086              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.316 ± 0.074 ms    | 0.322 ± 0.075 ms    | 0.98 ± 0.32                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.298 ± 0.023 ms    | 0.302 ± 0.022 ms    | 0.987 ± 0.11               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.039 ± 0.011 ms    | 0.0394 ± 0.011 ms   | 0.99 ± 0.38                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.943 ± 0.067 ms    | 0.943 ± 0.057 ms    | 0.999 ± 0.093              |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0841 ± 0.0025 ms  | 0.0842 ± 0.0029 ms  | 0.998 ± 0.046              |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 22.9 ± 0.28 μs      | 23.4 ± 0.25 μs      | 0.981 ± 0.016              |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.262 ± 0.06 ms     | 0.266 ± 0.06 ms     | 0.985 ± 0.32               |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.077 ± 0.0037 ms   | 0.0709 ± 0.0016 ms  | 1.09 ± 0.059               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.0756 ± 0.013 ms   | 0.0787 ± 0.014 ms   | 0.959 ± 0.23               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.26 ± 0.08 ms      | 1.28 ± 0.084 ms     | 0.99 ± 0.09                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0995 ± 0.0062 ms  | 0.101 ± 0.005 ms    | 0.987 ± 0.079              |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0351 ± 0.00069 ms | 0.0363 ± 0.0037 ms  | 0.968 ± 0.1                |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.336 ± 0.079 ms    | 0.35 ± 0.079 ms     | 0.959 ± 0.31               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.2 ± 0.13 ms       | 1.21 ± 0.17 ms      | 0.992 ± 0.18               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0596 ± 0.0035 ms  | 0.0599 ± 0.0046 ms  | 0.995 ± 0.096              |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.137 ± 0.031 ms    | 0.134 ± 0.036 ms    | 1.02 ± 0.36                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 3.97 ± 0.41 ms      | 3.96 ± 0.46 ms      | 1 ± 0.16                   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0932 ± 0.0028 ms  | 0.094 ± 0.0029 ms   | 0.992 ± 0.042              |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 24.8 ± 0.23 μs      | 22.2 ± 0.23 μs      | 1.12 ± 0.016               |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.272 ± 0.052 ms    | 0.272 ± 0.054 ms    | 0.999 ± 0.28               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.0718 ± 0.0013 ms  | 0.0708 ± 0.0012 ms  | 1.01 ± 0.025               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 4.93 ± 0.39 μs      | 4.95 ± 0.41 μs      | 0.996 ± 0.11               |
| Evaluation/Matrix overview T200_L20_S3                                               | 0.0397 ± 0.00092 ms | 0.0391 ± 0.00066 ms | 1.02 ± 0.029               |
| Evaluation/Matrix renewal T200_L20_S1                                                | 9.74 ± 0.72 μs      | 9.75 ± 0.69 μs      | 0.999 ± 0.1                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.0485 ± 0.00087 ms | 0.0485 ± 0.0008 ms  | 1 ± 0.024                  |
| time_to_load                                                                         | 0.234 ± 0.0018 s    | 0.234 ± 0.0017 s    | 1 ± 0.011                  |

|                                                                                      | v0.1.0                    | f4fa9cfd359ca6...         | v0.1.0 / f4fa9cfd359ca6... |
|:-------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.631 k allocs: 0.0348 MB | 0.631 k allocs: 0.0348 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 0.147 k allocs: 7.97 kB   | 0.147 k allocs: 7.97 kB   | 1                          |
| AD gradients/Convolution delay with history/ForwardDiff                              | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                         | 4.19 k allocs: 0.138 MB   | 4.19 k allocs: 0.138 MB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.69 k allocs: 22 kB      | 0.69 k allocs: 22 kB      | 1                          |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.982 k allocs: 0.0362 MB | 0.982 k allocs: 0.0362 MB | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 4.7 k allocs: 0.506 MB    | 4.7 k allocs: 0.506 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 0.122 k allocs: 12.5 kB   | 0.122 k allocs: 12.5 kB   | 1                          |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 0.0319 M allocs: 1.73 MB  | 0.0319 M allocs: 1.73 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.533 k allocs: 22 kB     | 0.533 k allocs: 22 kB     | 1                          |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 2  allocs: 1.48 kB        | 2  allocs: 1.48 kB        | 1                          |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 2 k allocs: 0.0762 MB     | 2 k allocs: 0.0762 MB     | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 3.26 k allocs: 0.495 MB   | 3.26 k allocs: 0.495 MB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 9.4 k allocs: 0.381 MB    | 9.4 k allocs: 0.381 MB    | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 0.0396 MB | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.874 k allocs: 0.0721 MB | 0.874 k allocs: 0.0721 MB | 1                          |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 1.53 k allocs: 0.294 MB   | 1.53 k allocs: 0.294 MB   | 1                          |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 5.84 k allocs: 0.353 MB   | 5.84 k allocs: 0.353 MB   | 1                          |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.18 k allocs: 0.0375 MB  | 0.18 k allocs: 0.0375 MB  | 1                          |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 2.31 k allocs: 0.0849 MB  | 2.31 k allocs: 0.0849 MB  | 1                          |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 1.53 k allocs: 0.308 MB   | 1.53 k allocs: 0.308 MB   | 1                          |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 9.06 k allocs: 0.369 MB   | 9.06 k allocs: 0.369 MB   | 1                          |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 3.28 k allocs: 0.496 MB   | 3.28 k allocs: 0.496 MB   | 1                          |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 9.43 k allocs: 0.382 MB   | 9.43 k allocs: 0.382 MB   | 1                          |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.166 k allocs: 0.0397 MB | 0.166 k allocs: 0.0397 MB | 1                          |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.9 k allocs: 0.073 MB    | 0.9 k allocs: 0.073 MB    | 1                          |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 1.53 k allocs: 0.294 MB   | 1.53 k allocs: 0.294 MB   | 1                          |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 5.84 k allocs: 0.353 MB   | 5.84 k allocs: 0.353 MB   | 1                          |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.185 k allocs: 0.0377 MB | 0.185 k allocs: 0.0377 MB | 1                          |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 2.33 k allocs: 0.086 MB   | 2.33 k allocs: 0.086 MB   | 1                          |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 1.55 k allocs: 0.309 MB   | 1.55 k allocs: 0.309 MB   | 1                          |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 9.1 k allocs: 0.371 MB    | 9.1 k allocs: 0.371 MB    | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.862 k allocs: 0.0431 MB | 0.862 k allocs: 0.0431 MB | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.181 k allocs: 7.84 kB   | 0.181 k allocs: 7.84 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 0.072 k allocs: 14.3 kB   | 0.072 k allocs: 14.3 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 4.17 k allocs: 0.141 MB   | 4.17 k allocs: 0.141 MB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.818 k allocs: 26.2 kB   | 0.818 k allocs: 26.2 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 1.25 k allocs: 0.045 MB   | 1.25 k allocs: 0.045 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 3.15 k allocs: 0.279 MB   | 3.15 k allocs: 0.279 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.246 k allocs: 20 kB     | 0.246 k allocs: 20 kB     | 1                          |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.303 k allocs: 0.154 MB  | 0.303 k allocs: 0.154 MB  | 1                          |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 17.3 k allocs: 0.828 MB   | 17.3 k allocs: 0.828 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.68 k allocs: 25.9 kB    | 0.68 k allocs: 25.9 kB    | 1                          |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 2  allocs: 0.75 kB        | 2  allocs: 0.75 kB        | 1                          |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 5.91 k allocs: 0.223 MB   | 5.91 k allocs: 0.223 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 3.18 k allocs: 0.262 MB   | 3.18 k allocs: 0.262 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.233 k allocs: 17.1 kB   | 0.233 k allocs: 17.1 kB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.29 k allocs: 0.13 MB    | 0.29 k allocs: 0.13 MB    | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 15.7 k allocs: 0.709 MB   | 15.7 k allocs: 0.709 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 1.14 k allocs: 0.0395 MB  | 1.14 k allocs: 0.0395 MB  | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 2  allocs: 0.562 kB       | 2  allocs: 0.562 kB       | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 3.55 k allocs: 0.128 MB   | 3.55 k allocs: 0.128 MB   | 1                          |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.836 k allocs: 0.0416 MB | 0.836 k allocs: 0.0416 MB | 1                          |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.176 k allocs: 7.66 kB   | 0.176 k allocs: 7.66 kB   | 1                          |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 0.07 k allocs: 14.2 kB    | 0.07 k allocs: 14.2 kB    | 1                          |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 4.09 k allocs: 0.137 MB   | 4.09 k allocs: 0.137 MB   | 1                          |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.8 k allocs: 25.3 kB     | 0.8 k allocs: 25.3 kB     | 1                          |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 1.25 k allocs: 0.045 MB   | 1.25 k allocs: 0.045 MB   | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 1.5 k allocs: 0.132 MB    | 1.5 k allocs: 0.132 MB    | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 0.198 k allocs: 15.6 kB   | 0.198 k allocs: 15.6 kB   | 1                          |
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
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.362 k allocs: 23.6 kB   | 0.362 k allocs: 23.6 kB   | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.338 k allocs: 0.149 MB  | 0.338 k allocs: 0.149 MB  | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 16.1 k allocs: 0.752 MB   | 16.1 k allocs: 0.752 MB   | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 1.17 k allocs: 0.0409 MB  | 1.17 k allocs: 0.0409 MB  | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 2  allocs: 0.562 kB       | 2  allocs: 0.562 kB       | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 5.52 k allocs: 0.199 MB   | 5.52 k allocs: 0.199 MB   | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 10.7 k allocs: 0.917 MB   | 10.7 k allocs: 0.917 MB   | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.383 k allocs: 25 kB     | 0.383 k allocs: 25 kB     | 1                          |
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

