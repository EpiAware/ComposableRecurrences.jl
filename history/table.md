|                                                                                           | v0.1.0             | f782f1e2351caf...   | v0.1.0 / f782f1e2351caf... |
|:------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0665 ± 0.0054 ms | 0.0666 ± 0.0068 ms  | 0.999 ± 0.13               |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 30.1 ± 0.55 μs     | 0.0321 ± 0.0033 ms  | 0.94 ± 0.099               |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 8.91 ± 1.5 μs      | 9.42 ± 1.6 μs       | 0.946 ± 0.23               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.235 ± 0.04 ms    | 0.196 ± 0.035 ms    | 1.2 ± 0.3                  |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.0511 ± 0.0026 ms | 0.0437 ± 0.0059 ms  | 1.17 ± 0.17                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.338 ± 0.018 ms   | 0.344 ± 0.017 ms    | 0.983 ± 0.071              |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 0.036 ± 0.00073 ms | 0.0341 ± 0.00081 ms | 1.06 ± 0.033               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.0364 ± 0.0021 ms | 0.0388 ± 0.0041 ms  | 0.94 ± 0.11                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 1.03 ± 0.21 ms     | 1.16 ± 0.048 ms     | 0.881 ± 0.18               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.0623 ± 0.0022 ms | 0.0433 ± 0.0012 ms  | 1.44 ± 0.064               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.632 ± 0.039 ms   | 0.627 ± 0.038 ms    | 1.01 ± 0.088               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 30.5 ± 0.87 μs     | 28.1 ± 0.69 μs      | 1.09 ± 0.041               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0773 ± 0.0056 ms | 0.0747 ± 0.011 ms   | 1.04 ± 0.17                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.86 ± 0.43 ms     | 1.76 ± 0.45 ms      | 1.05 ± 0.36                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.0595 ± 0.0037 ms | 0.037 ± 0.0032 ms   | 1.61 ± 0.17                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 1.4 ± 0.084 ms     | 0.292 ± 0.015 ms    | 4.82 ± 0.38                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 1.31 ± 0.033 ms    | 0.359 ± 0.088 ms    | 3.66 ± 0.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0634 ± 0.0047 ms | 0.0402 ± 0.0078 ms  | 1.58 ± 0.33                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.106 ± 0.023 ms   | 0.0592 ± 0.0034 ms  | 1.8 ± 0.4                  |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.651 ± 0.022 ms   | 0.0861 ± 0.016 ms   | 7.56 ± 1.4                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.661 ± 0.021 ms   | 0.142 ± 0.0057 ms   | 4.64 ± 0.24                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0823 ± 0.016 ms  | 0.0648 ± 0.005 ms   | 1.27 ± 0.27                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.14 ± 0.011 ms    | 0.0866 ± 0.0051 ms  | 1.61 ± 0.16                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.928 ± 0.016 ms   | 0.244 ± 0.048 ms    | 3.81 ± 0.75                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 1 ± 0.11 ms        | 0.331 ± 0.017 ms    | 3.03 ± 0.35                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.414 ± 0.059 ms   | 0.402 ± 0.049 ms    | 1.03 ± 0.19                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0622 ± 0.0026 ms | 0.0438 ± 0.0012 ms  | 1.42 ± 0.07                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0561 ± 0.045 ms  | 0.063 ± 0.0052 ms   | 0.891 ± 0.72               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 1.38 ± 0.31 ms     | 1.36 ± 0.051 ms     | 1.01 ± 0.23                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0902 ± 0.0076 ms | 0.0546 ± 0.0021 ms  | 1.65 ± 0.15                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.377 ± 0.027 ms   | 0.34 ± 0.028 ms     | 1.11 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0565 ± 0.0034 ms | 0.0536 ± 0.0017 ms  | 1.05 ± 0.072               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0669 ± 0.014 ms  | 0.0491 ± 0.0065 ms  | 1.36 ± 0.33                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 1.14 ± 0.18 ms     | 1.31 ± 0.21 ms      | 0.87 ± 0.2                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0926 ± 0.0084 ms | 0.0709 ± 0.0027 ms  | 1.31 ± 0.13                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0704 ± 0.0038 ms | 0.0683 ± 0.0015 ms  | 1.03 ± 0.061               |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 0.0401 ± 0.0033 ms | 0.0413 ± 0.0034 ms  | 0.97 ± 0.11                |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 13.5 ± 1.9 μs      | 11.7 ± 3 μs         | 1.15 ± 0.34                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.241 ± 0.0097 ms  | 0.212 ± 0.03 ms     | 1.14 ± 0.17                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.072 ± 0.0043 ms  | 0.0561 ± 0.0034 ms  | 1.28 ± 0.11                |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.436 ± 0.051 ms   | 0.334 ± 0.038 ms    | 1.3 ± 0.21                 |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0709 ± 0.007 ms  | 0.0847 ± 0.0026 ms  | 0.837 ± 0.087              |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0612 ± 0.01 ms   | 0.0947 ± 0.043 ms   | 0.646 ± 0.31               |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 1.38 ± 0.19 ms     | 1.26 ± 0.021 ms     | 1.09 ± 0.15                |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.139 ± 0.0056 ms  | 0.0915 ± 0.0031 ms  | 1.52 ± 0.08                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.14 ± 0.0075 ms   | 0.132 ± 0.0085 ms   | 1.06 ± 0.089               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 29.2 ± 4.2 μs      | 0.0415 ± 0.0011 ms  | 0.704 ± 0.1                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 26.4 ± 1.4 μs      | 27.8 ± 3.1 μs       | 0.95 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.383 ± 0.08 ms    | 0.403 ± 0.031 ms    | 0.951 ± 0.21               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.0549 ± 0.0026 ms | 0.0542 ± 0.0063 ms  | 1.01 ± 0.13                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.274 ± 0.043 ms   | 0.25 ± 0.028 ms     | 1.1 ± 0.21                 |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0794 ± 0.0047 ms | 0.0436 ± 0.0011 ms  | 1.82 ± 0.12                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 0.0332 ± 0.002 ms  | 31.1 ± 1.6 μs       | 1.07 ± 0.085               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.866 ± 0.13 ms    | 0.788 ± 0.12 ms     | 1.1 ± 0.23                 |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0895 ± 0.0052 ms | 0.0636 ± 0.007 ms   | 1.41 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.533 ± 0.027 ms   | 0.38 ± 0.029 ms     | 1.4 ± 0.13                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.093 ± 0.0064 ms  | 0.0642 ± 0.0024 ms  | 1.45 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0682 ± 0.0037 ms | 0.0515 ± 0.013 ms   | 1.32 ± 0.34                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.88 ± 0.25 ms     | 1.64 ± 0.033 ms     | 1.15 ± 0.16                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.129 ± 0.0042 ms  | 0.098 ± 0.0073 ms   | 1.32 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 1.27 ± 0.1 ms      | 1.23 ± 0.12 ms      | 1.03 ± 0.13                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.0637 ± 0.006 ms  | 0.0532 ± 0.0016 ms  | 1.2 ± 0.12                 |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.129 ± 0.011 ms   | 0.126 ± 0.013 ms    | 1.03 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 3.46 ± 0.64 ms     | 3.83 ± 0.93 ms      | 0.903 ± 0.28               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.104 ± 0.014 ms   | 0.0737 ± 0.0089 ms  | 1.4 ± 0.26                 |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0714 ± 0.0021 ms | 0.0627 ± 0.0013 ms  | 1.14 ± 0.041               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 2.83 ± 2.6 μs      | 2.22 ± 0.41 μs      | 1.27 ± 1.2                 |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.0519 ± 0.0032 ms | 0.0488 ± 0.0037 ms  | 1.06 ± 0.11                |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 9.81 ± 1.7 μs      | 9.81 ± 1.7 μs       | 1 ± 0.25                   |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.0668 ± 0.0035 ms | 0.0392 ± 0.017 ms   | 1.7 ± 0.74                 |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 0.0629 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 7.58 ± 1.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0566 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 3.41 ± 0.052 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0581 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 0.0476 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0483 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.984 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.43 ± 0.07 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 2.65 ± 0.56 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0809 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0698 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.0931 ± 0.0088 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 0.0585 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 1.15 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.124 ± 0.0084 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.145 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.521 ± 0.074 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0893 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.0654 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 1.73 ± 0.046 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0822 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.165 ± 0.016 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 0.0376 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.102 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.331 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 1.26 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.085 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 26 ± 1.1 μs         |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.114 ± 0.0085 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0616 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0688 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.402 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 0.0392 ± 0.00094 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.71 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.665 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 0.04 ± 0.0023 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 2.33 ± 0.063 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.702 ± 0.04 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 1.89 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.174 ± 0.006 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0546 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 1.32 ± 0.02 ms      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.284 ± 0.032 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.117 ± 0.0095 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.114 ± 0.0057 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 10.9 ± 1.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 1.11 ± 0.027 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 4.99 ± 0.14 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.119 ± 0.0045 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.101 ± 0.0035 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.384 ± 0.025 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.458 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.0843 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 10.7 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0758 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0732 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.924 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.262 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.415 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0583 ± 0.046 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.137 ± 0.0081 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.118 ± 0.0065 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 0.0332 ± 0.00093 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.0864 ± 0.043 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0674 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 0.0566 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.676 ± 0.081 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 1.66 ± 0.041 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 1.35 ± 0.032 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0856 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.0901 ± 0.0072 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 0.0625 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.115 ± 0.0028 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 1.49 ± 0.043 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 0.0458 ± 0.0067 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0692 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0641 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.0823 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 0.0423 ± 0.0069 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 0.034 ± 0.0027 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.279 ± 0.014 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.101 ± 0.0035 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.115 ± 0.059 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0607 ± 0.0071 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.432 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.229 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 1.16 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.484 ± 0.076 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.131 ± 0.0059 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 10.1 ± 0.77 μs      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 28.2 ± 0.78 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 0.0354 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.133 ± 0.011 ms    |                            |
| time_to_load                                                                              | 0.238 ± 0.0014 s   | 0.347 ± 0.0037 s    | 0.686 ± 0.0084             |

