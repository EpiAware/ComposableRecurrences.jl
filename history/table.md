|                                                                                           | v0.1.0             | 0782595d22d94c...  | v0.1.0 / 0782595d22d94c... |
|:------------------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0574 ± 0.007 ms  | 0.0589 ± 0.0067 ms | 0.974 ± 0.16               |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 23.4 ± 0.71 μs     | 23.5 ± 0.92 μs     | 0.997 ± 0.049              |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 3.35 ± 0.61 μs     | 7.72 ± 1.2 μs      | 0.435 ± 0.11               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.163 ± 0.02 ms    | 0.165 ± 0.017 ms   | 0.991 ± 0.16               |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.0328 ± 0.0018 ms | 25.6 ± 0.89 μs     | 1.28 ± 0.082               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.302 ± 0.025 ms   | 0.298 ± 0.023 ms   | 1.01 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 28.3 ± 1.7 μs      | 25.6 ± 1.1 μs      | 1.1 ± 0.079                |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.0415 ± 0.0044 ms | 0.0382 ± 0.0032 ms | 1.09 ± 0.15                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 0.688 ± 0.17 ms    | 0.786 ± 0.048 ms   | 0.875 ± 0.22               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.0383 ± 0.0026 ms | 27.6 ± 0.85 μs     | 1.39 ± 0.1                 |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.539 ± 0.056 ms   | 0.529 ± 0.08 ms    | 1.02 ± 0.19                |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 24.6 ± 2.8 μs      | 21.5 ± 0.84 μs     | 1.15 ± 0.14                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0892 ± 0.0087 ms | 0.0988 ± 0.021 ms  | 0.902 ± 0.21               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.31 ± 0.23 ms     | 1.25 ± 0.11 ms     | 1.04 ± 0.2                 |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.0357 ± 0.0038 ms | 22.7 ± 3.3 μs      | 1.58 ± 0.29                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 1.22 ± 0.13 ms     | 0.215 ± 0.017 ms   | 5.69 ± 0.74                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 1.07 ± 0.089 ms    | 0.304 ± 0.071 ms   | 3.51 ± 0.87                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0554 ± 0.0058 ms | 0.0322 ± 0.0051 ms | 1.72 ± 0.32                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.0837 ± 0.0089 ms | 0.0373 ± 0.0026 ms | 2.24 ± 0.28                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.56 ± 0.069 ms    | 0.0929 ± 0.0071 ms | 6.03 ± 0.87                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.539 ± 0.044 ms   | 0.0947 ± 0.022 ms  | 5.69 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0678 ± 0.011 ms  | 0.0482 ± 0.0047 ms | 1.41 ± 0.27                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.0916 ± 0.0091 ms | 0.0527 ± 0.0044 ms | 1.74 ± 0.23                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.742 ± 0.061 ms   | 0.154 ± 0.014 ms   | 4.82 ± 0.59                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 0.809 ± 0.083 ms   | 0.185 ± 0.019 ms   | 4.36 ± 0.63                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.35 ± 0.036 ms    | 0.354 ± 0.028 ms   | 0.989 ± 0.13               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0573 ± 0.0063 ms | 0.0334 ± 0.0014 ms | 1.72 ± 0.2                 |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0606 ± 0.0094 ms | 0.0644 ± 0.0052 ms | 0.94 ± 0.16                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 0.918 ± 0.2 ms     | 0.947 ± 0.024 ms   | 0.969 ± 0.21               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.049 ± 0.0029 ms  | 0.0318 ± 0.0018 ms | 1.54 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.326 ± 0.031 ms   | 0.303 ± 0.032 ms   | 1.08 ± 0.15                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0417 ± 0.0035 ms | 0.0443 ± 0.0028 ms | 0.942 ± 0.099              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0636 ± 0.011 ms  | 0.049 ± 0.0052 ms  | 1.3 ± 0.27                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 0.907 ± 0.11 ms    | 0.931 ± 0.044 ms   | 0.974 ± 0.13               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.057 ± 0.0077 ms  | 0.0413 ± 0.0038 ms | 1.38 ± 0.23                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0627 ± 0.0061 ms | 0.0595 ± 0.0035 ms | 1.05 ± 0.12                |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 30.2 ± 3.1 μs      | 31.1 ± 3 μs        | 0.969 ± 0.14               |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 9.76 ± 2.1 μs      | 8.15 ± 2.1 μs      | 1.2 ± 0.39                 |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.164 ± 0.02 ms    | 0.147 ± 0.023 ms   | 1.12 ± 0.22                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.0446 ± 0.0037 ms | 0.0343 ± 0.0032 ms | 1.3 ± 0.16                 |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.374 ± 0.031 ms   | 0.272 ± 0.021 ms   | 1.37 ± 0.16                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0511 ± 0.0037 ms | 0.0438 ± 0.0023 ms | 1.17 ± 0.11                |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0603 ± 0.009 ms  | 0.0557 ± 0.005 ms  | 1.08 ± 0.19                |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 0.907 ± 0.097 ms   | 0.885 ± 0.039 ms   | 1.03 ± 0.12                |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.081 ± 0.011 ms   | 0.0492 ± 0.0033 ms | 1.65 ± 0.25                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.118 ± 0.011 ms   | 0.114 ± 0.013 ms   | 1.04 ± 0.15                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 22.6 ± 2.7 μs      | 28.6 ± 1.2 μs      | 0.789 ± 0.099              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 27.1 ± 4.3 μs      | 25.9 ± 2.4 μs      | 1.05 ± 0.19                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.267 ± 0.032 ms   | 0.221 ± 0.076 ms   | 1.21 ± 0.44                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.032 ± 0.0021 ms  | 30.5 ± 3.4 μs      | 1.05 ± 0.13                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.245 ± 0.033 ms   | 0.228 ± 0.018 ms   | 1.08 ± 0.17                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0534 ± 0.0068 ms | 0.0485 ± 0.0023 ms | 1.1 ± 0.15                 |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 0.0339 ± 0.0036 ms | 0.0504 ± 0.015 ms  | 0.673 ± 0.21               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.548 ± 0.073 ms   | 0.619 ± 0.034 ms   | 0.886 ± 0.13               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0533 ± 0.0079 ms | 0.0348 ± 0.0014 ms | 1.53 ± 0.23                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.473 ± 0.044 ms   | 0.396 ± 0.028 ms   | 1.2 ± 0.14                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0657 ± 0.0071 ms | 0.0453 ± 0.0019 ms | 1.45 ± 0.17                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0653 ± 0.0063 ms | 0.0667 ± 0.011 ms  | 0.979 ± 0.19               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.2 ± 0.16 ms      | 2.16 ± 0.095 ms    | 0.553 ± 0.08               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.0785 ± 0.011 ms  | 0.0512 ± 0.0032 ms | 1.54 ± 0.24                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 1.18 ± 0.07 ms     | 1.07 ± 0.13 ms     | 1.1 ± 0.15                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.048 ± 0.0044 ms  | 0.0409 ± 0.0034 ms | 1.17 ± 0.15                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.129 ± 0.014 ms   | 0.133 ± 0.013 ms   | 0.972 ± 0.14               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 2.32 ± 0.53 ms     | 2.66 ± 0.31 ms     | 0.873 ± 0.23               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0541 ± 0.0081 ms | 0.0419 ± 0.007 ms  | 1.29 ± 0.29                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0519 ± 0.0097 ms | 0.0428 ± 0.0017 ms | 1.21 ± 0.23                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 2.72 ± 1.8 μs      | 2.02 ± 0.41 μs     | 1.35 ± 0.93                |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.0358 ± 0.0026 ms | 0.0344 ± 0.0021 ms | 1.04 ± 0.099               |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 6.88 ± 1.4 μs      | 7.29 ± 1.4 μs      | 0.944 ± 0.27               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.05 ± 0.0026 ms   | 31.4 ± 9.9 μs      | 1.59 ± 0.51                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 0.04 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 9.69 ± 2 μs        |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0508 ± 0.0046 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 2.22 ± 0.09 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0557 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.0465 ± 0.0029 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 31.1 ± 2.6 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 0.92 ± 0.055 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                     |                    | 0.0487 ± 0.0088 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0493 ± 0.0046 ms |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.819 ± 0.04 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.3 ± 0.023 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 1.83 ± 0.17 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 0.0683 ± 0.003 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward               |                    | 0.752 ± 0.06 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0466 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0606 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.0549 ± 0.0044 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 0.963 ± 0.048 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 0.0344 ± 0.0028 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 1.11 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.143 ± 0.033 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.0821 ± 0.012 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.422 ± 0.028 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0487 ± 0.0046 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.0407 ± 0.0037 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                 |                    | 0.0509 ± 0.0025 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 1.04 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.061 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.187 ± 0.039 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                  |                    | 0.0657 ± 0.0079 ms |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 29.6 ± 2.5 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.0553 ± 0.0047 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.285 ± 0.025 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 0.886 ± 0.046 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.0585 ± 0.0051 ms |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                  |                    | 0.3 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.147 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 25 ± 7.3 μs        |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff          |                    | 0.0434 ± 0.0037 ms |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.0941 ± 0.011 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0547 ± 0.0084 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.0542 ± 0.0044 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.26 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 31.5 ± 1.2 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.582 ± 0.036 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.557 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 0.032 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 1.63 ± 0.14 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.603 ± 0.044 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 1.26 ± 0.065 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.12 ± 0.0083 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0386 ± 0.0016 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.362 ± 0.015 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                    |                    | 0.0418 ± 0.0093 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse               |                    | 0.0595 ± 0.0095 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 1.01 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.251 ± 0.026 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.0588 ± 0.0077 ms |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                    | 0.0507 ± 0.0052 ms |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                    | 0.935 ± 0.21 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.0821 ± 0.0083 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 12 ± 1.5 μs        |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 0.701 ± 0.092 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 3.21 ± 0.11 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.0706 ± 0.015 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.0605 ± 0.0076 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse       |                    | 0.0478 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.323 ± 0.021 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                |                    | 0.0758 ± 0.01 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.479 ± 0.036 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 0.0359 ± 0.0025 ms |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                            |                    | 0.31 ± 0.021 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                 |                    | 0.241 ± 0.018 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.0466 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 9.37 ± 1.5 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.0397 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0877 ± 0.0057 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.104 ± 0.008 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.871 ± 0.063 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.222 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.351 ± 0.023 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0951 ± 0.0071 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.101 ± 0.0077 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse     |                    | 0.0609 ± 0.009 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.0634 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 26.2 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.0661 ± 0.0051 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0507 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 0.0341 ± 0.0025 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.61 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 1.25 ± 0.094 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 1.02 ± 0.04 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0455 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.118 ± 0.077 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 0.0327 ± 0.0015 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.0793 ± 0.0074 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 3.72 ± 0.17 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 2.6 ± 0.086 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 0.04 ± 0.0032 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                          |                    | 0.961 ± 0.062 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0742 ± 0.0027 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0482 ± 0.0024 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.0459 ± 0.0037 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward       |                    | 0.375 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 0.035 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 25.9 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.231 ± 0.023 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.0939 ± 0.011 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.0791 ± 0.0072 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0531 ± 0.0062 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.353 ± 0.025 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.221 ± 0.023 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                            |                    | 0.0682 ± 0.0049 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 0.773 ± 0.038 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.386 ± 0.033 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.0653 ± 0.0073 ms |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 9.72 ± 1.4 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                          |                    | 0.0687 ± 0.016 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 22.9 ± 3.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward     |                    | 1.59 ± 0.088 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 31.5 ± 2.5 μs      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.117 ± 0.015 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 2.5 ± 0.12 ms      |                            |
| time_to_load                                                                              | 0.198 ± 0.0033 s   | 0.297 ± 0.0046 s   | 0.668 ± 0.015              |

|                                                                                           | v0.1.0                    | 0782595d22d94c...         | v0.1.0 / 0782595d22d94c... |
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
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                           | 0.627 k allocs: 23.9 kB   |                            |
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
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                    |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse               |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                           | 0.816 k allocs: 0.0709 MB |                            |
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
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                           | 0.133 k allocs: 12.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                           | 0.282 k allocs: 0.135 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                           | 0.371 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                           | 0.644 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                           | 6.08 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                           | 22.4 k allocs: 1.06 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                           | 0.716 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                           | 0.487 k allocs: 21.1 kB   |                            |
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
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                           | 0.149 k allocs: 6.66 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                           | 0.945 k allocs: 0.228 MB  |                            |
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

