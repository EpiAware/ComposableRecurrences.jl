|                                                                                                   | v0.1.0              | b2ea38902df734...   | v0.1.0 / b2ea38902df734... |
|:--------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.0675 ± 0.0064 ms  | 0.0656 ± 0.0072 ms  | 1.03 ± 0.15                |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 30.3 ± 0.64 μs      | 0.0318 ± 0.0018 ms  | 0.951 ± 0.058              |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 9.37 ± 1.7 μs       | 4.34 ± 0.49 μs      | 2.16 ± 0.45                |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 0.245 ± 0.039 ms    | 0.24 ± 0.0098 ms    | 1.02 ± 0.17                |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.0525 ± 0.0023 ms  | 0.0444 ± 0.0036 ms  | 1.18 ± 0.11                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 0.252 ± 0.02 ms     | 0.235 ± 0.011 ms    | 1.07 ± 0.099               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.0415 ± 0.0012 ms  | 0.0349 ± 0.00089 ms | 1.19 ± 0.045               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.0351 ± 0.0042 ms  | 0.0329 ± 0.0021 ms  | 1.07 ± 0.14                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 1.03 ± 0.14 ms      | 0.923 ± 0.026 ms    | 1.12 ± 0.16                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.0645 ± 0.0028 ms  | 0.0438 ± 0.0025 ms  | 1.47 ± 0.1                 |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 0.34 ± 0.022 ms     | 0.329 ± 0.039 ms    | 1.03 ± 0.14                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 0.0356 ± 0.00081 ms | 0.0343 ± 0.00084 ms | 1.04 ± 0.035               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.0403 ± 0.003 ms   | 0.0398 ± 0.003 ms   | 1.01 ± 0.11                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 1.02 ± 0.13 ms      | 1.09 ± 0.017 ms     | 0.936 ± 0.12               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.0686 ± 0.0085 ms  | 0.0438 ± 0.0015 ms  | 1.57 ± 0.2                 |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 0.633 ± 0.038 ms    | 0.609 ± 0.027 ms    | 1.04 ± 0.078               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 30.3 ± 2.7 μs       | 27.9 ± 0.98 μs      | 1.09 ± 0.1                 |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.0823 ± 0.0078 ms  | 0.0766 ± 0.01 ms    | 1.07 ± 0.18                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 1.98 ± 0.24 ms      | 1.28 ± 0.04 ms      | 1.54 ± 0.19                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.0623 ± 0.0033 ms  | 0.0339 ± 0.0026 ms  | 1.84 ± 0.17                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.32 ± 0.016 ms     | 0.33 ± 0.45 ms      | 0.971 ± 1.3                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.374 ± 0.29 ms     | 0.636 ± 0.29 ms     | 0.589 ± 0.53               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 7.56 ± 4.4 ms       | 7.57 ± 4.6 ms       | 0.998 ± 0.84               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 0.0498 ± 0.015 s    | 0.0348 ± 0.015 s    | 1.43 ± 0.75                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 1.44 ± 0.033 ms     | 0.324 ± 0.017 ms    | 4.44 ± 0.26                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 0.0768 ± 0.0016 s   | 28.7 ± 13 ms        | 2.67 ± 1.2                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 1.3 ± 0.028 ms      | 0.35 ± 0.017 ms     | 3.7 ± 0.19                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 29.2 ± 12 μs        | 7.93 ± 6.4 μs       | 3.68 ± 3.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.41 ± 0.021 ms     | 0.366 ± 0.049 ms    | 1.12 ± 0.16                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.0602 ± 0.0045 ms  | 16.6 ± 2.3 μs       | 3.62 ± 0.58                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.0633 ± 0.014 ms   | 0.0406 ± 0.007 ms   | 1.56 ± 0.45                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 0.459 ± 0.019 ms    | 0.413 ± 0.027 ms    | 1.11 ± 0.087               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.112 ± 0.016 ms    | 0.0576 ± 0.0072 ms  | 1.94 ± 0.37                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 0.701 ± 0.017 ms    | 0.089 ± 0.012 ms    | 7.88 ± 1.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 18.9 ± 0.34 ms      | 13.5 ± 0.54 ms      | 1.4 ± 0.061                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 0.623 ± 0.05 ms     | 0.108 ± 0.0026 ms   | 5.76 ± 0.48                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.0887 ± 0.016 ms   | 0.0624 ± 0.0075 ms  | 1.42 ± 0.31                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 2.7 ± 0.032 ms      | 1.33 ± 0.63 ms      | 2.04 ± 0.96                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 0.153 ± 0.029 ms    | 0.0821 ± 0.0041 ms  | 1.87 ± 0.36                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 0.943 ± 0.027 ms    | 0.194 ± 0.0079 ms   | 4.85 ± 0.24                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 0.0703 ± 0.0033 s   | 0.0357 ± 0.00043 s  | 1.97 ± 0.096               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 0.854 ± 0.034 ms    | 0.265 ± 0.015 ms    | 3.23 ± 0.22                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 1.08 ± 0.03 ms      | 0.902 ± 0.095 ms    | 1.19 ± 0.13                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.143 ± 0.0077 ms   | 0.0975 ± 0.0029 ms  | 1.47 ± 0.09                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.116 ± 0.011 ms    | 0.134 ± 0.0086 ms   | 0.864 ± 0.099              |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 3.57 ± 0.12 ms      | 3.55 ± 0.12 ms      | 1.01 ± 0.048               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 0.185 ± 0.012 ms    | 0.136 ± 0.014 ms    | 1.36 ± 0.17                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 0.256 ± 0.035 ms    | 0.218 ± 0.016 ms    | 1.18 ± 0.19                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.0557 ± 0.0042 ms  | 0.0458 ± 0.0034 ms  | 1.22 ± 0.13                |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.0476 ± 0.022 ms   | 0.0366 ± 0.0034 ms  | 1.3 ± 0.62                 |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 0.94 ± 0.063 ms     | 0.687 ± 0.039 ms    | 1.37 ± 0.12                |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 0.0884 ± 0.0053 ms  | 0.0653 ± 0.0043 ms  | 1.36 ± 0.12                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 0.412 ± 0.05 ms     | 0.384 ± 0.046 ms    | 1.07 ± 0.18                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.0762 ± 0.0063 ms  | 0.0413 ± 0.001 ms   | 1.84 ± 0.16                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.071 ± 0.014 ms    | 0.0862 ± 0.0043 ms  | 0.824 ± 0.17               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 1.45 ± 0.027 ms     | 1.67 ± 0.03 ms      | 0.872 ± 0.023              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.093 ± 0.005 ms    | 0.0565 ± 0.003 ms   | 1.65 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 0.374 ± 0.021 ms    | 0.298 ± 0.026 ms    | 1.25 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.0563 ± 0.0049 ms  | 0.05 ± 0.0013 ms    | 1.12 ± 0.1                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.0729 ± 0.015 ms   | 0.0527 ± 0.0044 ms  | 1.38 ± 0.31                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 1.42 ± 0.27 ms      | 1.09 ± 0.023 ms     | 1.3 ± 0.25                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 0.0943 ± 0.0036 ms  | 0.0691 ± 0.0023 ms  | 1.36 ± 0.069               |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.0704 ± 0.0017 ms  | 0.0664 ± 0.0016 ms  | 1.06 ± 0.037               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.0394 ± 0.003 ms   | 0.0417 ± 0.0034 ms  | 0.944 ± 0.11               |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 13 ± 1.8 μs         | 11 ± 1.8 μs         | 1.18 ± 0.25                |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 0.245 ± 0.016 ms    | 0.224 ± 0.026 ms    | 1.09 ± 0.14                |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.0737 ± 0.0043 ms  | 0.0541 ± 0.0038 ms  | 1.36 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 0.436 ± 0.051 ms    | 0.291 ± 0.017 ms    | 1.5 ± 0.2                  |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.0732 ± 0.008 ms   | 0.0768 ± 0.0044 ms  | 0.954 ± 0.12               |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.0658 ± 0.029 ms   | 0.0578 ± 0.004 ms   | 1.14 ± 0.51                |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 1.46 ± 0.36 ms      | 1.22 ± 0.022 ms     | 1.2 ± 0.29                 |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 0.154 ± 0.01 ms     | 0.106 ± 0.0059 ms   | 1.46 ± 0.13                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 0.142 ± 0.0087 ms   | 0.123 ± 0.0098 ms   | 1.15 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 27.7 ± 2.8 μs       | 0.0432 ± 0.0014 ms  | 0.641 ± 0.069              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 26.5 ± 1.9 μs       | 27.4 ± 3.9 μs       | 0.969 ± 0.16               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 0.307 ± 0.027 ms    | 0.376 ± 0.036 ms    | 0.816 ± 0.1                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.0559 ± 0.0019 ms  | 0.0586 ± 0.0043 ms  | 0.955 ± 0.077              |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 0.265 ± 0.044 ms    | 0.231 ± 0.015 ms    | 1.15 ± 0.21                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.0771 ± 0.003 ms   | 0.0478 ± 0.0036 ms  | 1.61 ± 0.14                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 0.0321 ± 0.0017 ms  | 0.0351 ± 0.0031 ms  | 0.915 ± 0.094              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 0.83 ± 0.15 ms      | 0.872 ± 0.041 ms    | 0.952 ± 0.18               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 0.092 ± 0.0061 ms   | 0.0712 ± 0.0047 ms  | 1.29 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 0.533 ± 0.021 ms    | 0.346 ± 0.018 ms    | 1.54 ± 0.1                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.0961 ± 0.0036 ms  | 0.0718 ± 0.0047 ms  | 1.34 ± 0.1                 |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.068 ± 0.0048 ms   | 0.0599 ± 0.003 ms   | 1.14 ± 0.099               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 1.94 ± 0.36 ms      | 1.55 ± 0.062 ms     | 1.25 ± 0.24                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 0.137 ± 0.0072 ms   | 0.106 ± 0.0055 ms   | 1.29 ± 0.096               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 1.14 ± 0.32 ms      | 1.23 ± 0.2 ms       | 0.919 ± 0.3                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.0627 ± 0.0063 ms  | 0.058 ± 0.0068 ms   | 1.08 ± 0.17                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.133 ± 0.0086 ms   | 0.153 ± 0.045 ms    | 0.869 ± 0.26               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 4.15 ± 0.79 ms      | 4.21 ± 0.67 ms      | 0.986 ± 0.24               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.0962 ± 0.0057 ms  | 0.0758 ± 0.0071 ms  | 1.27 ± 0.14                |
| Convolution body/BLAS axpy per lag                                                                | 0.778 ± 0.0031 μs   | 0.774 ± 0.0037 μs   | 1.01 ± 0.0063              |
| Convolution body/native axpy per lag                                                              | 0.494 ± 0.0045 μs   | 0.496 ± 0.005 μs    | 0.996 ± 0.014              |
| Convolution body/package                                                                          | 0.779 ± 0.0032 μs   | 0.359 ± 0.004 μs    | 2.17 ± 0.026               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.0719 ± 0.0017 ms  | 0.0583 ± 0.001 ms   | 1.23 ± 0.036               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 5.04 ± 0.28 μs      | 4.05 ± 0.27 μs      | 1.25 ± 0.11                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 2.75 ± 1.6 μs       | 2.09 ± 0.39 μs      | 1.32 ± 0.82                |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.0537 ± 0.0046 ms  | 30.7 ± 1.2 μs       | 1.75 ± 0.16                |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 9.85 ± 1.8 μs       | 9.75 ± 1.7 μs       | 1.01 ± 0.26                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.0665 ± 0.0036 ms  | 0.0379 ± 0.00058 ms | 1.75 ± 0.1                 |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                     | 0.134 ± 0.0066 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                     | 0.0519 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                     | 2.77 ± 0.034 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                     | 0.0487 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                     | 0.415 ± 0.018 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                     | 0.0429 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                     | 0.0461 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                     | 0.933 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                     | 17.7 ± 0.77 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                     | 2.13 ± 0.053 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                     | 0.311 ± 0.032 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                     | 2.49 ± 0.063 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                     | 0.0467 ± 0.00099 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                     | 0.999 ± 0.23 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                     | 0.0678 ± 0.0083 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                     | 0.0619 ± 0.0015 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                     | 5 ± 0.053 ms        |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                     | 0.0572 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                     | 1.04 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                     | 0.123 ± 0.0064 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                     | 0.235 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                     | 0.234 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                     | 0.135 ± 0.0044 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                     | 0.0801 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                     | 3.66 ± 0.44 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                     | 0.437 ± 0.019 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                     | 0.091 ± 0.0041 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                     | 0.232 ± 0.025 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                     | 0.069 ± 0.0017 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                     | 0.0825 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                     | 0.15 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                     | 1.89 ± 0.19 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                     | 1.39 ± 0.03 ms      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                     | 0.0798 ± 0.0022 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                     | 0.875 ± 0.026 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                     | 1.35 ± 0.19 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                     | 0.852 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                     | 1.54 ± 0.042 ms     |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                     | 1.75 ± 0.28 μs      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                     | 0.0406 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                     | 0.248 ± 0.031 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                     | 0.0509 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                     | 24.7 ± 1.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                     | 0.0632 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                     | 0.0398 ± 0.001 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                     | 1.21 ± 0.098 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                     | 0.0377 ± 0.00088 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                     | 0.612 ± 0.067 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                     | 0.0415 ± 0.0039 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                     | 0.71 ± 0.051 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                     | 1.91 ± 0.37 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                     | 0.124 ± 0.0055 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                     | 0.172 ± 0.0062 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                     | 0.12 ± 0.0047 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                     | 0.0762 ± 0.0042 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                     | 31.4 ± 2 μs         |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                     | 0.116 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                     | 0.232 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                     | 29.7 ± 2.7 μs       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                     | 10.1 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                     | 0.277 ± 0.021 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                     | 0.366 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                     | 0.106 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                     | 1.18 ± 0.036 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                     | 0.892 ± 0.26 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                     | 4.12 ± 0.21 ms      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                     | 19.4 ± 1.5 μs       |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                     | 0.0399 ± 0.0008 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                     | 0.0882 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                     | 0.338 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                     | 0.156 ± 0.0078 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                     | 0.435 ± 0.04 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                     | 0.247 ± 0.027 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                     | 0.24 ± 0.015 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                     | 0.0533 ± 0.0016 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                     | 0.046 ± 0.0046 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                     | 0.0786 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                     | 0.0514 ± 0.001 ms   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                     | 0.0679 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                     | 0.362 ± 0.047 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                     | 0.16 ± 0.0081 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                     | 0.128 ± 0.0045 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                     | 30.8 ± 0.78 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                     | 0.0813 ± 0.0046 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                     | 0.978 ± 0.33 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                     | 0.0682 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                     | 0.616 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                     | 1.73 ± 0.046 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                     | 1.73 ± 0.28 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                     | 0.0375 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                     | 0.0883 ± 0.0061 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                     | 0.0587 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                     | 0.0945 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                     | 0.0941 ± 0.0038 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                     | 3.2 ± 0.08 ms       |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                     | 1.08 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                     | 0.0532 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                     | 0.0443 ± 0.0065 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                     | 0.0581 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                     | 0.221 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                     | 0.0546 ± 0.022 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                     | 0.238 ± 0.014 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                     | 0.0594 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                     | 0.0548 ± 0.029 ms   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                     | 0.0607 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                     | 0.344 ± 0.017 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                     | 0.386 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                     | 0.0514 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                     | 0.271 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                     | 0.395 ± 0.019 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                     | 15.7 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                     | 0.0479 ± 0.0012 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                     | 0.133 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                     | 1.03 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                     | 0.131 ± 0.0077 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                     | 0.0591 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                     | 12.7 ± 3 μs         |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                     | 0.174 ± 0.0097 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                     | 0.0556 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                     | 0.0827 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                     | 0.948 ± 0.067 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                     | 0.0395 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                     | 1.34 ± 0.23 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                     | 0.0678 ± 0.022 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                     | 0.0795 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                     | 0.0943 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                     | 0.0657 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                     | 0.0657 ± 0.0017 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                     | 0.866 ± 0.076 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                     | 0.404 ± 0.044 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                     | 3.78 ± 0.26 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                     | 0.84 ± 0.03 ms      |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                     | 0.108 ± 0.0045 ms   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                     | 1.36 ± 0.25 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                     | 0.0669 ± 0.0046 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                     | 1.51 ± 0.023 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                     | 0.0829 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                     | 0.896 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                     | 0.158 ± 0.076 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                     | 0.0319 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                     | 0.0597 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                     | 0.0909 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                     | 0.316 ± 0.017 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                     | 0.0595 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                     | 0.0882 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                     | 0.159 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                     | 1.08 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                     | 0.0386 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                     | 0.0868 ± 0.0045 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                     | 0.11 ± 0.012 ms     |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                     | 1.46 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                     | 0.0702 ± 0.0044 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                     | 0.0392 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                     | 0.283 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                     | 0.0581 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                     | 0.703 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                     | 0.729 ± 0.021 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                     | 0.329 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                     | 2.15 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                     | 0.0584 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                     | 0.0562 ± 0.0045 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                     | 0.133 ± 0.0061 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                     | 0.0707 ± 0.0056 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                     | 1.28 ± 0.016 ms     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                     | 0.0399 ± 0.00079 ms |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                     | 0.172 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                     | 15.8 ± 1.1 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                     | 0.0398 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                     | 2.77 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                     | 0.118 ± 0.0057 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                     | 0.0649 ± 0.049 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                     | 9.79 ± 1.4 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                     | 0.129 ± 0.0072 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                     | 0.055 ± 0.0024 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                     | 0.0716 ± 0.0023 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                     | 0.176 ± 0.11 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                     | 0.0635 ± 0.0029 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                     | 0.0459 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                     | 0.0888 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                     | 0.0616 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                     | 11.2 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                     | 0.0924 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                     | 0.0711 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                     | 0.0754 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                     | 1.04 ± 0.088 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                     | 0.282 ± 0.032 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                     | 0.0574 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                     | 0.0591 ± 0.013 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                     | 0.495 ± 0.04 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                     | 0.102 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                     | 0.118 ± 0.0081 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                     | 0.728 ± 0.09 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                     | 0.0579 ± 0.0036 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                     | 0.036 ± 0.001 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                     | 1.34 ± 0.045 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                     | 0.0822 ± 0.0021 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                     | 0.0697 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                     | 1.52 ± 0.043 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                     | 0.882 ± 0.06 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                     | 0.053 ± 0.0035 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                     | 1.15 ± 0.078 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                     | 0.0338 ± 0.0029 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                     | 0.064 ± 0.0013 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                     | 0.313 ± 0.059 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                     | 0.0566 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                     | 0.0774 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                     | 0.102 ± 0.0075 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                     | 0.0351 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                     | 1.19 ± 0.075 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                     | 0.0952 ± 0.0068 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                     | 0.118 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                     | 0.0349 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                     | 0.138 ± 0.0064 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                     | 0.119 ± 0.0077 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                     | 0.0754 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                     | 1.55 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                     | 1.46 ± 0.034 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                     | 1.29 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                     | 4.98 ± 0.079 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                     | 0.373 ± 0.045 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                     | 0.0741 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                     | 0.114 ± 0.0036 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                     | 10 ± 0.93 μs        |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                     | 2.96 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                     | 0.115 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                     | 0.0611 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                     | 25.7 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                     | 1.12 ± 0.098 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                     | 0.0322 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                     | 3.79 ± 0.073 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                     | 0.426 ± 0.049 ms    |                            |
| time_to_load                                                                                      | 0.238 ± 0.00034 s   | 0.351 ± 0.006 s     | 0.679 ± 0.012              |

