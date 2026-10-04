|                                                                                      | v0.1.0              | dc3cba5fa4dbda...   | v0.1.0 / dc3cba5fa4dbda... |
|:-------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0611 ± 0.0044 ms  | 0.0615 ± 0.0083 ms  | 0.993 ± 0.15               |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 29.9 ± 0.63 μs      | 29.2 ± 0.58 μs      | 1.03 ± 0.03                |
| AD gradients/Convolution delay with history/ForwardDiff                              | 9.13 ± 0.57 μs      | 8.83 ± 0.56 μs      | 1.03 ± 0.092               |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.241 ± 0.027 ms    | 0.232 ± 0.039 ms    | 1.04 ± 0.21                |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0514 ± 0.0018 ms  | 0.05 ± 0.003 ms     | 1.03 ± 0.072               |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.61 ± 0.049 μs     | 5.62 ± 0.045 μs     | 0.998 ± 0.012              |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0524 ± 0.0012 ms  | 0.0516 ± 0.0015 ms  | 1.01 ± 0.038               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.626 ± 0.025 ms    | 0.626 ± 0.03 ms     | 1 ± 0.063                  |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 29.5 ± 2 μs         | 29.2 ± 2.4 μs       | 1.01 ± 0.11                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0769 ± 0.11 ms    | 0.0774 ± 0.014 ms   | 0.994 ± 1.4                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.98 ± 0.18 ms      | 1.97 ± 0.19 ms      | 1.01 ± 0.14                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.055 ± 0.0017 ms   | 0.0546 ± 0.0021 ms  | 1.01 ± 0.049               |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 12.8 ± 0.17 μs      | 11.4 ± 1.2 μs       | 1.12 ± 0.12                |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.114 ± 0.019 ms    | 0.128 ± 0.02 ms     | 0.894 ± 0.2                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 1.43 ± 0.28 ms      | 1.28 ± 0.088 ms     | 1.11 ± 0.23                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 1.32 ± 0.13 ms      | 1.23 ± 0.12 ms      | 1.07 ± 0.15                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.0636 ± 0.0055 ms  | 0.062 ± 0.0048 ms   | 1.03 ± 0.12                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.112 ± 0.0057 ms   | 0.113 ± 0.0064 ms   | 0.997 ± 0.076              |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 0.659 ± 0.13 ms     | 0.566 ± 0.04 ms     | 1.16 ± 0.24                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 0.62 ± 0.076 ms     | 0.62 ± 0.051 ms     | 1 ± 0.15                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.101 ± 0.0048 ms   | 0.0985 ± 0.0049 ms  | 1.02 ± 0.071               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 0.151 ± 0.027 ms    | 0.152 ± 0.029 ms    | 0.994 ± 0.26               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 0.864 ± 0.19 ms     | 0.827 ± 0.099 ms    | 1.04 ± 0.26                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 0.966 ± 0.12 ms     | 0.87 ± 0.12 ms      | 1.11 ± 0.21                |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 1.46 ± 0.25 ms      | 1.28 ± 0.088 ms     | 1.15 ± 0.21                |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 1.31 ± 0.12 ms      | 1.23 ± 0.12 ms      | 1.06 ± 0.14                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.0662 ± 0.0057 ms  | 0.0645 ± 0.0049 ms  | 1.03 ± 0.12                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.118 ± 0.0063 ms   | 0.119 ± 0.0063 ms   | 0.994 ± 0.075              |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 0.644 ± 0.049 ms    | 0.568 ± 0.039 ms    | 1.13 ± 0.12                |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 0.614 ± 0.083 ms    | 0.619 ± 0.052 ms    | 0.991 ± 0.16               |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.103 ± 0.005 ms    | 0.102 ± 0.0056 ms   | 1.02 ± 0.074               |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 0.155 ± 0.029 ms    | 0.16 ± 0.03 ms      | 0.969 ± 0.26               |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 0.878 ± 0.08 ms     | 0.814 ± 0.066 ms    | 1.08 ± 0.13                |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 0.969 ± 0.13 ms     | 0.872 ± 0.12 ms     | 1.11 ± 0.22                |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0724 ± 0.0021 ms  | 0.0736 ± 0.011 ms   | 0.983 ± 0.14               |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.0375 ± 0.00066 ms | 0.0366 ± 0.00072 ms | 1.02 ± 0.027               |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13.8 ± 1.4 μs       | 13.5 ± 1.3 μs       | 1.02 ± 0.14                |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.246 ± 0.044 ms    | 0.234 ± 0.044 ms    | 1.05 ± 0.27                |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0613 ± 0.002 ms   | 0.0611 ± 0.003 ms   | 1 ± 0.06                   |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.18 ± 0.11 μs      | 7.07 ± 0.062 μs     | 1.02 ± 0.017               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.0657 ± 0.0023 ms  | 0.0658 ± 0.003 ms   | 0.999 ± 0.058              |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.42 ± 0.024 ms     | 0.424 ± 0.024 ms    | 0.992 ± 0.079              |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0566 ± 0.003 ms   | 0.0552 ± 0.0018 ms  | 1.03 ± 0.063               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0608 ± 0.0072 ms  | 0.0601 ± 0.014 ms   | 1.01 ± 0.27                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.24 ± 0.076 ms     | 1.23 ± 0.097 ms     | 1.01 ± 0.1                 |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0857 ± 0.0024 ms  | 0.0833 ± 0.0028 ms  | 1.03 ± 0.045               |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0347 ± 0.00067 ms | 0.0376 ± 0.0033 ms  | 0.922 ± 0.082              |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.434 ± 0.086 ms    | 0.423 ± 0.079 ms    | 1.03 ± 0.28                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.381 ± 0.036 ms    | 0.377 ± 0.034 ms    | 1.01 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0521 ± 0.0016 ms  | 0.0511 ± 0.0019 ms  | 1.02 ± 0.049               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0822 ± 0.01 ms    | 0.0731 ± 0.013 ms   | 1.12 ± 0.25                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.26 ± 0.16 ms      | 1.22 ± 0.24 ms      | 1.03 ± 0.24                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0907 ± 0.0037 ms  | 0.0886 ± 0.0038 ms  | 1.02 ± 0.061               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 20.2 ± 0.92 μs      | 20.8 ± 0.25 μs      | 0.973 ± 0.046              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.221 ± 0.051 ms    | 0.224 ± 0.044 ms    | 0.984 ± 0.3                |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0699 ± 0.002 ms   | 0.0705 ± 0.012 ms   | 0.992 ± 0.17               |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0361 ± 0.00075 ms | 0.0355 ± 0.00076 ms | 1.01 ± 0.03                |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 13.4 ± 1.5 μs       | 13.3 ± 1.3 μs       | 1.01 ± 0.15                |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.238 ± 0.043 ms    | 0.228 ± 0.043 ms    | 1.04 ± 0.27                |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0603 ± 0.0018 ms  | 0.0591 ± 0.0034 ms  | 1.02 ± 0.065               |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.39 ± 0.11 μs      | 7.31 ± 0.07 μs      | 1.01 ± 0.018               |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0649 ± 0.0021 ms  | 0.0651 ± 0.0031 ms  | 0.996 ± 0.057              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.141 ± 0.0093 ms   | 0.142 ± 0.015 ms    | 0.992 ± 0.12               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 26.7 ± 0.82 μs      | 26.3 ± 0.98 μs      | 1.02 ± 0.049               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 28 ± 5.4 μs         | 27.2 ± 4.8 μs       | 1.03 ± 0.27                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.404 ± 0.029 ms    | 0.393 ± 0.034 ms    | 1.03 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0525 ± 0.0017 ms  | 0.0505 ± 0.0015 ms  | 1.04 ± 0.045               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 0.0317 ± 0.00023 ms | 0.0319 ± 0.0027 ms  | 0.994 ± 0.086              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.34 ± 0.068 ms     | 0.319 ± 0.071 ms    | 1.07 ± 0.32                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.313 ± 0.024 ms    | 0.309 ± 0.024 ms    | 1.01 ± 0.11                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.0409 ± 0.028 ms   | 0.0653 ± 0.039 ms   | 0.626 ± 0.57               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.937 ± 0.1 ms      | 0.938 ± 0.076 ms    | 0.999 ± 0.14               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.086 ± 0.003 ms    | 0.085 ± 0.0043 ms   | 1.01 ± 0.062               |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 23 ± 1.5 μs         | 25.3 ± 2 μs         | 0.912 ± 0.094              |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.263 ± 0.062 ms    | 0.262 ± 0.061 ms    | 1 ± 0.33                   |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0753 ± 0.0046 ms  | 0.0732 ± 0.0032 ms  | 1.03 ± 0.077               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.0789 ± 0.043 ms   | 0.0782 ± 0.013 ms   | 1.01 ± 0.58                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.31 ± 0.12 ms      | 1.25 ± 0.12 ms      | 1.05 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.101 ± 0.0041 ms   | 0.0996 ± 0.0049 ms  | 1.01 ± 0.065               |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0355 ± 0.0028 ms  | 0.0365 ± 0.0014 ms  | 0.97 ± 0.086               |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.393 ± 0.067 ms    | 0.356 ± 0.071 ms    | 1.1 ± 0.29                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.22 ± 0.12 ms      | 1.22 ± 0.14 ms      | 1 ± 0.15                   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0601 ± 0.0029 ms  | 0.0585 ± 0.0037 ms  | 1.03 ± 0.081               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.153 ± 0.042 ms    | 0.131 ± 0.038 ms    | 1.16 ± 0.46                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 4.02 ± 0.35 ms      | 3.92 ± 0.44 ms      | 1.02 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0942 ± 0.0032 ms  | 0.0938 ± 0.0037 ms  | 1 ± 0.052                  |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 22.2 ± 0.35 μs      | 23.8 ± 0.29 μs      | 0.934 ± 0.019              |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.271 ± 0.054 ms    | 0.266 ± 0.053 ms    | 1.02 ± 0.29                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.0716 ± 0.0012 ms  | 0.0718 ± 0.0012 ms  | 0.997 ± 0.023              |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 5.01 ± 0.4 μs       | 4.9 ± 0.42 μs       | 1.02 ± 0.12                |
| Evaluation/Matrix overview T200_L20_S3                                               | 0.0395 ± 0.00091 ms | 0.0397 ± 0.00076 ms | 0.996 ± 0.03               |
| Evaluation/Matrix renewal T200_L20_S1                                                | 9.81 ± 0.73 μs      | 9.75 ± 0.66 μs      | 1.01 ± 0.1                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.0489 ± 0.001 ms   | 0.049 ± 0.00083 ms  | 0.999 ± 0.027              |
| time_to_load                                                                         | 0.235 ± 0.0021 s    | 0.236 ± 0.0012 s    | 0.999 ± 0.01               |

|                                                                                      | v0.1.0                    | dc3cba5fa4dbda...         | v0.1.0 / dc3cba5fa4dbda... |
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

