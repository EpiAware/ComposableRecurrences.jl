|                                                                                           | v0.1.0             | 144d9f2d913358...   | v0.1.0 / 144d9f2d913358... |
|:------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0671 ± 0.0081 ms | 0.067 ± 0.0059 ms   | 1 ± 0.15                   |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 30.2 ± 0.59 μs     | 0.0335 ± 0.0034 ms  | 0.901 ± 0.094              |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 8.9 ± 2 μs         | 9.31 ± 1.7 μs       | 0.956 ± 0.27               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.233 ± 0.04 ms    | 0.172 ± 0.037 ms    | 1.35 ± 0.37                |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.0511 ± 0.0036 ms | 0.0442 ± 0.0077 ms  | 1.16 ± 0.22                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.332 ± 0.049 ms   | 0.335 ± 0.015 ms    | 0.991 ± 0.15               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 0.0365 ± 0.0011 ms | 0.0364 ± 0.00091 ms | 1 ± 0.038                  |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.0384 ± 0.0031 ms | 0.0427 ± 0.0064 ms  | 0.899 ± 0.15               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 1 ± 0.2 ms         | 1.1 ± 0.11 ms       | 0.907 ± 0.2                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.0632 ± 0.0024 ms | 0.044 ± 0.0019 ms   | 1.44 ± 0.083               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.628 ± 0.04 ms    | 0.627 ± 0.03 ms     | 1 ± 0.079                  |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 30.8 ± 3.7 μs      | 29.1 ± 0.72 μs      | 1.06 ± 0.13                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0782 ± 0.0068 ms | 0.0726 ± 0.01 ms    | 1.08 ± 0.18                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.84 ± 0.39 ms     | 1.61 ± 0.45 ms      | 1.14 ± 0.41                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.0604 ± 0.0036 ms | 0.0342 ± 0.0032 ms  | 1.76 ± 0.2                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 1.39 ± 0.089 ms    | 0.282 ± 0.013 ms    | 4.93 ± 0.39                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 1.29 ± 0.037 ms    | 0.416 ± 0.092 ms    | 3.11 ± 0.69                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0633 ± 0.0042 ms | 0.0425 ± 0.0078 ms  | 1.49 ± 0.29                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.0908 ± 0.025 ms  | 0.0585 ± 0.0032 ms  | 1.55 ± 0.44                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.665 ± 0.023 ms   | 0.0858 ± 0.014 ms   | 7.75 ± 1.3                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.653 ± 0.02 ms    | 0.148 ± 0.0043 ms   | 4.41 ± 0.19                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0813 ± 0.017 ms  | 0.0655 ± 0.005 ms   | 1.24 ± 0.28                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.147 ± 0.013 ms   | 0.084 ± 0.0046 ms   | 1.75 ± 0.18                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.956 ± 0.019 ms   | 0.247 ± 0.012 ms    | 3.87 ± 0.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 1 ± 0.11 ms        | 0.321 ± 0.015 ms    | 3.13 ± 0.36                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.417 ± 0.063 ms   | 0.397 ± 0.049 ms    | 1.05 ± 0.21                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0641 ± 0.0032 ms | 0.0448 ± 0.00094 ms | 1.43 ± 0.077               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0543 ± 0.045 ms  | 0.107 ± 0.013 ms    | 0.505 ± 0.43               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 1.36 ± 0.2 ms      | 1.26 ± 0.031 ms     | 1.09 ± 0.16                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0908 ± 0.0046 ms | 0.0533 ± 0.0016 ms  | 1.71 ± 0.099               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.37 ± 0.025 ms    | 0.345 ± 0.033 ms    | 1.07 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0559 ± 0.003 ms  | 0.0594 ± 0.0046 ms  | 0.943 ± 0.088              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0661 ± 0.012 ms  | 0.0472 ± 0.0027 ms  | 1.4 ± 0.27                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 1.11 ± 0.18 ms     | 1.29 ± 0.028 ms     | 0.862 ± 0.14               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0907 ± 0.0031 ms | 0.0683 ± 0.002 ms   | 1.33 ± 0.06                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0703 ± 0.0041 ms | 0.0675 ± 0.0016 ms  | 1.04 ± 0.066               |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 0.0396 ± 0.003 ms  | 0.0424 ± 0.0038 ms  | 0.933 ± 0.11               |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 12.9 ± 1.9 μs      | 12 ± 1.6 μs         | 1.07 ± 0.21                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.235 ± 0.01 ms    | 0.203 ± 0.029 ms    | 1.16 ± 0.17                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.0722 ± 0.0043 ms | 0.0571 ± 0.0035 ms  | 1.26 ± 0.11                |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.432 ± 0.051 ms   | 0.323 ± 0.037 ms    | 1.33 ± 0.22                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0692 ± 0.0049 ms | 0.0816 ± 0.0028 ms  | 0.848 ± 0.067              |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0606 ± 0.0091 ms | 0.0627 ± 0.035 ms   | 0.967 ± 0.56               |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 1.33 ± 0.047 ms    | 1.24 ± 0.058 ms     | 1.07 ± 0.063               |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.138 ± 0.0052 ms  | 0.0904 ± 0.0024 ms  | 1.53 ± 0.071               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.143 ± 0.0093 ms  | 0.133 ± 0.016 ms    | 1.07 ± 0.15                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 28 ± 4.4 μs        | 0.0427 ± 0.001 ms   | 0.656 ± 0.1                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 26.5 ± 1.5 μs      | 29.3 ± 2.9 μs       | 0.905 ± 0.1                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.384 ± 0.081 ms   | 0.377 ± 0.016 ms    | 1.02 ± 0.22                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.056 ± 0.0024 ms  | 0.0524 ± 0.0055 ms  | 1.07 ± 0.12                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.265 ± 0.041 ms   | 0.244 ± 0.028 ms    | 1.09 ± 0.21                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0777 ± 0.0039 ms | 0.0472 ± 0.002 ms   | 1.65 ± 0.11                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 0.0317 ± 0.0021 ms | 0.0325 ± 0.0018 ms  | 0.977 ± 0.085              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.786 ± 0.13 ms    | 0.76 ± 0.12 ms      | 1.04 ± 0.24                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0907 ± 0.0084 ms | 0.0629 ± 0.0025 ms  | 1.44 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.526 ± 0.03 ms    | 0.386 ± 0.046 ms    | 1.36 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0896 ± 0.0063 ms | 0.0677 ± 0.0033 ms  | 1.32 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0678 ± 0.0032 ms | 0.0505 ± 0.0096 ms  | 1.34 ± 0.26                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.83 ± 0.28 ms     | 1.59 ± 0.028 ms     | 1.15 ± 0.17                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.131 ± 0.0036 ms  | 0.0938 ± 0.006 ms   | 1.4 ± 0.097                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 1.27 ± 0.1 ms      | 1.2 ± 0.1 ms        | 1.05 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.0641 ± 0.0075 ms | 0.0565 ± 0.0025 ms  | 1.13 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.128 ± 0.0087 ms  | 0.125 ± 0.012 ms    | 1.03 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 3.44 ± 0.71 ms     | 3.64 ± 0.96 ms      | 0.946 ± 0.32               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0969 ± 0.0052 ms | 0.0736 ± 0.01 ms    | 1.32 ± 0.19                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.072 ± 0.0018 ms  | 0.0625 ± 0.0009 ms  | 1.15 ± 0.033               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 2.81 ± 2.6 μs      | 2.3 ± 0.44 μs       | 1.22 ± 1.2                 |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.0521 ± 0.0032 ms | 0.0459 ± 0.003 ms   | 1.13 ± 0.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 9.84 ± 1.7 μs      | 9.95 ± 1.8 μs       | 0.989 ± 0.25               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.067 ± 0.0034 ms  | 0.0392 ± 0.012 ms   | 1.71 ± 0.52                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 0.0622 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 7.25 ± 0.43 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0573 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 3.27 ± 0.053 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0577 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.0899 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 0.0497 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 1.02 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0446 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.963 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.414 ± 0.083 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 3.02 ± 0.6 ms       |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 0.0514 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0811 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0667 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.0969 ± 0.0071 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 0.957 ± 0.025 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 0.0558 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 1.08 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.129 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.141 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.501 ± 0.055 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0867 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.0649 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 1.66 ± 0.059 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0825 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.197 ± 0.033 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 0.04 ± 0.0065 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.0989 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.334 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 1.2 ± 0.18 ms       |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.106 ± 0.0023 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.145 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 24.9 ± 1.9 μs       |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.11 ± 0.02 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0648 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0697 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.406 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 0.0411 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.653 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.705 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 0.0408 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 2.55 ± 0.2 ms       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.707 ± 0.058 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 1.78 ± 0.075 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.172 ± 0.0062 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0566 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.116 ± 0.0042 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 1.29 ± 0.017 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.276 ± 0.045 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.109 ± 0.0088 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.111 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 11 ± 2 μs           |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 1.08 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 4.7 ± 0.13 ms       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.112 ± 0.0077 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.0899 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.368 ± 0.022 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.455 ± 0.054 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 0.0627 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.083 ± 0.0026 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 11.1 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.0573 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0711 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0686 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.845 ± 0.079 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.263 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.415 ± 0.044 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0591 ± 0.046 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.133 ± 0.0072 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.11 ± 0.0024 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 0.0353 ± 0.00097 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.0899 ± 0.042 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0695 ± 0.0061 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 0.058 ± 0.0039 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.672 ± 0.073 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 1.64 ± 0.049 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 1.44 ± 0.036 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0836 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.0957 ± 0.0077 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 0.0598 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.111 ± 0.0023 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 1.47 ± 0.21 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 3.32 ± 0.81 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 0.0459 ± 0.0071 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0739 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0648 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.0807 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 0.0442 ± 0.008 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 0.0355 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.297 ± 0.016 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.0971 ± 0.0032 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.0742 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0571 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.421 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.227 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 1.15 ± 0.053 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.441 ± 0.078 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.128 ± 0.0058 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 10.3 ± 0.61 μs      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 29.5 ± 0.82 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 0.0331 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.134 ± 0.0073 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 3.88 ± 0.052 ms     |                            |
| time_to_load                                                                              | 0.235 ± 0.0015 s   | 0.348 ± 0.0017 s    | 0.676 ± 0.0053             |

