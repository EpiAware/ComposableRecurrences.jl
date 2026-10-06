|                                                                                           | v0.1.0             | a28a90c89d421c...  | v0.1.0 / a28a90c89d421c... |
|:------------------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0679 ± 0.0057 ms | 0.0668 ± 0.0057 ms | 1.02 ± 0.12                |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 29.1 ± 2.3 μs      | 29.1 ± 2.4 μs      | 0.999 ± 0.11               |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 4.53 ± 0.84 μs     | 7.82 ± 3.6 μs      | 0.579 ± 0.29               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.189 ± 0.03 ms    | 0.145 ± 0.0084 ms  | 1.3 ± 0.22                 |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.0414 ± 0.0031 ms | 0.0334 ± 0.0026 ms | 1.24 ± 0.13                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.346 ± 0.019 ms   | 0.343 ± 0.027 ms   | 1.01 ± 0.095               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 0.0348 ± 0.0012 ms | 0.0317 ± 0.0012 ms | 1.1 ± 0.057                |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.0483 ± 0.0046 ms | 0.0503 ± 0.0052 ms | 0.96 ± 0.13                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 0.822 ± 0.15 ms    | 0.914 ± 0.057 ms   | 0.9 ± 0.18                 |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.046 ± 0.0016 ms  | 0.0335 ± 0.0015 ms | 1.37 ± 0.078               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.615 ± 0.033 ms   | 0.6 ± 0.039 ms     | 1.02 ± 0.086               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 29.8 ± 2.7 μs      | 25.6 ± 1.2 μs      | 1.16 ± 0.12                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.108 ± 0.0093 ms  | 0.104 ± 0.019 ms   | 1.04 ± 0.21                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.58 ± 0.23 ms     | 1.4 ± 0.31 ms      | 1.13 ± 0.3                 |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.0414 ± 0.0036 ms | 26.9 ± 2 μs        | 1.54 ± 0.18                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 1.29 ± 0.066 ms    | 0.229 ± 0.011 ms   | 5.64 ± 0.4                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 1.16 ± 0.053 ms    | 0.268 ± 0.071 ms   | 4.32 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0629 ± 0.0045 ms | 0.0369 ± 0.0046 ms | 1.7 ± 0.25                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.0821 ± 0.017 ms  | 0.0445 ± 0.0025 ms | 1.85 ± 0.41                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.59 ± 0.062 ms    | 0.0776 ± 0.0029 ms | 7.6 ± 0.85                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.611 ± 0.033 ms   | 0.116 ± 0.022 ms   | 5.26 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0733 ± 0.0074 ms | 0.0561 ± 0.005 ms  | 1.31 ± 0.18                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.112 ± 0.032 ms   | 0.0639 ± 0.0046 ms | 1.75 ± 0.52                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.895 ± 0.037 ms   | 0.167 ± 0.033 ms   | 5.36 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 0.937 ± 0.084 ms   | 0.249 ± 0.0091 ms  | 3.76 ± 0.36                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.39 ± 0.032 ms    | 0.369 ± 0.022 ms   | 1.06 ± 0.11                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0671 ± 0.0046 ms | 0.0394 ± 0.0015 ms | 1.7 ± 0.13                 |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.071 ± 0.01 ms    | 0.0763 ± 0.0054 ms | 0.93 ± 0.15                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 1.07 ± 0.21 ms     | 1.07 ± 0.05 ms     | 0.999 ± 0.2                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0586 ± 0.0024 ms | 0.0387 ± 0.0014 ms | 1.52 ± 0.084               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.372 ± 0.023 ms   | 0.333 ± 0.021 ms   | 1.12 ± 0.098               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0515 ± 0.003 ms  | 0.049 ± 0.0025 ms  | 1.05 ± 0.08                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0715 ± 0.01 ms   | 0.0534 ± 0.0031 ms | 1.34 ± 0.2                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 0.972 ± 0.084 ms   | 1.03 ± 0.033 ms    | 0.948 ± 0.087              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0637 ± 0.0024 ms | 0.0484 ± 0.0024 ms | 1.32 ± 0.083               |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0729 ± 0.0036 ms | 0.0699 ± 0.0034 ms | 1.04 ± 0.072               |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 0.0366 ± 0.003 ms  | 0.038 ± 0.003 ms   | 0.963 ± 0.11               |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 11.5 ± 1.8 μs      | 10.6 ± 1.2 μs      | 1.08 ± 0.21                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.188 ± 0.019 ms   | 0.179 ± 0.021 ms   | 1.05 ± 0.16                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.0514 ± 0.0032 ms | 0.0419 ± 0.0033 ms | 1.23 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.428 ± 0.037 ms   | 0.331 ± 0.027 ms   | 1.29 ± 0.15                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0617 ± 0.0034 ms | 0.0593 ± 0.0024 ms | 1.04 ± 0.071               |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0698 ± 0.0098 ms | 0.0825 ± 0.02 ms   | 0.846 ± 0.24               |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 1.06 ± 0.066 ms    | 0.995 ± 0.03 ms    | 1.06 ± 0.073               |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.0939 ± 0.0059 ms | 0.0609 ± 0.0031 ms | 1.54 ± 0.13                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.135 ± 0.01 ms    | 0.121 ± 0.0083 ms  | 1.11 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 27.8 ± 3 μs        | 0.0353 ± 0.0017 ms | 0.787 ± 0.093              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 29.7 ± 3.1 μs      | 28.9 ± 3.6 μs      | 1.03 ± 0.17                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.321 ± 0.027 ms   | 0.309 ± 0.019 ms   | 1.04 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.038 ± 0.0021 ms  | 0.0332 ± 0.0022 ms | 1.14 ± 0.098               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.276 ± 0.028 ms   | 0.251 ± 0.026 ms   | 1.1 ± 0.16                 |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0681 ± 0.0043 ms | 0.0385 ± 0.0016 ms | 1.77 ± 0.13                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 0.0359 ± 0.0029 ms | 0.0373 ± 0.0038 ms | 0.961 ± 0.13               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.633 ± 0.066 ms   | 0.627 ± 0.082 ms   | 1.01 ± 0.17                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0596 ± 0.0047 ms | 0.0432 ± 0.0048 ms | 1.38 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.517 ± 0.037 ms   | 0.373 ± 0.022 ms   | 1.39 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0776 ± 0.0049 ms | 0.0558 ± 0.0033 ms | 1.39 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0759 ± 0.0065 ms | 0.0593 ± 0.0089 ms | 1.28 ± 0.22                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.41 ± 0.11 ms     | 1.3 ± 0.043 ms     | 1.08 ± 0.088               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.0896 ± 0.0059 ms | 0.064 ± 0.0036 ms  | 1.4 ± 0.12                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 1.28 ± 0.051 ms    | 1.24 ± 0.083 ms    | 1.03 ± 0.08                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.0564 ± 0.004 ms  | 0.0485 ± 0.004 ms  | 1.16 ± 0.13                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.148 ± 0.013 ms   | 0.145 ± 0.025 ms   | 1.02 ± 0.2                 |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 2.95 ± 0.42 ms     | 2.98 ± 0.53 ms     | 0.992 ± 0.22               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0654 ± 0.0061 ms | 0.0481 ± 0.0027 ms | 1.36 ± 0.15                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0719 ± 0.0052 ms | 0.0483 ± 0.0036 ms | 1.49 ± 0.15                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 2.9 ± 1.9 μs       | 2.25 ± 0.43 μs     | 1.29 ± 0.86                |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.0395 ± 0.0028 ms | 0.0374 ± 0.0026 ms | 1.06 ± 0.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 8.05 ± 1.5 μs      | 8.45 ± 1.6 μs      | 0.953 ± 0.25               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.0588 ± 0.0031 ms | 0.0341 ± 0.014 ms  | 1.73 ± 0.71                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 0.0489 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 7.07 ± 0.78 μs     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0494 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 2.49 ± 0.075 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0549 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.0565 ± 0.0036 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 0.0353 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 1.01 ± 0.049 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0554 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.911 ± 0.025 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.409 ± 0.033 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 2.33 ± 0.074 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 0.0436 ± 0.0019 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0555 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0692 ± 0.0045 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.0678 ± 0.004 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 0.968 ± 0.06 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 0.04 ± 0.0035 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 1.19 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.132 ± 0.0076 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.0952 ± 0.0061 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.505 ± 0.023 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0568 ± 0.0027 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.0433 ± 0.0027 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 1.27 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0745 ± 0.0048 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.178 ± 0.014 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 0.0363 ± 0.0039 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.0673 ± 0.0036 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.33 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 0.97 ± 0.087 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.0796 ± 0.004 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.169 ± 0.0099 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 27.9 ± 2.5 μs      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.0868 ± 0.0061 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0917 ± 0.032 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0634 ± 0.0044 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.321 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 0.0372 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.632 ± 0.027 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.633 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 0.0345 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 1.82 ± 0.12 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.675 ± 0.036 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 1.4 ± 0.05 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.141 ± 0.0072 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0485 ± 0.0019 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.135 ± 0.0087 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 1.16 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.264 ± 0.016 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.0769 ± 0.0052 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.0884 ± 0.0048 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 12.6 ± 1.7 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 0.839 ± 0.028 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 3.45 ± 0.084 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.0762 ± 0.007 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.0732 ± 0.0032 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.36 ± 0.044 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.482 ± 0.035 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 0.0424 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.0561 ± 0.0024 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 10.9 ± 1.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.0501 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0741 ± 0.0042 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0856 ± 0.011 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.915 ± 0.11 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.208 ± 0.0097 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.375 ± 0.021 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0664 ± 0.026 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.101 ± 0.0082 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.0815 ± 0.0059 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 31.1 ± 1.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.061 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0595 ± 0.0046 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 0.0416 ± 0.0028 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.673 ± 0.029 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 1.29 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 1.12 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0565 ± 0.0024 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.116 ± 0.0072 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 0.0399 ± 0.0019 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.0903 ± 0.0041 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 1.18 ± 0.088 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 2.75 ± 0.31 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 0.0379 ± 0.0034 ms |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0609 ± 0.0024 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0567 ± 0.003 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.053 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 0.0475 ± 0.0039 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 30.9 ± 2.3 μs      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.272 ± 0.011 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.109 ± 0.0053 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.0829 ± 0.013 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0644 ± 0.021 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.396 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.239 ± 0.053 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 0.913 ± 0.036 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.453 ± 0.051 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.085 ± 0.0054 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 10.3 ± 1.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 27.2 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 0.0345 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.12 ± 0.0077 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 2.97 ± 0.08 ms     |                            |
| time_to_load                                                                              | 0.241 ± 0.0022 s   | 0.348 ± 0.0012 s   | 0.693 ± 0.0066             |

|                                                                                           | v0.1.0                    | a28a90c89d421c...         | v0.1.0 / a28a90c89d421c... |
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
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                           | 0.479 k allocs: 30.9 kB   |                            |
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

