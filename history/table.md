|                                                                                             | v0.1.0              | 923180bfb36809...   | v0.1.0 / 923180bfb36809... |
|:--------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.067 ± 0.0065 ms   | 0.0679 ± 0.0081 ms  | 0.986 ± 0.15               |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 28.2 ± 0.83 μs      | 31.5 ± 2.7 μs       | 0.898 ± 0.08               |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 5.36 ± 3.8 μs       | 8.18 ± 1.4 μs       | 0.655 ± 0.48               |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.188 ± 0.029 ms    | 0.195 ± 0.022 ms    | 0.964 ± 0.19               |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.0381 ± 0.0011 ms  | 0.0322 ± 0.0042 ms  | 1.18 ± 0.16                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.329 ± 0.012 ms    | 0.328 ± 0.018 ms    | 1 ± 0.064                  |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.0349 ± 0.00089 ms | 30.6 ± 1 μs         | 1.14 ± 0.048               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.0512 ± 0.0041 ms  | 0.0538 ± 0.0041 ms  | 0.951 ± 0.1                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.803 ± 0.23 ms     | 0.857 ± 0.033 ms    | 0.937 ± 0.27               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.0446 ± 0.0017 ms  | 0.0327 ± 0.0011 ms  | 1.37 ± 0.069               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.609 ± 0.028 ms    | 0.638 ± 0.08 ms     | 0.955 ± 0.13               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 28.8 ± 0.9 μs       | 27.8 ± 1.3 μs       | 1.03 ± 0.059               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.102 ± 0.0097 ms   | 0.108 ± 0.011 ms    | 0.946 ± 0.13               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.47 ± 0.27 ms      | 1.55 ± 0.27 ms      | 0.952 ± 0.24               |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.0404 ± 0.0024 ms  | 26.5 ± 2.3 μs       | 1.52 ± 0.16                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.35 ± 0.022 ms     | 0.355 ± 0.041 ms    | 0.987 ± 0.13               |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.418 ± 0.26 ms     | 0.67 ± 0.28 ms      | 0.624 ± 0.47               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 7.38 ± 0.62 ms      | 7.22 ± 2.8 ms       | 1.02 ± 0.4                 |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 0.0375 ± 0.0062 s   | 0.037 ± 0.0032 s    | 1.02 ± 0.19                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 1.37 ± 0.022 ms     | 0.307 ± 0.012 ms    | 4.47 ± 0.2                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0624 ± 0.013 s    | 0.0343 ± 0.012 s    | 1.82 ± 0.76                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 1.09 ± 0.019 ms     | 0.277 ± 0.012 ms    | 3.93 ± 0.19                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.0331 ± 0.0029 ms  | 10.3 ± 4.8 μs       | 3.21 ± 1.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 1.16 ± 0.028 ms     | 0.529 ± 0.032 ms    | 2.19 ± 0.14                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.0542 ± 0.0035 ms  | 15.2 ± 2.1 μs       | 3.56 ± 0.54                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.061 ± 0.0083 ms   | 0.0354 ± 0.0047 ms  | 1.72 ± 0.33                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 1.33 ± 0.021 ms     | 1.01 ± 0.36 ms      | 1.31 ± 0.46                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.0859 ± 0.0041 ms  | 0.0439 ± 0.0027 ms  | 1.96 ± 0.15                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.585 ± 0.016 ms    | 0.0769 ± 0.0024 ms  | 7.6 ± 0.32                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 21.8 ± 0.48 ms      | 14.7 ± 5.9 ms       | 1.48 ± 0.6                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.544 ± 0.039 ms    | 0.091 ± 0.0028 ms   | 5.98 ± 0.47                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0836 ± 0.013 ms   | 0.107 ± 0.0087 ms   | 0.779 ± 0.13               |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 2.53 ± 0.019 ms     | 1.41 ± 0.44 ms      | 1.8 ± 0.56                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.117 ± 0.017 ms    | 0.0588 ± 0.0046 ms  | 1.99 ± 0.32                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.792 ± 0.064 ms    | 0.168 ± 0.0077 ms   | 4.72 ± 0.44                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 0.0573 ± 0.011 s    | 0.0413 ± 0.013 s    | 1.39 ± 0.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.798 ± 0.037 ms    | 0.199 ± 0.01 ms     | 4.01 ± 0.28                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.388 ± 0.018 ms    | 0.38 ± 0.014 ms     | 1.02 ± 0.061               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.0694 ± 0.0084 ms  | 0.0368 ± 0.0011 ms  | 1.89 ± 0.23                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0841 ± 0.021 ms   | 0.0957 ± 0.0096 ms  | 0.88 ± 0.24                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 1.07 ± 0.18 ms      | 1.4 ± 0.037 ms      | 0.765 ± 0.13               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0593 ± 0.0024 ms  | 0.0384 ± 0.0013 ms  | 1.55 ± 0.081               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.365 ± 0.021 ms    | 0.353 ± 0.015 ms    | 1.03 ± 0.075               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.0506 ± 0.0022 ms  | 0.079 ± 0.0021 ms   | 0.641 ± 0.032              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0727 ± 0.0095 ms  | 0.22 ± 0.0064 ms    | 0.33 ± 0.044               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 1.03 ± 0.13 ms      | 1.24 ± 0.036 ms     | 0.833 ± 0.11               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0686 ± 0.0046 ms  | 0.0481 ± 0.002 ms   | 1.43 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0746 ± 0.0056 ms  | 0.0688 ± 0.002 ms   | 1.08 ± 0.088               |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.0364 ± 0.0026 ms  | 0.0366 ± 0.0026 ms  | 0.994 ± 0.1                |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 12.3 ± 2.2 μs       | 9.55 ± 2.5 μs       | 1.29 ± 0.4                 |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.184 ± 0.012 ms    | 0.167 ± 0.022 ms    | 1.1 ± 0.16                 |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.0511 ± 0.0029 ms  | 0.0403 ± 0.0023 ms  | 1.27 ± 0.1                 |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.398 ± 0.024 ms    | 0.3 ± 0.017 ms      | 1.33 ± 0.11                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0623 ± 0.004 ms   | 0.0543 ± 0.0018 ms  | 1.15 ± 0.082               |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0714 ± 0.008 ms   | 0.0621 ± 0.0061 ms  | 1.15 ± 0.17                |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 1.07 ± 0.051 ms     | 0.966 ± 0.013 ms    | 1.11 ± 0.055               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.0979 ± 0.0067 ms  | 0.0606 ± 0.0017 ms  | 1.62 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.127 ± 0.0075 ms   | 0.128 ± 0.0066 ms   | 0.989 ± 0.077              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 27.1 ± 2.6 μs       | 0.0395 ± 0.0016 ms  | 0.685 ± 0.072              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 31.2 ± 2.9 μs       | 28.7 ± 4.6 μs       | 1.08 ± 0.2                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.315 ± 0.026 ms    | 0.322 ± 0.072 ms    | 0.977 ± 0.23               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.0355 ± 0.00099 ms | 0.0345 ± 0.0033 ms  | 1.03 ± 0.1                 |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.282 ± 0.035 ms    | 0.245 ± 0.017 ms    | 1.15 ± 0.16                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0693 ± 0.005 ms   | 0.0379 ± 0.0012 ms  | 1.83 ± 0.14                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.0352 ± 0.0032 ms  | 0.0395 ± 0.0031 ms  | 0.89 ± 0.11                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.67 ± 0.097 ms     | 0.676 ± 0.018 ms    | 0.991 ± 0.15               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0613 ± 0.0053 ms  | 0.0415 ± 0.0018 ms  | 1.48 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.504 ± 0.03 ms     | 0.353 ± 0.023 ms    | 1.43 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0764 ± 0.0036 ms  | 0.0523 ± 0.0022 ms  | 1.46 ± 0.091               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0738 ± 0.0066 ms  | 0.0664 ± 0.012 ms   | 1.11 ± 0.23                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.35 ± 0.16 ms      | 1.15 ± 0.015 ms     | 1.17 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.0918 ± 0.0083 ms  | 0.0628 ± 0.0019 ms  | 1.46 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 1.19 ± 0.21 ms      | 1.15 ± 0.13 ms      | 1.04 ± 0.22                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0566 ± 0.0038 ms  | 0.0532 ± 0.003 ms   | 1.06 ± 0.093               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.139 ± 0.01 ms     | 0.161 ± 0.011 ms    | 0.862 ± 0.085              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 3 ± 0.47 ms         | 3.43 ± 0.18 ms      | 0.873 ± 0.14               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0648 ± 0.0044 ms  | 0.0484 ± 0.003 ms   | 1.34 ± 0.12                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0609 ± 0.011 ms   | 0.0511 ± 0.0013 ms  | 1.19 ± 0.22                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 3.55 ± 0.35 μs      | 3.62 ± 0.25 μs      | 0.982 ± 0.12               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 2.76 ± 1.7 μs       | 2.27 ± 0.38 μs      | 1.22 ± 0.79                |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.0392 ± 0.003 ms   | 0.037 ± 0.0025 ms   | 1.06 ± 0.11                |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 8.01 ± 1.5 μs       | 8.47 ± 1.5 μs       | 0.946 ± 0.24               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.057 ± 0.0048 ms   | 0.0349 ± 0.0021 ms  | 1.63 ± 0.17                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                     | 0.0435 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                     | 11 ± 2.2 μs         |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                     | 0.0887 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                     | 0.0469 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                     | 2.08 ± 0.059 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                     | 0.0504 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                     | 0.054 ± 0.0016 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                     | 0.0365 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                     | 0.934 ± 0.061 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                     | 0.0418 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                     | 0.0614 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                     | 0.916 ± 0.0083 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                     | 0.106 ± 0.0038 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                     | 0.311 ± 0.018 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                     | 2.29 ± 0.17 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                     | 0.0417 ± 0.0011 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                     | 0.904 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                     | 0.0553 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                     | 0.0663 ± 0.003 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                     | 6.48 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                     | 0.0561 ± 0.0017 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                     | 0.92 ± 0.046 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                     | 0.0398 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                     | 1.16 ± 0.035 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                     | 0.128 ± 0.0064 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                     | 0.0913 ± 0.0048 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                     | 0.103 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                     | 0.462 ± 0.023 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                     | 0.0572 ± 0.0017 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                     | 0.162 ± 0.0072 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                     | 0.0473 ± 0.0026 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                     | 0.0833 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                     | 0.138 ± 0.0066 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                     | 1.13 ± 0.065 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                     | 0.0728 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                     | 0.184 ± 0.0093 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                     | 0.0633 ± 0.002 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                     | 0.0318 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                     | 0.0659 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                     | 0.318 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                     | 1.29 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                     | 0.072 ± 0.0021 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                     | 0.239 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                     | 0.169 ± 0.0084 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                     | 28.4 ± 6 μs         |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                     | 1.09 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                     | 0.0447 ± 0.011 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                     | 0.0902 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                     | 0.0695 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                     | 0.0666 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                     | 0.324 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                     | 0.0354 ± 0.00092 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                     | 0.624 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                     | 0.649 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                     | 0.0359 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                     | 0.772 ± 0.044 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                     | 1.85 ± 0.11 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                     | 0.742 ± 0.023 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                     | 1.37 ± 0.32 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                     | 0.139 ± 0.0055 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                     | 0.047 ± 0.0015 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                     | 0.0794 ± 0.0084 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                     | 0.162 ± 0.0086 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                     | 0.0468 ± 0.019 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                     | 0.0698 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                     | 1.14 ± 0.011 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                     | 0.313 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                     | 0.0687 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                     | 0.216 ± 0.011 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                     | 0.0452 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                     | 2 ± 0.07 ms         |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                     | 0.829 ± 0.18 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                     | 0.0901 ± 0.007 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                     | 10.4 ± 1.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                     | 0.934 ± 0.097 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                     | 3.42 ± 0.069 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                     | 0.0777 ± 0.0053 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                     | 0.0857 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                     | 0.0555 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                     | 0.344 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                     | 0.0884 ± 0.0039 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                     | 0.477 ± 0.021 ms    |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                     | 0.268 ± 0.11 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                     | 0.0424 ± 0.0021 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                     | 0.244 ± 0.014 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                     | 0.256 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                     | 0.0576 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                     | 0.053 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                     | 9.5 ± 1.5 μs        |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                     | 0.0771 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                     | 0.0459 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                     | 0.0727 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                     | 0.0865 ± 0.0056 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                     | 1.16 ± 0.075 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                     | 0.206 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                     | 0.381 ± 0.02 ms     |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                     | 0.237 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                     | 0.0708 ± 0.023 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                     | 0.0848 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                     | 0.0745 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                     | 0.0783 ± 0.0031 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                     | 1.02 ± 0.041 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                     | 30.3 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                     | 0.0996 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                     | 0.0558 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                     | 0.0405 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                     | 0.652 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                     | 1.3 ± 0.12 ms       |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                     | 1.08 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                     | 0.0554 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                     | 0.115 ± 0.009 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                     | 0.0381 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                     | 0.0862 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                     | 1.28 ± 0.029 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                     | 2.42 ± 0.06 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                     | 1.09 ± 0.032 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                     | 0.0422 ± 0.0027 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                     | 0.855 ± 0.056 ms    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                     | 0.0332 ± 0.0025 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                     | 0.0545 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                     | 0.0524 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                     | 0.0505 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                     | 0.237 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                     | 0.0417 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                     | 30.3 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                     | 0.314 ± 0.054 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                     | 0.129 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                     | 0.0966 ± 0.0051 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                     | 0.0732 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                     | 0.058 ± 0.0098 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                     | 0.0821 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                     | 0.21 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                     | 0.372 ± 0.02 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                     | 0.0578 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                     | 0.868 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                     | 0.465 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                     | 6.27 ± 0.27 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                     | 0.0754 ± 0.0024 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                     | 10.9 ± 1.5 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                     | 0.0772 ± 0.0039 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                     | 2.51 ± 0.29 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                     | 27.9 ± 3.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                     | 0.883 ± 0.035 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                     | 0.0324 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                     | 0.127 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                     | 2.75 ± 0.065 ms     |                            |
| time_to_load                                                                                | 0.236 ± 0.00088 s   | 0.345 ± 0.0018 s    | 0.685 ± 0.0044             |