|                                                                                           | v0.1.0                    | 144d9f2d913358...         | v0.1.0 / 144d9f2d913358... |
|:------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.631 k allocs: 0.0348 MB | 0.631 k allocs: 0.0348 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 0.147 k allocs: 7.97 kB   | 0.152 k allocs: 7.52 kB   | 1.06                       |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                              | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 2.99 k allocs: 0.268 MB   | 2.99 k allocs: 0.268 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 0.15 k allocs: 11.9 kB    | 0.165 k allocs: 11.8 kB   | 1.01                       |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 4.7 k allocs: 0.506 MB    | 4.7 k allocs: 0.506 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 0.122 k allocs: 12.5 kB   | 0.134 k allocs: 10.9 kB   | 1.15                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 3.26 k allocs: 0.495 MB   | 0.557 k allocs: 0.164 MB  | 3.02                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 9.4 k allocs: 0.381 MB    | 1.33 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 21.4 kB   | 1.89                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 1.53 k allocs: 0.294 MB   | 0.208 k allocs: 0.101 MB  | 2.91                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 5.84 k allocs: 0.353 MB   | 0.154 k allocs: 0.1 MB    | 3.52                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.18 k allocs: 0.0375 MB  | 0.217 k allocs: 28.7 kB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 1.53 k allocs: 0.308 MB   | 0.384 k allocs: 0.14 MB   | 2.21                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 9.06 k allocs: 0.369 MB   | 0.99 k allocs: 0.156 MB   | 2.37                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 3.15 k allocs: 0.279 MB   | 2.79 k allocs: 0.249 MB   | 1.12                       |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.246 k allocs: 20 kB     | 0.206 k allocs: 15.1 kB   | 1.33                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.303 k allocs: 0.154 MB  | 0.275 k allocs: 0.135 MB  | 1.14                       |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 17.4 k allocs: 0.834 MB   | 15.7 k allocs: 0.77 MB    | 1.08                       |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.691 k allocs: 26.1 kB   | 0.653 k allocs: 26.6 kB   | 0.981                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 3.18 k allocs: 0.262 MB   | 2.91 k allocs: 0.239 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.6 kB   | 0.918                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.29 k allocs: 0.13 MB    | 0.272 k allocs: 0.116 MB  | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 15.7 k allocs: 0.716 MB   | 14.5 k allocs: 0.667 MB   | 1.07                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 1.15 k allocs: 0.0397 MB  | 0.841 k allocs: 0.0324 MB | 1.23                       |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.836 k allocs: 0.0416 MB | 0.792 k allocs: 0.0396 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 0.176 k allocs: 7.66 kB   | 0.217 k allocs: 9.72 kB   | 0.788                      |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 0.07 k allocs: 14.2 kB    | 0.066 k allocs: 13.4 kB   | 1.06                       |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 4.09 k allocs: 0.137 MB   | 3.77 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.809 k allocs: 25.5 kB   | 0.679 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 3.93 k allocs: 0.263 MB   | 3.31 k allocs: 0.237 MB   | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.336 k allocs: 21.5 kB   | 0.39 k allocs: 21 kB      | 1.02                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.287 k allocs: 0.125 MB  | 0.287 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 15.9 k allocs: 0.718 MB   | 12.3 k allocs: 0.625 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 1.3 k allocs: 0.0436 MB   | 0.929 k allocs: 0.0353 MB | 1.24                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 1.5 k allocs: 0.132 MB    | 1.34 k allocs: 0.118 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 0.198 k allocs: 15.6 kB   | 0.27 k allocs: 18.9 kB    | 0.825                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 0.174 k allocs: 0.0836 MB | 0.158 k allocs: 0.075 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 5.38 k allocs: 0.321 MB   | 4.64 k allocs: 0.293 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.39 k allocs: 16.1 kB    | 0.472 k allocs: 24.9 kB   | 0.648                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 2.74 k allocs: 0.209 MB   | 2.51 k allocs: 0.19 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.382 k allocs: 21.7 kB   | 0.227 k allocs: 14.2 kB   | 1.52                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 0.237 k allocs: 0.105 MB  | 0.217 k allocs: 0.0927 MB | 1.13                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 12.3 k allocs: 0.571 MB   | 11.2 k allocs: 0.529 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 1.02 k allocs: 0.0353 MB  | 0.717 k allocs: 28.2 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 4.33 k allocs: 0.33 MB    | 3.48 k allocs: 0.276 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.382 k allocs: 24.6 kB   | 0.363 k allocs: 22.8 kB   | 1.08                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.338 k allocs: 0.149 MB  | 0.314 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.737 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 1.35 k allocs: 0.046 MB   | 0.981 k allocs: 0.0386 MB | 1.19                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 10.7 k allocs: 0.917 MB   | 9.83 k allocs: 0.844 MB   | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.383 k allocs: 25 kB     | 0.274 k allocs: 21.7 kB   | 1.15                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.886 k allocs: 0.384 MB  | 0.818 k allocs: 0.338 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 0.0515 M allocs: 2.58 MB  | 0.0474 M allocs: 2.42 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.863 k allocs: 0.033 MB  | 0.826 k allocs: 0.0336 MB | 0.981                      |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.091 k allocs: 0.0452 MB | 0.075 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.04 k allocs: 0.0395 MB  | 0.036 k allocs: 0.0384 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 0.034 k allocs: 7.98 kB   | 0.032 k allocs: 7.77 kB   | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.072 k allocs: 0.0443 MB | 0.056 k allocs: 0.042 MB  | 1.06                       |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                           | 0.627 k allocs: 23.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                           | 0.074 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                           | 0.278 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                           | 24.2 k allocs: 1.25 MB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                           | 0.238 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                           | 0.748 k allocs: 30.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                           | 0.341 k allocs: 14.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                           | 9.8 k allocs: 0.751 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                           | 0.933 k allocs: 0.119 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                           | 4.16 k allocs: 0.358 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                           | 23.3 k allocs: 1.18 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                           | 0.252 k allocs: 17.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                           | 0.66 k allocs: 0.0361 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                           | 0.394 k allocs: 0.0323 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                           | 9.56 k allocs: 0.733 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                           | 0.541 k allocs: 24 kB     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                           | 10.1 k allocs: 0.872 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                           | 0.514 k allocs: 0.191 MB  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                           | 1.04 k allocs: 0.0394 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                           | 4.79 k allocs: 0.356 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                           | 0.986 k allocs: 0.0379 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                           | 14.4 k allocs: 0.88 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                           | 0.835 k allocs: 0.341 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                           | 0.356 k allocs: 26.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                           | 16 k allocs: 0.784 MB     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                           | 0.319 k allocs: 20.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                           | 0.866 k allocs: 0.302 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                           | 0.158 k allocs: 0.075 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                           | 1.11 k allocs: 0.0587 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                           | 0.402 k allocs: 0.218 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                           | 0.159 k allocs: 0.0336 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                           | 4.64 k allocs: 0.293 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                           | 0.167 k allocs: 12.6 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                           | 4.93 k allocs: 0.522 MB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                           | 0.726 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                           | 0.181 k allocs: 8.3 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                           | 5.97 k allocs: 0.467 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                           | 21.6 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                           | 0.689 k allocs: 0.036 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                           | 0.802 k allocs: 0.298 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                           | 1.27 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                           | 0.816 k allocs: 0.0709 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                           | 0.056 k allocs: 11.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                           | 0.0496 M allocs: 2.58 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                           | 1.11 k allocs: 0.046 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                           | 0.429 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                           | 3.1 k allocs: 0.275 MB    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                           | 4.69 k allocs: 0.349 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                           | 0.738 k allocs: 31 kB     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                           | 0.659 k allocs: 25.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                           | 0.321 k allocs: 19.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                           | 0.82 k allocs: 0.0411 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                           | 0.499 k allocs: 0.176 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                           | 2.83 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                           | 2.89 k allocs: 0.257 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                           | 0.338 k allocs: 0.136 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                           | 1.18 k allocs: 0.0635 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                           | 0.929 k allocs: 0.0338 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                           | 0.133 k allocs: 12.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                           | 0.282 k allocs: 0.135 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                           | 0.371 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                           | 0.644 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                           | 6.08 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                           | 22.4 k allocs: 1.07 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                           | 0.716 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                           | 0.487 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                           | 0.479 k allocs: 31 kB     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                           | 15.8 k allocs: 0.786 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                           | 0.041 M allocs: 2.14 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                           | 0.245 k allocs: 18 kB     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                           | 0.341 k allocs: 19.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                           | 0.4 k allocs: 24.8 kB     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                           | 0.562 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                           | 0.237 k allocs: 0.0936 MB |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                           | 0.149 k allocs: 6.66 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                           | 0.945 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                           | 0.482 k allocs: 0.189 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                           | 0.471 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                           | 0.278 k allocs: 0.116 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                           | 3.56 k allocs: 0.284 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                           | 3.99 k allocs: 0.145 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                           | 14.7 k allocs: 0.68 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                           | 0.901 k allocs: 0.0364 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                           | 0.207 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                           | 0.366 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                           | 1.34 k allocs: 0.118 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                              | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