|                                                                                                   | v0.1.0                    | b2ea38902df734...         | v0.1.0 / b2ea38902df734... |
|:--------------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 0.147 k allocs: 7.97 kB   | 0.157 k allocs: 8.25 kB   | 0.966                      |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 1.94 k allocs: 0.195 MB   | 1.81 k allocs: 0.171 MB   | 1.14                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.204 k allocs: 18 kB     | 0.164 k allocs: 12.2 kB   | 1.47                       |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.188 k allocs: 0.113 MB  | 0.17 k allocs: 0.0931 MB  | 1.22                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 13.7 k allocs: 0.635 MB   | 10.5 k allocs: 0.512 MB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.829 k allocs: 31.1 kB   | 0.583 k allocs: 21.8 kB   | 1.42                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 2.99 k allocs: 0.267 MB   | 2.8 k allocs: 0.241 MB    | 1.11                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 0.15 k allocs: 11.9 kB    | 0.168 k allocs: 12.4 kB   | 0.963                      |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.266 k allocs: 0.133 MB  | 0.242 k allocs: 0.111 MB  | 1.2                        |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 19.8 k allocs: 0.899 MB   | 15.3 k allocs: 0.739 MB   | 1.22                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.682 k allocs: 24.9 kB   | 0.586 k allocs: 22 kB     | 1.14                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 4.7 k allocs: 0.505 MB    | 4.31 k allocs: 0.435 MB   | 1.16                       |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 0.122 k allocs: 12.5 kB   | 0.137 k allocs: 11.3 kB   | 1.11                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.437 k allocs: 0.289 MB  | 0.392 k allocs: 0.234 MB  | 1.24                       |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 0.0319 M allocs: 1.73 MB  | 23.8 k allocs: 1.41 MB    | 1.23                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.542 k allocs: 22.2 kB   | 0.446 k allocs: 19 kB     | 1.17                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 3.26 k allocs: 0.495 MB   | 0.551 k allocs: 0.155 MB  | 3.2                        |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 8.89 k allocs: 0.0511 GB  | 6.97 k allocs: 0.0399 GB  | 1.28                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 9.4 k allocs: 0.381 MB    | 1.33 k allocs: 0.175 MB   | 2.18                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 0.054 k allocs: 0.0376 MB | 0.051 k allocs: 19.4 kB   | 1.98                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.161 k allocs: 0.0396 MB | 0.166 k allocs: 22 kB     | 1.85                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 1.53 k allocs: 0.294 MB   | 0.206 k allocs: 0.0914 MB | 3.22                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 2.1 k allocs: 24.8 MB     | 1.4 k allocs: 18.3 MB     | 1.36                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 5.84 k allocs: 0.353 MB   | 0.152 k allocs: 0.0905 MB | 3.9                        |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.18 k allocs: 0.0375 MB  | 0.22 k allocs: 29 kB      | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 2.31 k allocs: 0.0849 MB  | 0.67 k allocs: 0.0404 MB  | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 1.53 k allocs: 0.308 MB   | 0.381 k allocs: 0.131 MB  | 2.35                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 6.2 k allocs: 0.0508 GB   | 5.15 k allocs: 0.0396 GB  | 1.28                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 9.06 k allocs: 0.369 MB   | 0.989 k allocs: 0.147 MB  | 2.5                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 8.54 k allocs: 0.784 MB   | 7.89 k allocs: 0.71 MB    | 1.11                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.652 k allocs: 0.0473 MB | 0.483 k allocs: 0.0385 MB | 1.23                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.713 k allocs: 0.321 MB  | 0.632 k allocs: 0.268 MB  | 1.2                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 0.0394 M allocs: 1.95 MB  | 0.0369 M allocs: 1.81 MB  | 1.07                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 1.69 k allocs: 0.0622 MB  | 1.38 k allocs: 0.0625 MB  | 0.995                      |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 2.77 k allocs: 0.162 MB   | 2.43 k allocs: 0.136 MB   | 1.19                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.295 k allocs: 16.2 kB   | 0.237 k allocs: 11.8 kB   | 1.37                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.222 k allocs: 0.0645 MB | 0.182 k allocs: 0.049 MB  | 1.32                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 11.5 k allocs: 0.443 MB   | 10.1 k allocs: 0.389 MB   | 1.14                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 1.02 k allocs: 0.033 MB   | 0.693 k allocs: 24.8 kB   | 1.36                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 3.14 k allocs: 0.279 MB   | 2.95 k allocs: 0.281 MB   | 0.991                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.246 k allocs: 20 kB     | 0.208 k allocs: 15.7 kB   | 1.28                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.303 k allocs: 0.154 MB  | 0.296 k allocs: 0.161 MB  | 0.956                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 17.4 k allocs: 0.834 MB   | 15.8 k allocs: 0.828 MB   | 1.01                       |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.691 k allocs: 26.1 kB   | 0.671 k allocs: 28.1 kB   | 0.928                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 3.18 k allocs: 0.261 MB   | 2.77 k allocs: 0.214 MB   | 1.22                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.233 k allocs: 17.1 kB   | 0.262 k allocs: 18.2 kB   | 0.937                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.29 k allocs: 0.13 MB    | 0.242 k allocs: 0.0952 MB | 1.37                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 15.7 k allocs: 0.716 MB   | 14 k allocs: 0.611 MB     | 1.17                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 1.15 k allocs: 0.0397 MB  | 0.843 k allocs: 0.0325 MB | 1.22                       |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.176 k allocs: 7.66 kB   | 0.22 k allocs: 10.1 kB    | 0.761                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 4.09 k allocs: 0.137 MB   | 3.73 k allocs: 0.131 MB   | 1.05                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.809 k allocs: 25.5 kB   | 0.677 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 3.93 k allocs: 0.263 MB   | 3.07 k allocs: 0.207 MB   | 1.27                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.336 k allocs: 21.5 kB   | 0.388 k allocs: 20.8 kB   | 1.04                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.287 k allocs: 0.125 MB  | 0.252 k allocs: 0.102 MB  | 1.23                       |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 15.9 k allocs: 0.718 MB   | 11.8 k allocs: 0.566 MB   | 1.27                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 1.3 k allocs: 0.0436 MB   | 0.927 k allocs: 0.035 MB  | 1.25                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 1.5 k allocs: 0.132 MB    | 1.25 k allocs: 0.104 MB   | 1.27                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 0.198 k allocs: 15.6 kB   | 0.268 k allocs: 20.5 kB   | 0.762                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 0.174 k allocs: 0.0836 MB | 0.138 k allocs: 0.0622 MB | 1.34                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 5.38 k allocs: 0.321 MB   | 4.41 k allocs: 0.264 MB   | 1.22                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.39 k allocs: 16.1 kB    | 0.466 k allocs: 24.5 kB   | 0.659                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 2.74 k allocs: 0.209 MB   | 2.38 k allocs: 0.168 MB   | 1.24                       |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.382 k allocs: 21.7 kB   | 0.223 k allocs: 13.8 kB   | 1.57                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 0.237 k allocs: 0.105 MB  | 0.192 k allocs: 0.0755 MB | 1.39                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 12.3 k allocs: 0.571 MB   | 10.9 k allocs: 0.487 MB   | 1.17                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 1.02 k allocs: 0.0353 MB  | 0.713 k allocs: 27.8 kB   | 1.3                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 4.32 k allocs: 0.329 MB   | 3.35 k allocs: 0.252 MB   | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.382 k allocs: 24.6 kB   | 0.361 k allocs: 22.7 kB   | 1.09                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.338 k allocs: 0.149 MB  | 0.284 k allocs: 0.114 MB  | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 19.4 k allocs: 0.879 MB   | 14.8 k allocs: 0.696 MB   | 1.26                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 1.35 k allocs: 0.046 MB   | 0.981 k allocs: 0.0384 MB | 1.2                        |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 10.7 k allocs: 0.915 MB   | 9.37 k allocs: 0.762 MB   | 1.2                        |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.383 k allocs: 25 kB     | 0.27 k allocs: 21.4 kB    | 1.17                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.886 k allocs: 0.384 MB  | 0.733 k allocs: 0.275 MB  | 1.4                        |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 0.0515 M allocs: 2.58 MB  | 0.0464 M allocs: 2.29 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.863 k allocs: 0.033 MB  | 0.837 k allocs: 0.0341 MB | 0.967                      |
| Convolution body/BLAS axpy per lag                                                                | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                                              | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                                          | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.091 k allocs: 0.0452 MB | 0.07 k allocs: 0.0349 MB  | 1.29                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.04 k allocs: 0.0395 MB  | 28  allocs: 29.7 kB       | 1.36                       |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 0.034 k allocs: 7.98 kB   | 30  allocs: 7.72 kB       | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.072 k allocs: 0.0443 MB | 0.051 k allocs: 0.0342 MB | 1.3                        |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                           | 1.19 k allocs: 0.0452 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                           | 0.224 k allocs: 16.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                           | 23.2 k allocs: 1.15 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                           | 0.333 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                           | 0.282 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                           | 0.274 k allocs: 0.112 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                           | 0.913 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                           | 0.103 k allocs: 4.42 kB   |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                           | 3.14 k allocs: 0.211 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                           | 22.8 k allocs: 1.12 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                           | 0.248 k allocs: 16.8 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                           | 13.7 k allocs: 0.586 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                           | 0.619 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                           | 0.0411 M allocs: 2.13 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                           | 0.556 k allocs: 24.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                           | 9.61 k allocs: 0.79 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                           | 0.45 k allocs: 0.163 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                           | 2.44 k allocs: 0.165 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                           | 2.49 k allocs: 0.14 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                           | 1.03 k allocs: 0.0388 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                           | 0.429 k allocs: 21.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                           | 0.051 k allocs: 3.39 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                           | 4.61 k allocs: 0.325 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                           | 0.984 k allocs: 0.0375 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                           | 2.38 k allocs: 0.163 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                           | 0.348 k allocs: 16.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                           | 0.699 k allocs: 24.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                           | 0.596 k allocs: 0.195 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                           | 12.4 k allocs: 0.604 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                           | 0.345 k allocs: 20.1 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                           | 10.1 k allocs: 0.463 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                           | 18.8 k allocs: 0.873 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                           | 10.8 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                           | 16.2 k allocs: 0.842 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                           | 0.586 k allocs: 25 kB     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                           | 2.16 k allocs: 0.165 MB   |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                           | 0.233 k allocs: 16.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                           | 0.138 k allocs: 0.0622 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                           | 0.272 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                           | 0.163 k allocs: 11.3 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                           | 4.54 k allocs: 0.451 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                           | 0.179 k allocs: 8.25 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                           | 5.77 k allocs: 0.433 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                           | 21.2 k allocs: 0.957 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                           | 0.589 k allocs: 0.0409 MB |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                           | 0.685 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                           | 1.26 k allocs: 0.0517 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                           | 0.801 k allocs: 31.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                           | 0.226 k allocs: 0.0894 MB |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                           | 0.98 k allocs: 0.0329 MB  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                           | 1.89 k allocs: 0.175 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                           | 0.176 k allocs: 0.0935 MB |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                           | 0.186 k allocs: 9.88 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                           | 2.45 k allocs: 0.172 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                           | 5.28 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                           | 0.963 k allocs: 0.0351 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                           | 11.5 k allocs: 0.524 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                           | 0.0472 M allocs: 2.33 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                           | 0.201 k allocs: 9.69 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                           | 0.426 k allocs: 28.6 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                           | 2.91 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                           | 1.09 k allocs: 0.035 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                           | 4.52 k allocs: 0.319 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                           | 2.16 k allocs: 0.165 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                           | 2.48 k allocs: 0.174 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                           | 0.351 k allocs: 19.4 kB   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                           | 0.202 k allocs: 0.248 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                           | 0.662 k allocs: 27.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                           | 0.251 k allocs: 16.5 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                           | 0.335 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                           | 3.05 k allocs: 0.289 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                           | 0.587 k allocs: 0.192 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                           | 0.958 k allocs: 31.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                           | 0.129 k allocs: 11.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                           | 0.303 k allocs: 0.161 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                           | 16.9 k allocs: 0.927 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                           | 0.309 k allocs: 20.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                           | 5.87 k allocs: 0.443 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                           | 21.5 k allocs: 0.972 MB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                           | 0.217 k allocs: 0.0845 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                           | 0.452 k allocs: 0.237 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                           | 0.479 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                           | 0.417 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                           | 0.846 k allocs: 0.0315 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                           | 0.0398 M allocs: 2.03 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                           | 9.98 k allocs: 0.727 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                           | 0.202 k allocs: 0.0499 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                           | 0.296 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                           | 2.48 k allocs: 0.174 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                           | 0.212 k allocs: 0.0765 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                           | 0.579 k allocs: 0.198 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                           | 0.436 k allocs: 0.15 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                           | 0.266 k allocs: 0.0965 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                           | 0.754 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                           | 3.42 k allocs: 0.26 MB    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                           | 0.314 k allocs: 0.163 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                           | 3.95 k allocs: 0.144 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                           | 1.08 k allocs: 0.22 MB    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                           | 0.235 k allocs: 14.1 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                           | 1.11 k allocs: 0.037 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                           | 8.01 k allocs: 0.733 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                           | 1.25 k allocs: 0.104 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                           | 0.619 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                           | 0.07 k allocs: 13.7 kB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                           | 1.37 k allocs: 0.054 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                           | 0.74 k allocs: 29.5 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                           | 9.37 k allocs: 0.695 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                           | 0.324 k allocs: 0.147 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                           | 0.356 k allocs: 23.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                           | 0.834 k allocs: 30.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                           | 0.289 k allocs: 18.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                           | 9.13 k allocs: 0.678 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                           | 3.96 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                           | 0.0373 M allocs: 1.85 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                           | 10.3 k allocs: 0.469 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                           | 0.524 k allocs: 0.035 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                           | 0.693 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                           | 17.3 k allocs: 0.816 MB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                           | 0.183 k allocs: 0.0407 MB |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                           | 10.7 k allocs: 0.424 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                           | 0.75 k allocs: 0.277 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                           | 0.34 k allocs: 23.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                           | 0.371 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                           | 0.825 k allocs: 0.0323 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                           | 2.85 k allocs: 0.222 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                           | 0.312 k allocs: 18.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                           | 0.311 k allocs: 19.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                           | 0.786 k allocs: 0.261 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                           | 10.1 k allocs: 0.736 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                           | 0.226 k allocs: 0.0894 MB |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                           | 0.749 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                           | 1.09 k allocs: 0.0546 MB  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                           | 17.6 k allocs: 0.831 MB   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                           | 0.212 k allocs: 0.084 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                           | 4.41 k allocs: 0.263 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                           | 0.26 k allocs: 17 kB      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                           | 1.16 k allocs: 0.191 MB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                           | 6.98 k allocs: 0.527 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                           | 4.6 k allocs: 0.345 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                           | 25.8 k allocs: 1.53 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                           | 0.22 k allocs: 15.8 kB    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                           | 0.221 k allocs: 14.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                           | 0.722 k allocs: 0.258 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                           | 0.49 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                           | 1.25 k allocs: 0.115 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                           | 0.21 k allocs: 14.2 kB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                           | 0.746 k allocs: 0.357 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                           | 30.7 k allocs: 1.42 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                           | 0.331 k allocs: 0.148 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                           | 0.05 k allocs: 9.29 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                           | 1.11 k allocs: 0.046 MB   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                           | 0.316 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                           | 0.734 k allocs: 0.357 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                           | 0.734 k allocs: 30.7 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                           | 0.458 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                           | 0.847 k allocs: 0.0315 MB |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                           | 0.39 k allocs: 0.0646 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                           | 0.396 k allocs: 27.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                           | 0.814 k allocs: 0.0409 MB |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                           | 0.443 k allocs: 0.151 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                           | 2.81 k allocs: 0.504 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                           | 0.292 k allocs: 19.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                           | 0.29 k allocs: 0.114 MB   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                           | 1.11 k allocs: 0.0559 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                           | 0.911 k allocs: 0.0332 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                           | 6.86 k allocs: 0.512 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                           | 0.166 k allocs: 13.5 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                           | 16.3 k allocs: 0.8 MB     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                           | 0.708 k allocs: 26 kB     |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                           | 0.841 k allocs: 0.0322 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                           | 15.1 k allocs: 0.711 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                           | 3.77 k allocs: 0.332 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                           | 0.239 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                           | 0.067 k allocs: 0.0331 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                           | 0.337 k allocs: 19.1 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                           | 4.71 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                           | 0.434 k allocs: 0.13 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                           | 0.558 k allocs: 22.9 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                           | 1.13 k allocs: 0.0395 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                           | 0.249 k allocs: 16.7 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                           | 17.9 k allocs: 0.98 MB    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                           | 0.92 k allocs: 0.0365 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                           | 0.442 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                           | 1.08 k allocs: 0.0394 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                           | 1.14 k allocs: 0.043 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                           | 0.342 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                           | 19.6 k allocs: 0.917 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                           | 14.8 k allocs: 0.965 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                           | 14.7 k allocs: 0.659 MB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                           | 0.0417 M allocs: 2.15 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                           | 5.37 k allocs: 0.323 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                           | 0.632 k allocs: 25.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                           | 0.855 k allocs: 30.9 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                           | 0.049 k allocs: 9.18 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                           | 30.3 k allocs: 1.39 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                           | 0.641 k allocs: 0.27 MB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                           | 0.458 k allocs: 0.131 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                           | 0.153 k allocs: 13.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                           | 13.7 k allocs: 0.586 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                           | 0.349 k allocs: 24.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                           | 0.0419 M allocs: 2.16 MB  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                           | 3.87 k allocs: 0.311 MB   |                            |
| time_to_load                                                                                      | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