|                                                                                             | v0.1.0                    | 923180bfb36809...         | v0.1.0 / 923180bfb36809... |
|:--------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.631 k allocs: 0.0348 MB | 0.631 k allocs: 0.0348 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 0.147 k allocs: 7.97 kB   | 0.152 k allocs: 7.52 kB   | 1.06                       |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 2.99 k allocs: 0.268 MB   | 2.99 k allocs: 0.268 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.15 k allocs: 11.9 kB    | 0.165 k allocs: 11.8 kB   | 1.01                       |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 4.7 k allocs: 0.506 MB    | 4.7 k allocs: 0.506 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 0.122 k allocs: 12.5 kB   | 0.134 k allocs: 10.9 kB   | 1.15                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 3.26 k allocs: 0.495 MB   | 0.558 k allocs: 0.163 MB  | 3.03                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 8.89 k allocs: 0.0511 GB  | 7.45 k allocs: 0.0492 GB  | 1.04                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 9.4 k allocs: 0.381 MB    | 1.34 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.054 k allocs: 0.0376 MB | 0.046 k allocs: 19.2 kB   | 2.01                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 21.4 kB   | 1.89                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 1.53 k allocs: 0.294 MB   | 0.211 k allocs: 0.101 MB  | 2.91                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 2.1 k allocs: 24.8 MB     | 1.8 k allocs: 24.2 MB     | 1.03                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 5.84 k allocs: 0.353 MB   | 0.162 k allocs: 0.1 MB    | 3.51                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.18 k allocs: 0.0375 MB  | 0.222 k allocs: 29.1 kB   | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 0.822 k allocs: 1.78 MB   | 0.762 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 1.53 k allocs: 0.308 MB   | 0.388 k allocs: 0.14 MB   | 2.2                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 6.2 k allocs: 0.0508 GB   | 5.62 k allocs: 0.0489 GB  | 1.04                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 9.06 k allocs: 0.369 MB   | 0.994 k allocs: 0.156 MB  | 2.37                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 3.15 k allocs: 0.279 MB   | 3.15 k allocs: 0.315 MB   | 0.887                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.246 k allocs: 20 kB     | 0.214 k allocs: 16.3 kB   | 1.23                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.303 k allocs: 0.154 MB  | 0.331 k allocs: 0.187 MB  | 0.822                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 17.4 k allocs: 0.834 MB   | 16.4 k allocs: 0.894 MB   | 0.934                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.691 k allocs: 26.1 kB   | 0.677 k allocs: 28.7 kB   | 0.909                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 3.18 k allocs: 0.262 MB   | 2.91 k allocs: 0.239 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.233 k allocs: 17.1 kB   | 0.268 k allocs: 18.8 kB   | 0.908                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.29 k allocs: 0.13 MB    | 0.272 k allocs: 0.116 MB  | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 15.7 k allocs: 0.716 MB   | 14.5 k allocs: 0.667 MB   | 1.07                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 1.15 k allocs: 0.0397 MB  | 0.851 k allocs: 0.0331 MB | 1.2                        |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.836 k allocs: 0.0416 MB | 0.792 k allocs: 0.0396 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.176 k allocs: 7.66 kB   | 0.222 k allocs: 10.1 kB   | 0.759                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 0.07 k allocs: 14.2 kB    | 0.066 k allocs: 13.4 kB   | 1.06                       |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 4.09 k allocs: 0.137 MB   | 3.77 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.809 k allocs: 25.5 kB   | 0.679 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 3.93 k allocs: 0.263 MB   | 3.31 k allocs: 0.237 MB   | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.336 k allocs: 21.5 kB   | 0.394 k allocs: 21.3 kB   | 1.01                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.287 k allocs: 0.125 MB  | 0.287 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 15.9 k allocs: 0.718 MB   | 12.3 k allocs: 0.625 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 1.3 k allocs: 0.0436 MB   | 0.933 k allocs: 0.0356 MB | 1.23                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 1.5 k allocs: 0.132 MB    | 1.34 k allocs: 0.119 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 0.198 k allocs: 15.6 kB   | 0.274 k allocs: 21.2 kB   | 0.735                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 0.174 k allocs: 0.0836 MB | 0.158 k allocs: 0.075 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 5.38 k allocs: 0.321 MB   | 4.64 k allocs: 0.293 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.39 k allocs: 16.1 kB    | 0.472 k allocs: 25.1 kB   | 0.643                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 2.74 k allocs: 0.209 MB   | 2.51 k allocs: 0.19 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.382 k allocs: 21.7 kB   | 0.229 k allocs: 14.4 kB   | 1.51                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.237 k allocs: 0.105 MB  | 0.217 k allocs: 0.0927 MB | 1.13                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 12.3 k allocs: 0.571 MB   | 11.2 k allocs: 0.529 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 1.02 k allocs: 0.0353 MB  | 0.719 k allocs: 28.3 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 4.33 k allocs: 0.33 MB    | 3.48 k allocs: 0.276 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.382 k allocs: 24.6 kB   | 0.367 k allocs: 23.2 kB   | 1.06                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.338 k allocs: 0.149 MB  | 0.314 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.737 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 1.35 k allocs: 0.046 MB   | 0.985 k allocs: 0.039 MB  | 1.18                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 10.7 k allocs: 0.917 MB   | 9.83 k allocs: 0.844 MB   | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.383 k allocs: 25 kB     | 0.276 k allocs: 22 kB     | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.886 k allocs: 0.384 MB  | 0.818 k allocs: 0.338 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 0.0515 M allocs: 2.58 MB  | 0.0474 M allocs: 2.42 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.863 k allocs: 0.033 MB  | 0.841 k allocs: 0.0347 MB | 0.952                      |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.091 k allocs: 0.0452 MB | 0.075 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.04 k allocs: 0.0395 MB  | 0.036 k allocs: 0.0384 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 0.034 k allocs: 7.98 kB   | 0.032 k allocs: 7.77 kB   | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.072 k allocs: 0.0443 MB | 0.056 k allocs: 0.042 MB  | 1.06                       |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.074 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                           | 1.2 k allocs: 0.046 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                           | 0.276 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                           | 23.7 k allocs: 1.22 MB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.254 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.748 k allocs: 30.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                           | 0.341 k allocs: 14.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.8 k allocs: 0.751 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                           | 0.933 k allocs: 0.119 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.41 k allocs: 26.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                           | 3.38 k allocs: 0.242 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                           | 23.4 k allocs: 1.19 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                           | 0.254 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.66 k allocs: 0.0361 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                           | 0.042 M allocs: 2.24 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.348 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.56 k allocs: 0.733 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                           | 0.56 k allocs: 24.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                           | 10.1 k allocs: 0.872 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                           | 0.49 k allocs: 0.19 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.03 k allocs: 0.0397 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.435 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.78 k allocs: 0.356 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.99 k allocs: 0.0381 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.53 k allocs: 0.0356 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.354 k allocs: 16.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.641 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.9 k allocs: 0.662 MB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                           | 0.886 k allocs: 0.342 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.399 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                           | 0.356 k allocs: 26.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                           | 16.7 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                           | 0.317 k allocs: 20.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                           | 2.25 k allocs: 0.181 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                           | 0.866 k allocs: 0.302 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                           | 0.158 k allocs: 0.075 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                           | 10.5 k allocs: 0.793 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                           | 1.11 k allocs: 0.0594 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                           | 0.307 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.161 k allocs: 0.0339 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.64 k allocs: 0.293 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                           | 0.169 k allocs: 12.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                           | 4.93 k allocs: 0.522 MB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 0.722 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                           | 0.181 k allocs: 8.3 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.21 k allocs: 0.566 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                           | 5.97 k allocs: 0.467 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                           | 21.7 k allocs: 1.02 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                           | 0.689 k allocs: 0.036 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                           | 1.26 k allocs: 0.0523 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                           | 0.802 k allocs: 0.298 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.986 k allocs: 0.0334 MB |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                           | 0.971 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                           | 0.806 k allocs: 0.402 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                           | 31.3 k allocs: 1.5 MB     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                           | 0.053 k allocs: 11.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                           | 0.0496 M allocs: 2.59 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                           | 1.12 k allocs: 0.0465 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                           | 0.432 k allocs: 29.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                           | 0.36 k allocs: 19.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                           | 3.1 k allocs: 0.275 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                           | 1.1 k allocs: 0.0359 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                           | 4.69 k allocs: 0.349 MB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                           | 0.794 k allocs: 0.401 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                           | 0.74 k allocs: 31.2 kB    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                           | 2.25 k allocs: 0.181 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                           | 0.67 k allocs: 28.1 kB    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                           | 0.24 k allocs: 0.06 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                           | 0.45 k allocs: 29.5 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                           | 0.289 k allocs: 18.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                           | 0.82 k allocs: 0.0411 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                           | 0.478 k allocs: 0.175 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                           | 2.82 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                           | 3.25 k allocs: 0.323 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                           | 0.632 k allocs: 0.223 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                           | 0.338 k allocs: 0.136 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                           | 1.14 k allocs: 0.0607 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                           | 0.97 k allocs: 0.0321 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                           | 0.929 k allocs: 0.0338 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                           | 7.09 k allocs: 0.551 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                           | 0.135 k allocs: 13.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                           | 0.338 k allocs: 0.187 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                           | 0.371 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                           | 6.07 k allocs: 0.478 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                           | 22 k allocs: 1.03 MB      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                           | 0.716 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                           | 0.471 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                           | 15.8 k allocs: 0.786 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                           | 0.041 M allocs: 2.14 MB   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                           | 10.3 k allocs: 0.785 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                           | 0.243 k allocs: 17.7 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                           | 0.045 k allocs: 0.0318 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                           | 0.343 k allocs: 19.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.352 k allocs: 23.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                           | 0.562 k allocs: 23.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.237 k allocs: 0.0936 MB |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                           | 0.151 k allocs: 6.91 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.947 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                           | 0.482 k allocs: 0.189 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                           | 1.08 k allocs: 0.0402 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.471 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.278 k allocs: 0.116 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                           | 1.14 k allocs: 0.0435 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.99 k allocs: 0.145 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.56 k allocs: 0.284 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                           | 0.348 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                           | 14.7 k allocs: 0.68 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                           | 0.0426 M allocs: 2.27 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                           | 0.867 k allocs: 0.0313 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.12 k allocs: 0.0376 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                           | 30.9 k allocs: 1.47 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                           | 0.207 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                           | 0.365 k allocs: 27.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.34 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                                | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

