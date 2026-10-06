|                                                                                           | v0.1.0             | d9bbafc1c1def8...  | v0.1.0 / d9bbafc1c1def8... |
|:------------------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0462 ± 0.0063 ms | 0.0469 ± 0.0069 ms | 0.985 ± 0.2                |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 20.4 ± 1.4 μs      | 19.6 ± 0.97 μs     | 1.04 ± 0.09                |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 3.19 ± 1.2 μs      | 6.96 ± 1.2 μs      | 0.458 ± 0.19               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.142 ± 0.027 ms   | 0.133 ± 0.035 ms   | 1.07 ± 0.35                |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 30.1 ± 3.3 μs      | 22.9 ± 2.2 μs      | 1.32 ± 0.19                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.239 ± 0.022 ms   | 0.231 ± 0.0095 ms  | 1.03 ± 0.1                 |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 23.3 ± 0.88 μs     | 21.2 ± 0.72 μs     | 1.1 ± 0.056                |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 29.4 ± 3.3 μs      | 30.5 ± 2.7 μs      | 0.966 ± 0.14               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 0.72 ± 0.21 ms     | 0.685 ± 0.037 ms   | 1.05 ± 0.31                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 31 ± 1.3 μs        | 23.3 ± 0.83 μs     | 1.33 ± 0.073               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.452 ± 0.025 ms   | 0.431 ± 0.026 ms   | 1.05 ± 0.087               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 20.2 ± 2.1 μs      | 17.1 ± 0.84 μs     | 1.18 ± 0.14                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.061 ± 0.0065 ms  | 0.0593 ± 0.0054 ms | 1.03 ± 0.14                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.2 ± 0.29 ms      | 1.13 ± 0.15 ms     | 1.07 ± 0.29                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 30.6 ± 2.7 μs      | 20.1 ± 2.7 μs      | 1.52 ± 0.24                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 0.857 ± 0.055 ms   | 0.151 ± 0.0089 ms  | 5.69 ± 0.5                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 0.692 ± 0.062 ms   | 0.239 ± 0.0079 ms  | 2.9 ± 0.28                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0434 ± 0.0035 ms | 26.1 ± 4.1 μs      | 1.66 ± 0.29                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.0669 ± 0.0057 ms | 30.6 ± 1.9 μs      | 2.19 ± 0.23                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.393 ± 0.077 ms   | 0.0513 ± 0.0095 ms | 7.66 ± 2.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.387 ± 0.057 ms   | 0.0876 ± 0.029 ms  | 4.41 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0535 ± 0.012 ms  | 0.0431 ± 0.0045 ms | 1.24 ± 0.31                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.0755 ± 0.007 ms  | 0.0495 ± 0.0059 ms | 1.53 ± 0.23                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.548 ± 0.043 ms   | 0.139 ± 0.035 ms   | 3.95 ± 1                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 0.508 ± 0.037 ms   | 0.178 ± 0.042 ms   | 2.85 ± 0.71                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.273 ± 0.012 ms   | 0.249 ± 0.013 ms   | 1.1 ± 0.077                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0418 ± 0.0058 ms | 25.9 ± 1.4 μs      | 1.61 ± 0.24                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0427 ± 0.007 ms  | 0.0434 ± 0.0053 ms | 0.982 ± 0.2                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 0.696 ± 0.21 ms    | 0.8 ± 0.044 ms     | 0.869 ± 0.27               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0401 ± 0.0011 ms | 28.5 ± 2.4 μs      | 1.41 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.264 ± 0.019 ms   | 0.232 ± 0.014 ms   | 1.14 ± 0.11                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0346 ± 0.0011 ms | 0.0332 ± 0.0012 ms | 1.04 ± 0.05                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0401 ± 0.0091 ms | 0.0345 ± 0.0057 ms | 1.16 ± 0.33                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 0.77 ± 0.14 ms     | 0.579 ± 0.18 ms    | 1.33 ± 0.49                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0472 ± 0.004 ms  | 0.0351 ± 0.0011 ms | 1.35 ± 0.12                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0492 ± 0.0019 ms | 0.0474 ± 0.0015 ms | 1.04 ± 0.051               |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 25.3 ± 2.1 μs      | 25.8 ± 2.4 μs      | 0.983 ± 0.12               |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 8.03 ± 1.4 μs      | 7.51 ± 1.9 μs      | 1.07 ± 0.33                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.155 ± 0.022 ms   | 0.129 ± 0.017 ms   | 1.2 ± 0.23                 |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 29.9 ± 1.2 μs      | 30.4 ± 2.8 μs      | 0.983 ± 0.097              |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.286 ± 0.013 ms   | 0.223 ± 0.015 ms   | 1.28 ± 0.1                 |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0424 ± 0.0037 ms | 0.0384 ± 0.0013 ms | 1.1 ± 0.1                  |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0371 ± 0.0058 ms | 0.042 ± 0.0072 ms  | 0.884 ± 0.2                |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 0.807 ± 0.1 ms     | 0.701 ± 0.032 ms   | 1.15 ± 0.16                |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.0654 ± 0.0036 ms | 0.0437 ± 0.0012 ms | 1.5 ± 0.093                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.0943 ± 0.0056 ms | 0.0913 ± 0.0052 ms | 1.03 ± 0.085               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 19.6 ± 2.7 μs      | 22.7 ± 0.92 μs     | 0.862 ± 0.12               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 19.7 ± 2.6 μs      | 22.3 ± 16 μs       | 0.882 ± 0.64               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.246 ± 0.063 ms   | 0.235 ± 0.017 ms   | 1.05 ± 0.28                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 26.1 ± 2 μs        | 23.9 ± 1 μs        | 1.09 ± 0.096               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.178 ± 0.027 ms   | 0.163 ± 0.024 ms   | 1.09 ± 0.24                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.043 ± 0.0017 ms  | 28.9 ± 1.9 μs      | 1.49 ± 0.12                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 26.1 ± 2.3 μs      | 22.1 ± 1.6 μs      | 1.18 ± 0.13                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.477 ± 0.059 ms   | 0.461 ± 0.11 ms    | 1.04 ± 0.28                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0452 ± 0.0043 ms | 30.4 ± 4.5 μs      | 1.49 ± 0.26                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.355 ± 0.029 ms   | 0.258 ± 0.013 ms   | 1.38 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0523 ± 0.0016 ms | 0.0366 ± 0.0018 ms | 1.43 ± 0.084               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0436 ± 0.003 ms  | 0.0351 ± 0.0044 ms | 1.24 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.02 ± 0.036 ms    | 0.92 ± 0.014 ms    | 1.1 ± 0.043                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.0666 ± 0.0047 ms | 0.0443 ± 0.0012 ms | 1.5 ± 0.11                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 0.919 ± 0.056 ms   | 0.802 ± 0.1 ms     | 1.15 ± 0.16                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.039 ± 0.0025 ms  | 0.0317 ± 0.0029 ms | 1.23 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.0977 ± 0.0075 ms | 0.086 ± 0.0063 ms  | 1.14 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 2.09 ± 0.4 ms      | 2.04 ± 0.44 ms     | 1.02 ± 0.3                 |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0475 ± 0.0053 ms | 0.0349 ± 0.0023 ms | 1.36 ± 0.18                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0383 ± 0.001 ms  | 0.034 ± 0.001 ms   | 1.13 ± 0.045               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 1.72 ± 0.79 μs     | 1.85 ± 0.46 μs     | 0.929 ± 0.49               |
| Evaluation/Matrix overview T200_L20_S3                                                    | 28.8 ± 2.8 μs      | 21.3 ± 10 μs       | 1.36 ± 0.67                |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 5.85 ± 1.3 μs      | 6.27 ± 1.4 μs      | 0.933 ± 0.29               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.0384 ± 0.0031 ms | 22.5 ± 0.85 μs     | 1.71 ± 0.15                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 30 ± 1.8 μs        |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 5.13 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0334 ± 0.0034 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 1.65 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0429 ± 0.0056 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.039 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 22.5 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 0.655 ± 0.027 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0323 ± 0.0037 ms |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.534 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.299 ± 0.014 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 1.29 ± 0.085 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 29.2 ± 0.99 μs     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0397 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0452 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.0456 ± 0.0015 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 0.664 ± 0.042 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 27.9 ± 2.7 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 0.789 ± 0.064 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.0862 ± 0.0054 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.0705 ± 0.0038 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.354 ± 0.043 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0404 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.0337 ± 0.0063 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 0.954 ± 0.046 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0494 ± 0.011 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.114 ± 0.013 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 27.8 ± 6.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.0465 ± 0.0025 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.232 ± 0.028 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 0.642 ± 0.2 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.0461 ± 0.0011 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.0839 ± 0.0095 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 19.7 ± 2.7 μs      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.0583 ± 0.0069 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0512 ± 0.0076 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0434 ± 0.0031 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.166 ± 0.078 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 23.6 ± 0.89 μs     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.461 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.383 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 25.2 ± 1.6 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 1.4 ± 0.13 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.451 ± 0.028 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 0.999 ± 0.035 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.0891 ± 0.0029 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0338 ± 0.0019 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.0842 ± 0.0044 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 0.636 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.188 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.051 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.0612 ± 0.0034 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 7.37 ± 1.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 0.61 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 2.55 ± 0.17 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.0539 ± 0.0025 ms |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.0452 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.249 ± 0.012 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.323 ± 0.024 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 30.5 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.0404 ± 0.0036 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 8.16 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.0328 ± 0.0012 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0533 ± 0.0031 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0488 ± 0.0055 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.527 ± 0.037 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.148 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.271 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0464 ± 0.027 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.0719 ± 0.0098 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.0626 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 19.2 ± 0.94 μs     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.037 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0415 ± 0.0029 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 30.8 ± 4.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.475 ± 0.044 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 0.918 ± 0.11 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 0.747 ± 0.042 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0389 ± 0.0016 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.0634 ± 0.0052 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 25.8 ± 1.5 μs      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.0564 ± 0.0024 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 0.984 ± 0.17 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 2.1 ± 0.039 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 26.6 ± 1.5 μs      |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0378 ± 0.0011 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0404 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.0388 ± 0.0038 ms |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 26.2 ± 4 μs        |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 20.9 ± 1.8 μs      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.178 ± 0.048 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.0624 ± 0.0037 ms |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.0478 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0369 ± 0.023 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.295 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.129 ± 0.053 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 0.663 ± 0.031 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.296 ± 0.06 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.0593 ± 0.0025 ms |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 6.46 ± 0.73 μs     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 17.7 ± 1 μs        |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 23.2 ± 1.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.0917 ± 0.0066 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 2.2 ± 0.093 ms     |                            |
| time_to_load                                                                              | 0.142 ± 0.00033 s  | 0.224 ± 0.0022 s   | 0.635 ± 0.0064             |

|                                                                                           | v0.1.0                    | d9bbafc1c1def8...         | v0.1.0 / d9bbafc1c1def8... |
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

