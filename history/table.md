|                                                                                           | v0.1.0             | 08a561cde77517...  | v0.1.0 / 08a561cde77517... |
|:------------------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0458 ± 0.0053 ms | 0.0425 ± 0.0048 ms | 1.08 ± 0.17                |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 18.4 ± 0.89 μs     | 19.8 ± 1.8 μs      | 0.929 ± 0.096              |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 2.82 ± 0.64 μs     | 7.02 ± 1.2 μs      | 0.402 ± 0.11               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.137 ± 0.022 ms   | 0.125 ± 0.021 ms   | 1.1 ± 0.25                 |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 29.2 ± 5.1 μs      | 20.6 ± 0.72 μs     | 1.42 ± 0.25                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.229 ± 0.015 ms   | 0.218 ± 0.0074 ms  | 1.05 ± 0.078               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 22.4 ± 0.84 μs     | 19.7 ± 0.81 μs     | 1.13 ± 0.063               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 26.6 ± 10 μs       | 27.4 ± 3.6 μs      | 0.97 ± 0.39                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 0.661 ± 0.16 ms    | 0.647 ± 0.092 ms   | 1.02 ± 0.29                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 30.4 ± 1.8 μs      | 22.7 ± 0.9 μs      | 1.34 ± 0.095               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.415 ± 0.031 ms   | 0.414 ± 0.033 ms   | 1 ± 0.11                   |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 19 ± 1.3 μs        | 16.7 ± 1.3 μs      | 1.14 ± 0.12                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0585 ± 0.0053 ms | 0.0576 ± 0.0048 ms | 1.01 ± 0.12                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.12 ± 0.31 ms     | 1.06 ± 0.11 ms     | 1.05 ± 0.31                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 27.4 ± 2.3 μs      | 17.2 ± 2.4 μs      | 1.59 ± 0.26                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 0.943 ± 0.36 ms    | 0.156 ± 0.013 ms   | 6.04 ± 2.4                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 0.663 ± 0.062 ms   | 0.245 ± 0.0081 ms  | 2.7 ± 0.27                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0409 ± 0.0036 ms | 26.1 ± 4.3 μs      | 1.56 ± 0.29                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.0595 ± 0.0043 ms | 0.0322 ± 0.0022 ms | 1.85 ± 0.18                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.333 ± 0.055 ms   | 0.0523 ± 0.0013 ms | 6.37 ± 1.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.374 ± 0.048 ms   | 0.0652 ± 0.0098 ms | 5.73 ± 1.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0508 ± 0.01 ms   | 0.038 ± 0.004 ms   | 1.34 ± 0.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.0691 ± 0.005 ms  | 0.0464 ± 0.0049 ms | 1.49 ± 0.19                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.684 ± 0.14 ms    | 0.133 ± 0.029 ms   | 5.16 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 0.505 ± 0.089 ms   | 0.175 ± 0.04 ms    | 2.88 ± 0.83                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.264 ± 0.018 ms   | 0.237 ± 0.014 ms   | 1.11 ± 0.1                 |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0375 ± 0.013 ms  | 24.3 ± 0.87 μs     | 1.54 ± 0.53                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.041 ± 0.0082 ms  | 0.0422 ± 0.0056 ms | 0.973 ± 0.23               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 0.64 ± 0.097 ms    | 0.768 ± 0.057 ms   | 0.833 ± 0.14               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0386 ± 0.0012 ms | 26.4 ± 1 μs        | 1.46 ± 0.071               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.248 ± 0.018 ms   | 0.246 ± 0.021 ms   | 1.01 ± 0.11                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0332 ± 0.0016 ms | 0.0335 ± 0.0016 ms | 0.991 ± 0.067              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0387 ± 0.0053 ms | 0.0355 ± 0.0067 ms | 1.09 ± 0.25                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 0.763 ± 0.14 ms    | 0.818 ± 0.25 ms    | 0.932 ± 0.33               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0447 ± 0.0031 ms | 0.0354 ± 0.002 ms  | 1.26 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0475 ± 0.0028 ms | 0.0457 ± 0.0016 ms | 1.04 ± 0.072               |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 24.8 ± 2.3 μs      | 23.5 ± 2 μs        | 1.06 ± 0.13                |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 8.3 ± 1.7 μs       | 7.59 ± 1.8 μs      | 1.09 ± 0.35                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.155 ± 0.023 ms   | 0.126 ± 0.027 ms   | 1.23 ± 0.32                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 28.8 ± 7 μs        | 29.9 ± 2.8 μs      | 0.962 ± 0.25               |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.276 ± 0.019 ms   | 0.226 ± 0.015 ms   | 1.22 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0406 ± 0.0032 ms | 0.0372 ± 0.0012 ms | 1.09 ± 0.093               |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0361 ± 0.0068 ms | 0.0367 ± 0.0045 ms | 0.984 ± 0.22               |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 0.815 ± 0.066 ms   | 0.693 ± 0.028 ms   | 1.18 ± 0.11                |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.0639 ± 0.0072 ms | 0.0429 ± 0.0014 ms | 1.49 ± 0.17                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.0964 ± 0.0076 ms | 0.0877 ± 0.0054 ms | 1.1 ± 0.11                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 18 ± 2.1 μs        | 22.3 ± 0.89 μs     | 0.805 ± 0.098              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 19.6 ± 2.2 μs      | 17.5 ± 2.2 μs      | 1.12 ± 0.19                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.24 ± 0.059 ms    | 0.233 ± 0.013 ms   | 1.03 ± 0.26                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 23 ± 1.3 μs        | 23.5 ± 1 μs        | 0.978 ± 0.069              |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.169 ± 0.028 ms   | 0.173 ± 0.033 ms   | 0.978 ± 0.25               |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0391 ± 0.0012 ms | 25.2 ± 1.1 μs      | 1.55 ± 0.082               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 25.7 ± 2.4 μs      | 22.3 ± 2 μs        | 1.15 ± 0.15                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.505 ± 0.067 ms   | 0.422 ± 0.067 ms   | 1.2 ± 0.25                 |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0413 ± 0.0046 ms | 0.0318 ± 0.006 ms  | 1.3 ± 0.29                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.345 ± 0.034 ms   | 0.269 ± 0.03 ms    | 1.28 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0495 ± 0.0016 ms | 0.0357 ± 0.0011 ms | 1.38 ± 0.06                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.042 ± 0.005 ms   | 0.0359 ± 0.0049 ms | 1.17 ± 0.21                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.02 ± 0.13 ms     | 0.968 ± 0.032 ms   | 1.05 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.066 ± 0.0068 ms  | 0.045 ± 0.0016 ms  | 1.47 ± 0.16                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 0.827 ± 0.056 ms   | 0.78 ± 0.1 ms      | 1.06 ± 0.16                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.0369 ± 0.0026 ms | 0.0321 ± 0.0019 ms | 1.15 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.093 ± 0.0066 ms  | 0.0881 ± 0.0071 ms | 1.06 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 2.04 ± 0.38 ms     | 2.17 ± 0.27 ms     | 0.94 ± 0.21                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0429 ± 0.0043 ms | 0.0354 ± 0.0034 ms | 1.21 ± 0.17                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0451 ± 0.011 ms  | 0.032 ± 0.0014 ms  | 1.41 ± 0.35                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 1.32 ± 0.51 μs     | 1.67 ± 0.44 μs     | 0.79 ± 0.37                |
| Evaluation/Matrix overview T200_L20_S3                                                    | 28.5 ± 3 μs        | 18.8 ± 9 μs        | 1.51 ± 0.74                |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 5.74 ± 1.4 μs      | 5.95 ± 1.3 μs      | 0.965 ± 0.32               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.0372 ± 0.0038 ms | 20.9 ± 0.83 μs     | 1.78 ± 0.19                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 29.5 ± 1.9 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 4.71 ± 2.5 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0336 ± 0.0035 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 1.78 ± 0.064 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0457 ± 0.0053 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.0405 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 21.9 ± 1.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 0.698 ± 0.028 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 28.9 ± 3.6 μs      |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.521 ± 0.021 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.296 ± 0.011 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 1.4 ± 0.1 ms       |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 28.4 ± 1.2 μs      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0382 ± 0.0012 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0424 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.0435 ± 0.0012 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 0.619 ± 0.041 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 28 ± 4 μs          |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 0.774 ± 0.059 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.076 ± 0.0095 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.0675 ± 0.003 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.325 ± 0.029 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0399 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 29.4 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 0.902 ± 0.03 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0483 ± 0.0099 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.108 ± 0.017 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 26.7 ± 6.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.0459 ± 0.0019 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.222 ± 0.021 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 0.548 ± 0.21 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.044 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.0872 ± 0.0097 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 18.9 ± 2.5 μs      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.0595 ± 0.0073 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0434 ± 0.0049 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0447 ± 0.0032 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.169 ± 0.075 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 22.6 ± 0.87 μs     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.421 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.387 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 22.3 ± 1.2 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 1.31 ± 0.18 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.479 ± 0.043 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 1.03 ± 0.072 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.088 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 30.6 ± 1.1 μs      |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.0809 ± 0.0099 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 0.643 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.178 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.0473 ± 0.0023 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.0637 ± 0.0036 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 6.99 ± 1.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 0.611 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 2.68 ± 0.18 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.056 ± 0.0072 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.048 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.234 ± 0.015 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.309 ± 0.021 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 0.0318 ± 0.0042 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.038 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 7.79 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.035 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0534 ± 0.0057 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0471 ± 0.0083 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.524 ± 0.14 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.142 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.247 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0381 ± 0.025 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.0821 ± 0.011 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.0504 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 19.3 ± 0.83 μs     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.0336 ± 0.0094 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0387 ± 0.0036 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 29.3 ± 2.9 μs      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.462 ± 0.041 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 0.931 ± 0.08 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 0.77 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0361 ± 0.0011 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.0614 ± 0.0075 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 24.5 ± 1 μs        |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.0541 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 0.944 ± 0.13 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 1.6 ± 0.58 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 26.8 ± 2 μs        |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0374 ± 0.0011 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0384 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.037 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 22.9 ± 2.5 μs      |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 19.9 ± 1.7 μs      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.171 ± 0.049 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.0653 ± 0.0048 ms |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.0473 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0352 ± 0.004 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.28 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.122 ± 0.052 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 0.661 ± 0.053 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.327 ± 0.04 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.059 ± 0.0025 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 6.88 ± 0.98 μs     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 17.9 ± 1.8 μs      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 24 ± 1.2 μs        |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.087 ± 0.0064 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 2.25 ± 0.049 ms    |                            |
| time_to_load                                                                              | 0.142 ± 0.006 s    | 0.213 ± 0.012 s    | 0.665 ± 0.048              |

|                                                                                           | v0.1.0                    | 08a561cde77517...         | v0.1.0 / 08a561cde77517... |
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

