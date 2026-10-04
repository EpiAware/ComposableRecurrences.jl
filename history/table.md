|                                                                                      | v0.1.0              | 964feeca531806...   | v0.1.0 / 964feeca531806... |
|:-------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0612 ± 0.0049 ms  | 0.0615 ± 0.0084 ms  | 0.995 ± 0.16               |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 30.1 ± 0.6 μs       | 29.1 ± 0.54 μs      | 1.03 ± 0.028               |
| AD gradients/Convolution delay with history/ForwardDiff                              | 9.16 ± 0.55 μs      | 8.93 ± 0.56 μs      | 1.03 ± 0.089               |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.235 ± 0.03 ms     | 0.234 ± 0.036 ms    | 1.01 ± 0.2                 |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0487 ± 0.0014 ms  | 0.0506 ± 0.0031 ms  | 0.964 ± 0.064              |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.74 ± 0.04 μs      | 5.75 ± 0.037 μs     | 0.998 ± 0.0094             |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0508 ± 0.00085 ms | 0.051 ± 0.0016 ms   | 0.997 ± 0.036              |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.625 ± 0.027 ms    | 0.63 ± 0.031 ms     | 0.992 ± 0.064              |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 29.3 ± 1.6 μs       | 29.1 ± 1.7 μs       | 1.01 ± 0.079               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0779 ± 0.11 ms    | 0.0769 ± 0.026 ms   | 1.01 ± 1.5                 |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.99 ± 0.17 ms      | 1.9 ± 0.2 ms        | 1.05 ± 0.14                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0549 ± 0.0014 ms  | 0.0561 ± 0.0019 ms  | 0.98 ± 0.042               |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 12.6 ± 0.15 μs      | 11 ± 1.4 μs         | 1.14 ± 0.15                |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.116 ± 0.018 ms    | 0.129 ± 0.022 ms    | 0.893 ± 0.21               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 1.25 ± 0.24 ms      | 1.27 ± 0.041 ms     | 0.989 ± 0.19               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 1.31 ± 0.13 ms      | 1.24 ± 0.12 ms      | 1.06 ± 0.14                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.0645 ± 0.0055 ms  | 0.0621 ± 0.0048 ms  | 1.04 ± 0.12                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.109 ± 0.0051 ms   | 0.115 ± 0.0064 ms   | 0.944 ± 0.069              |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 0.588 ± 0.12 ms     | 0.618 ± 0.068 ms    | 0.951 ± 0.22               |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 0.625 ± 0.073 ms    | 0.624 ± 0.05 ms     | 1 ± 0.14                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.101 ± 0.0046 ms   | 0.0989 ± 0.0049 ms  | 1.03 ± 0.069               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 0.146 ± 0.025 ms    | 0.153 ± 0.032 ms    | 0.953 ± 0.26               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 0.787 ± 0.13 ms     | 0.825 ± 0.028 ms    | 0.954 ± 0.16               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 0.947 ± 0.12 ms     | 0.862 ± 0.12 ms     | 1.1 ± 0.21                 |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 1.19 ± 0.069 ms     | 1.27 ± 0.041 ms     | 0.936 ± 0.062              |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 1.3 ± 0.12 ms       | 1.23 ± 0.13 ms      | 1.05 ± 0.14                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.0668 ± 0.0056 ms  | 0.0638 ± 0.0048 ms  | 1.05 ± 0.12                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.115 ± 0.0052 ms   | 0.12 ± 0.0065 ms    | 0.961 ± 0.068              |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 0.579 ± 0.038 ms    | 0.618 ± 0.072 ms    | 0.937 ± 0.13               |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 0.625 ± 0.077 ms    | 0.618 ± 0.044 ms    | 1.01 ± 0.14                |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.104 ± 0.0048 ms   | 0.102 ± 0.005 ms    | 1.02 ± 0.069               |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 0.151 ± 0.026 ms    | 0.161 ± 0.031 ms    | 0.941 ± 0.24               |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 0.849 ± 0.13 ms     | 0.83 ± 0.04 ms      | 1.02 ± 0.16                |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 0.96 ± 0.12 ms      | 0.875 ± 0.12 ms     | 1.1 ± 0.21                 |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0725 ± 0.0025 ms  | 0.0739 ± 0.011 ms   | 0.98 ± 0.15                |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0375 ± 0.0007 ms  | 0.0368 ± 0.00071 ms | 1.02 ± 0.027               |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13.6 ± 1.4 μs       | 13.4 ± 1.2 μs       | 1.01 ± 0.14                |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.243 ± 0.042 ms    | 0.239 ± 0.043 ms    | 1.01 ± 0.25                |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0593 ± 0.0014 ms  | 0.0613 ± 0.0029 ms  | 0.968 ± 0.051              |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.07 ± 0.08 μs      | 7.73 ± 0.16 μs      | 0.915 ± 0.022              |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0644 ± 0.0015 ms  | 0.0664 ± 0.0029 ms  | 0.97 ± 0.047               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.416 ± 0.02 ms     | 0.425 ± 0.023 ms    | 0.979 ± 0.072              |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0576 ± 0.0025 ms  | 0.055 ± 0.002 ms    | 1.05 ± 0.06                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0607 ± 0.0066 ms  | 0.0625 ± 0.015 ms   | 0.97 ± 0.25                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.25 ± 0.068 ms     | 1.24 ± 0.1 ms       | 1.01 ± 0.1                 |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0847 ± 0.0026 ms  | 0.0856 ± 0.0024 ms  | 0.99 ± 0.041               |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0364 ± 0.0012 ms  | 0.0353 ± 0.00023 ms | 1.03 ± 0.033               |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.441 ± 0.09 ms     | 0.421 ± 0.077 ms    | 1.05 ± 0.29                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.378 ± 0.033 ms    | 0.376 ± 0.033 ms    | 1 ± 0.12                   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0529 ± 0.0015 ms  | 0.051 ± 0.0018 ms   | 1.04 ± 0.046               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0748 ± 0.017 ms   | 0.0738 ± 0.012 ms   | 1.01 ± 0.28                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.24 ± 0.13 ms      | 1.24 ± 0.22 ms      | 1 ± 0.21                   |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0887 ± 0.0039 ms  | 0.0899 ± 0.0039 ms  | 0.987 ± 0.061              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 21.2 ± 0.33 μs      | 21.1 ± 1 μs         | 1.01 ± 0.051               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.22 ± 0.056 ms     | 0.221 ± 0.042 ms    | 0.997 ± 0.32               |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0703 ± 0.0022 ms  | 0.0714 ± 0.013 ms   | 0.985 ± 0.18               |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0361 ± 0.00065 ms | 0.0357 ± 0.00069 ms | 1.01 ± 0.027               |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 13.1 ± 1.4 μs       | 13.1 ± 1.2 μs       | 0.998 ± 0.14               |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.233 ± 0.041 ms    | 0.233 ± 0.039 ms    | 0.998 ± 0.24               |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0579 ± 0.0014 ms  | 0.0608 ± 0.0033 ms  | 0.952 ± 0.056              |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.36 ± 0.075 μs     | 7.85 ± 0.19 μs      | 0.937 ± 0.025              |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0642 ± 0.0015 ms  | 0.0665 ± 0.0029 ms  | 0.966 ± 0.048              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.14 ± 0.0095 ms    | 0.141 ± 0.014 ms    | 0.993 ± 0.12               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 27.1 ± 0.92 μs      | 25.9 ± 0.93 μs      | 1.05 ± 0.052               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 28 ± 4.3 μs         | 28.7 ± 4.6 μs       | 0.976 ± 0.22               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.405 ± 0.027 ms    | 0.397 ± 0.035 ms    | 1.02 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0507 ± 0.0012 ms  | 0.0515 ± 0.0014 ms  | 0.983 ± 0.036              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 0.0321 ± 0.00025 ms | 29.9 ± 0.25 μs      | 1.07 ± 0.012               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.351 ± 0.069 ms    | 0.323 ± 0.07 ms     | 1.09 ± 0.32                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.312 ± 0.025 ms    | 0.311 ± 0.023 ms    | 1 ± 0.11                   |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.0414 ± 0.026 ms   | 0.0655 ± 0.036 ms   | 0.632 ± 0.53               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.948 ± 0.1 ms      | 0.934 ± 0.076 ms    | 1.02 ± 0.14                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0846 ± 0.0036 ms  | 0.0867 ± 0.0028 ms  | 0.975 ± 0.052              |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 25.8 ± 0.28 μs      | 23.8 ± 0.6 μs       | 1.08 ± 0.03                |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.262 ± 0.059 ms    | 0.262 ± 0.058 ms    | 0.999 ± 0.31               |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.077 ± 0.0024 ms   | 0.0729 ± 0.0036 ms  | 1.06 ± 0.061               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.0796 ± 0.045 ms   | 0.0777 ± 0.012 ms   | 1.02 ± 0.6                 |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.26 ± 0.13 ms      | 1.25 ± 0.14 ms      | 1.01 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.098 ± 0.0028 ms   | 0.101 ± 0.0035 ms   | 0.975 ± 0.044              |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0372 ± 0.0003 ms  | 0.0356 ± 0.0017 ms  | 1.04 ± 0.051               |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.39 ± 0.07 ms      | 0.358 ± 0.07 ms     | 1.09 ± 0.29                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.21 ± 0.13 ms      | 1.23 ± 0.12 ms      | 0.991 ± 0.14               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0606 ± 0.0035 ms  | 0.0583 ± 0.0034 ms  | 1.04 ± 0.086               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.152 ± 0.04 ms     | 0.138 ± 0.04 ms     | 1.11 ± 0.43                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 4.12 ± 0.39 ms      | 4.05 ± 0.43 ms      | 1.02 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.092 ± 0.0024 ms   | 0.094 ± 0.003 ms    | 0.979 ± 0.04               |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 24.2 ± 0.22 μs      | 24.2 ± 0.23 μs      | 1 ± 0.013                  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.268 ± 0.051 ms    | 0.272 ± 0.055 ms    | 0.987 ± 0.28               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.072 ± 0.0012 ms   | 0.0739 ± 0.0013 ms  | 0.975 ± 0.023              |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 4.93 ± 0.41 μs      | 4.86 ± 0.4 μs       | 1.02 ± 0.12                |
| Evaluation/Matrix overview T200_L20_S3                                               | 0.0394 ± 0.00086 ms | 0.0401 ± 0.00074 ms | 0.982 ± 0.028              |
| Evaluation/Matrix renewal T200_L20_S1                                                | 9.68 ± 0.72 μs      | 9.61 ± 0.65 μs      | 1.01 ± 0.1                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.0488 ± 0.00087 ms | 0.0488 ± 0.00084 ms | 1 ± 0.025                  |
| time_to_load                                                                         | 0.235 ± 0.0016 s    | 0.234 ± 7.4e-05 s   | 1.01 ± 0.007               |

|                                                                                      | v0.1.0                    | 964feeca531806...         | v0.1.0 / 964feeca531806... |
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
| time_to_load                                                                         | 0.204 k allocs: 11.9 kB   | 0.2 k allocs: 11.8 kB     | 1.02                       |

