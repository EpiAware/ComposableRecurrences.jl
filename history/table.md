|                                                                                           | v0.1.0             | 59e7b801b1be65...   | v0.1.0 / 59e7b801b1be65... |
|:------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0667 ± 0.0067 ms | 0.0643 ± 0.0077 ms  | 1.04 ± 0.16                |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 29.9 ± 0.6 μs      | 30.4 ± 0.62 μs      | 0.982 ± 0.028              |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 9.29 ± 1.6 μs      | 9.03 ± 1.5 μs       | 1.03 ± 0.24                |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.232 ± 0.037 ms   | 0.228 ± 0.033 ms    | 1.02 ± 0.22                |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.0537 ± 0.0027 ms | 0.0387 ± 0.0012 ms  | 1.39 ± 0.084               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.338 ± 0.019 ms   | 0.336 ± 0.017 ms    | 1.01 ± 0.076               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 0.0355 ± 0.0012 ms | 0.0326 ± 0.00083 ms | 1.09 ± 0.046               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.038 ± 0.0021 ms  | 0.0369 ± 0.0026 ms  | 1.03 ± 0.092               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 1 ± 0.2 ms         | 1.12 ± 0.032 ms     | 0.892 ± 0.18               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.0631 ± 0.0034 ms | 0.0447 ± 0.0018 ms  | 1.41 ± 0.095               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.627 ± 0.027 ms   | 0.627 ± 0.15 ms     | 1 ± 0.24                   |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 30.3 ± 3.8 μs      | 28.9 ± 0.89 μs      | 1.05 ± 0.14                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0798 ± 0.0048 ms | 0.0911 ± 0.015 ms   | 0.876 ± 0.15               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.9 ± 0.37 ms      | 1.74 ± 0.16 ms      | 1.09 ± 0.24                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.0604 ± 0.0034 ms | 0.034 ± 0.0017 ms   | 1.78 ± 0.13                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 1.39 ± 0.069 ms    | 0.303 ± 0.014 ms    | 4.59 ± 0.31                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 1.31 ± 0.035 ms    | 0.366 ± 0.084 ms    | 3.57 ± 0.83                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0645 ± 0.0045 ms | 0.0415 ± 0.0072 ms  | 1.55 ± 0.29                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.109 ± 0.025 ms   | 0.0576 ± 0.0031 ms  | 1.89 ± 0.45                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.65 ± 0.026 ms    | 0.123 ± 0.0058 ms   | 5.27 ± 0.33                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.668 ± 0.027 ms   | 0.143 ± 0.0042 ms   | 4.69 ± 0.23                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0934 ± 0.017 ms  | 0.065 ± 0.0055 ms   | 1.44 ± 0.29                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.142 ± 0.011 ms   | 0.0828 ± 0.0045 ms  | 1.71 ± 0.16                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.961 ± 0.041 ms   | 0.195 ± 0.007 ms    | 4.94 ± 0.28                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 1.01 ± 0.09 ms     | 0.26 ± 0.014 ms     | 3.87 ± 0.41                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.415 ± 0.058 ms   | 0.426 ± 0.049 ms    | 0.973 ± 0.18               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0627 ± 0.0031 ms | 0.0489 ± 0.0013 ms  | 1.28 ± 0.072               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0555 ± 0.045 ms  | 0.0635 ± 0.017 ms   | 0.874 ± 0.75               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 1.37 ± 0.2 ms      | 1.38 ± 0.061 ms     | 0.99 ± 0.15                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0901 ± 0.0071 ms | 0.0546 ± 0.0017 ms  | 1.65 ± 0.14                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.377 ± 0.024 ms   | 0.359 ± 0.025 ms    | 1.05 ± 0.1                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.057 ± 0.0061 ms  | 0.0544 ± 0.0011 ms  | 1.05 ± 0.11                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0664 ± 0.014 ms  | 0.0525 ± 0.0065 ms  | 1.26 ± 0.31                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 1.13 ± 0.21 ms     | 1.43 ± 0.055 ms     | 0.792 ± 0.15               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0903 ± 0.0047 ms | 0.0694 ± 0.0044 ms  | 1.3 ± 0.11                 |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0706 ± 0.0035 ms | 0.0668 ± 0.0018 ms  | 1.06 ± 0.06                |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 0.0393 ± 0.0034 ms | 0.0396 ± 0.0036 ms  | 0.992 ± 0.12               |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 13.2 ± 2.2 μs      | 10.8 ± 2.4 μs       | 1.22 ± 0.34                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.232 ± 0.011 ms   | 0.212 ± 0.028 ms    | 1.09 ± 0.15                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.0743 ± 0.0049 ms | 0.0567 ± 0.0036 ms  | 1.31 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.439 ± 0.056 ms   | 0.299 ± 0.036 ms    | 1.47 ± 0.26                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0701 ± 0.0057 ms | 0.0627 ± 0.0018 ms  | 1.12 ± 0.096               |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0611 ± 0.011 ms  | 0.0604 ± 0.031 ms   | 1.01 ± 0.56                |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 1.34 ± 0.044 ms    | 1.24 ± 0.021 ms     | 1.08 ± 0.04                |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.135 ± 0.0054 ms  | 0.0901 ± 0.0028 ms  | 1.5 ± 0.076                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.145 ± 0.0095 ms  | 0.135 ± 0.007 ms    | 1.07 ± 0.09                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 28.4 ± 4.2 μs      | 0.0453 ± 0.0013 ms  | 0.627 ± 0.095              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 26.4 ± 1.3 μs      | 24.5 ± 3.4 μs       | 1.08 ± 0.16                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.382 ± 0.081 ms   | 0.383 ± 0.12 ms     | 0.997 ± 0.39               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.0551 ± 0.0026 ms | 0.0556 ± 0.008 ms   | 0.991 ± 0.15               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.266 ± 0.037 ms   | 0.255 ± 0.033 ms    | 1.05 ± 0.2                 |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0759 ± 0.0038 ms | 0.0501 ± 0.0011 ms  | 1.52 ± 0.084               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 31.5 ± 1.8 μs      | 0.103 ± 0.024 ms    | 0.306 ± 0.073              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.799 ± 0.14 ms    | 0.93 ± 0.032 ms     | 0.859 ± 0.15               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0879 ± 0.0056 ms | 0.0601 ± 0.0014 ms  | 1.46 ± 0.099               |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.524 ± 0.026 ms   | 0.351 ± 0.042 ms    | 1.49 ± 0.2                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0891 ± 0.0076 ms | 0.0597 ± 0.0017 ms  | 1.49 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0667 ± 0.0039 ms | 0.0581 ± 0.0035 ms  | 1.15 ± 0.096               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.85 ± 0.21 ms     | 1.48 ± 0.022 ms     | 1.25 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.133 ± 0.012 ms   | 0.0918 ± 0.0041 ms  | 1.45 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 1.26 ± 0.11 ms     | 1.06 ± 0.25 ms      | 1.19 ± 0.3                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.065 ± 0.0078 ms  | 0.0589 ± 0.0041 ms  | 1.1 ± 0.15                 |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.13 ± 0.0081 ms   | 0.129 ± 0.0088 ms   | 1 ± 0.093                  |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 3.43 ± 0.65 ms     | 4.08 ± 0.81 ms      | 0.841 ± 0.23               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.1 ± 0.0078 ms    | 0.0715 ± 0.0088 ms  | 1.4 ± 0.2                  |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0715 ± 0.0022 ms | 0.0627 ± 0.00098 ms | 1.14 ± 0.04                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 2.81 ± 2.6 μs      | 2.29 ± 0.4 μs       | 1.22 ± 1.2                 |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.0526 ± 0.0033 ms | 0.0468 ± 0.0032 ms  | 1.13 ± 0.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 9.86 ± 1.8 μs      | 9.91 ± 1.8 μs       | 0.995 ± 0.25               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.0673 ± 0.0036 ms | 0.0388 ± 0.00059 ms | 1.74 ± 0.097               |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 0.0676 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 15.1 ± 3.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0978 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 3.49 ± 0.071 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.103 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.0887 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 0.0502 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 0.909 ± 0.13 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                     |                    | 0.0399 ± 0.02 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0457 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 1.04 ± 0.011 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.348 ± 0.046 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 2.74 ± 0.45 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 0.0453 ± 0.0011 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward               |                    | 1.06 ± 0.17 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0814 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0653 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.112 ± 0.0057 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 1.12 ± 0.13 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 0.0574 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 1.1 ± 0.12 ms       |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.235 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.141 ± 0.0044 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.452 ± 0.051 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0866 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.067 ± 0.0044 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                 |                    | 0.0994 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 1.88 ± 0.038 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0795 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.301 ± 0.13 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                  |                    | 0.118 ± 0.0033 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 0.0388 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.103 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.309 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 1.28 ± 0.063 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.0804 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                  |                    | 0.342 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.145 ± 0.0067 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 24.3 ± 2.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff          |                    | 31 ± 2.6 μs         |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.186 ± 0.0094 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0638 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0696 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.377 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 0.0398 ± 0.00083 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.665 ± 0.029 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.73 ± 0.013 ms     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 0.0603 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 2.74 ± 0.11 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.727 ± 0.03 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 2.5 ± 0.061 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.173 ± 0.007 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0509 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.131 ± 0.016 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                    |                    | 0.0354 ± 0.0091 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse               |                    | 0.124 ± 0.0071 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 1.37 ± 0.066 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.291 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.109 ± 0.0028 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                    | 0.049 ± 0.0074 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                    | 1.88 ± 0.33 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.119 ± 0.009 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 13.1 ± 0.99 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 0.971 ± 0.21 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 6.83 ± 0.17 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.116 ± 0.0042 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.0917 ± 0.0079 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse       |                    | 0.0681 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.379 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                |                    | 0.157 ± 0.007 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.52 ± 0.039 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 0.0629 ± 0.0016 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                            |                    | 0.337 ± 0.04 ms     |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                 |                    | 0.263 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.0936 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 12.6 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.0536 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0798 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0818 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.913 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.292 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.512 ± 0.04 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.14 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.234 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse     |                    | 0.127 ± 0.0056 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.121 ± 0.0064 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 0.0375 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.352 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0806 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 0.0569 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.684 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 1.94 ± 0.026 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 1.71 ± 0.054 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0832 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.0907 ± 0.0066 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 0.0624 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.103 ± 0.003 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 5.17 ± 0.089 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 5.01 ± 0.11 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 0.0623 ± 0.005 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                          |                    | 1.91 ± 0.049 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.137 ± 0.0015 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0727 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.0853 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward       |                    | 0.249 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 0.037 ± 0.0061 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 0.0348 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.294 ± 0.034 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.101 ± 0.0089 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.0746 ± 0.016 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0539 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.384 ± 0.046 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.369 ± 0.06 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                            |                    | 0.135 ± 0.0019 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 1.13 ± 0.027 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.445 ± 0.077 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.12 ± 0.0052 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 10.9 ± 2 μs         |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                          |                    | 0.143 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 29.5 ± 2.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward     |                    | 1.22 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 0.0474 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.137 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 3.8 ± 0.13 ms       |                            |
| time_to_load                                                                              | 0.241 ± 0.001 s    | 0.358 ± 0.0047 s    | 0.674 ± 0.0093             |