|                                                                                           | v0.1.0                    | f782f1e2351caf...         | v0.1.0 / f782f1e2351caf... |
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
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.091 k allocs: 0.0452 MB | 0.078 k allocs: 0.0428 MB | 1.06                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.04 k allocs: 0.0395 MB  | 0.036 k allocs: 0.0384 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 0.034 k allocs: 7.98 kB   | 0.032 k allocs: 7.77 kB   | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.072 k allocs: 0.0443 MB | 0.059 k allocs: 0.0421 MB | 1.05                       |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                           | 0.627 k allocs: 23.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                           | 0.074 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                           | 0.278 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                           | 24.2 k allocs: 1.25 MB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                           | 0.238 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                           | 0.341 k allocs: 14.6 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                           | 0.933 k allocs: 0.119 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                           | 4.16 k allocs: 0.358 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                           | 23.3 k allocs: 1.18 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                           | 0.66 k allocs: 0.0361 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                           | 0.394 k allocs: 0.0323 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                           | 0.541 k allocs: 24 kB     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                           | 10.1 k allocs: 0.872 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                           | 0.514 k allocs: 0.191 MB  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                           | 1.04 k allocs: 0.0394 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                           | 4.79 k allocs: 0.356 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                           | 0.986 k allocs: 0.0379 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                           | 14.4 k allocs: 0.88 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                           | 0.886 k allocs: 0.342 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                           | 0.356 k allocs: 26.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                           | 16 k allocs: 0.784 MB     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                           | 0.319 k allocs: 20.9 kB   |                            |
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
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                           | 1.27 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                           | 0.816 k allocs: 0.0709 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                           | 0.056 k allocs: 11.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                           | 0.0496 M allocs: 2.59 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                           | 1.11 k allocs: 0.046 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                           | 0.429 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                           | 3.1 k allocs: 0.275 MB    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                           | 4.69 k allocs: 0.349 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                           | 0.659 k allocs: 25.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                           | 0.05 k allocs: 12.4 kB    |                            |
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
| time_to_load                                                                              | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