|                                                                                           | v0.1.0                    | 59e7b801b1be65...         | v0.1.0 / 59e7b801b1be65... |
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
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 9.4 k allocs: 0.381 MB    | 1.33 k allocs: 0.183 MB   | 2.09                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 21.4 kB   | 1.89                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 1.53 k allocs: 0.294 MB   | 0.208 k allocs: 0.101 MB  | 2.91                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 5.84 k allocs: 0.353 MB   | 0.154 k allocs: 0.1 MB    | 3.52                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.18 k allocs: 0.0375 MB  | 0.217 k allocs: 28.7 kB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 1.53 k allocs: 0.308 MB   | 0.384 k allocs: 0.14 MB   | 2.21                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 9.06 k allocs: 0.369 MB   | 0.982 k allocs: 0.155 MB  | 2.38                       |
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
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 1.3 k allocs: 0.0436 MB   | 0.921 k allocs: 0.0349 MB | 1.25                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 1.5 k allocs: 0.132 MB    | 1.34 k allocs: 0.118 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 0.198 k allocs: 15.6 kB   | 0.273 k allocs: 20.7 kB   | 0.753                      |
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
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 1.35 k allocs: 0.046 MB   | 0.973 k allocs: 0.0382 MB | 1.2                        |
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
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                           | 0.074 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                           | 0.278 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                           | 24.2 k allocs: 1.25 MB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                           | 0.238 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                           | 0.748 k allocs: 30.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                           | 0.341 k allocs: 14.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                           | 9.8 k allocs: 0.751 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                     |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                           | 0.925 k allocs: 0.118 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                           | 3.38 k allocs: 0.242 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                           | 23.3 k allocs: 1.18 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                           | 0.252 k allocs: 17.1 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward               |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                           | 0.66 k allocs: 0.0361 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                           | 0.348 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                           | 9.56 k allocs: 0.733 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                           | 0.551 k allocs: 24.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                           | 10.1 k allocs: 0.872 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                           | 0.514 k allocs: 0.191 MB  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                           | 1.04 k allocs: 0.0391 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                           | 4.79 k allocs: 0.356 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                           | 0.986 k allocs: 0.0379 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                 |                           | 0.355 k allocs: 16.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                           | 12.9 k allocs: 0.662 MB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                           | 0.886 k allocs: 0.342 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                  |                           | 0.399 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                           | 0.356 k allocs: 26.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                           | 16 k allocs: 0.784 MB     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                           | 0.319 k allocs: 20.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                  |                           | 2.25 k allocs: 0.181 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                           | 0.866 k allocs: 0.302 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                           | 0.158 k allocs: 0.075 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff          |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                           | 1.11 k allocs: 0.0587 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                           | 0.307 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                           | 0.161 k allocs: 0.0339 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                           | 4.64 k allocs: 0.293 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                           | 0.169 k allocs: 12.8 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                           | 4.93 k allocs: 0.522 MB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                           | 0.722 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                           | 0.181 k allocs: 8.3 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                           | 5.97 k allocs: 0.467 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                           | 21.6 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                           | 0.689 k allocs: 0.036 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                           | 0.802 k allocs: 0.298 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                    |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse               |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                           | 0.056 k allocs: 11.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                           | 0.0496 M allocs: 2.59 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                           | 1.1 k allocs: 0.0456 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                           | 0.429 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse       |                           | 0.36 k allocs: 19.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                           | 3.1 k allocs: 0.275 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                |                           | 1.1 k allocs: 0.0359 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                           | 4.69 k allocs: 0.349 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                           | 0.738 k allocs: 31 kB     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                            |                           | 2.25 k allocs: 0.181 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                 |                           | 2.69 k allocs: 0.196 MB   |                            |
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
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse     |                           | 0.97 k allocs: 0.0321 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                           | 0.921 k allocs: 0.0335 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                           | 0.135 k allocs: 13.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                           | 0.282 k allocs: 0.135 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                           | 0.371 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                           | 6.08 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                           | 22.4 k allocs: 1.06 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                           | 0.716 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                           | 0.479 k allocs: 30.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                           | 15.8 k allocs: 0.786 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                           | 0.041 M allocs: 2.14 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                           | 0.245 k allocs: 18 kB     |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                          |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                           | 0.341 k allocs: 19.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                           | 0.4 k allocs: 24.8 kB     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                           | 0.572 k allocs: 23.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward       |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                           | 0.237 k allocs: 0.0936 MB |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                           | 0.151 k allocs: 6.91 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                           | 0.947 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                           | 0.482 k allocs: 0.189 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                           | 0.471 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                           | 0.278 k allocs: 0.116 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                           | 3.56 k allocs: 0.284 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                           | 3.99 k allocs: 0.145 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                            |                           | 0.347 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                           | 14.7 k allocs: 0.68 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                           | 0.859 k allocs: 31.7 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                          |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                           | 0.207 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward     |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                           | 0.366 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                           | 1.34 k allocs: 0.118 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                              | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

