|                                                                                           | v0.1.0              | 1e16e72f8dc5ad...   | v0.1.0 / 1e16e72f8dc5ad... |
|:------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.0422 ± 0.0041 ms  | 0.0437 ± 0.0032 ms  | 0.966 ± 0.12               |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 18.7 ± 1.5 μs       | 19.9 ± 1.3 μs       | 0.939 ± 0.099              |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 3.12 ± 0.88 μs      | 3.57 ± 1.7 μs       | 0.872 ± 0.47               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.137 ± 0.03 ms     | 0.109 ± 0.042 ms    | 1.25 ± 0.56                |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 27.8 ± 3.4 μs       | 21.8 ± 3.8 μs       | 1.28 ± 0.28                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.237 ± 0.018 ms    | 0.234 ± 0.022 ms    | 1.01 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 22.5 ± 1.5 μs       | 23.7 ± 0.89 μs      | 0.951 ± 0.072              |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 27.1 ± 3.5 μs       | 0.0341 ± 0.0035 ms  | 0.793 ± 0.13               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 0.701 ± 0.25 ms     | 0.686 ± 0.035 ms    | 1.02 ± 0.37                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 30.3 ± 2.2 μs       | 22.3 ± 0.85 μs      | 1.36 ± 0.11                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.406 ± 0.044 ms    | 0.409 ± 0.088 ms    | 0.992 ± 0.24               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 18.6 ± 1.4 μs       | 17 ± 0.96 μs        | 1.09 ± 0.1                 |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0553 ± 0.0036 ms  | 0.0555 ± 0.0043 ms  | 0.997 ± 0.1                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.07 ± 0.17 ms      | 0.985 ± 0.086 ms    | 1.08 ± 0.2                 |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 26.1 ± 2.2 μs       | 17.7 ± 2.6 μs       | 1.47 ± 0.25                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 0.867 ± 0.082 ms    | 0.156 ± 0.0073 ms   | 5.56 ± 0.59                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 0.664 ± 0.081 ms    | 0.225 ± 0.01 ms     | 2.95 ± 0.38                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.0416 ± 0.0035 ms  | 25.7 ± 4.1 μs       | 1.62 ± 0.29                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.0619 ± 0.0068 ms  | 30.4 ± 1.8 μs       | 2.04 ± 0.25                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.352 ± 0.067 ms    | 0.0455 ± 0.027 ms   | 7.73 ± 4.9                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.378 ± 0.058 ms    | 0.0808 ± 0.024 ms   | 4.68 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0485 ± 0.0099 ms  | 0.0372 ± 0.0047 ms  | 1.31 ± 0.31                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.0674 ± 0.0049 ms  | 0.0427 ± 0.003 ms   | 1.58 ± 0.16                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.555 ± 0.14 ms     | 0.133 ± 0.0079 ms   | 4.19 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 0.489 ± 0.046 ms    | 0.178 ± 0.0095 ms   | 2.74 ± 0.3                 |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.264 ± 0.013 ms    | 0.258 ± 0.022 ms    | 1.02 ± 0.1                 |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.035 ± 0.0014 ms   | 27.4 ± 0.91 μs      | 1.28 ± 0.068               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0432 ± 0.0095 ms  | 0.0719 ± 0.0055 ms  | 0.602 ± 0.14               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 0.605 ± 0.043 ms    | 0.778 ± 0.065 ms    | 0.777 ± 0.085              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0388 ± 0.0024 ms  | 26.9 ± 1.5 μs       | 1.44 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.243 ± 0.021 ms    | 0.224 ± 0.016 ms    | 1.08 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0323 ± 0.0011 ms  | 31 ± 1.9 μs         | 1.04 ± 0.072               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0372 ± 0.0034 ms  | 0.0389 ± 0.0041 ms  | 0.955 ± 0.13               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 0.73 ± 0.096 ms     | 0.732 ± 0.037 ms    | 0.998 ± 0.14               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.0428 ± 0.003 ms   | 0.0334 ± 0.0016 ms  | 1.28 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0464 ± 0.0052 ms  | 0.0447 ± 0.0019 ms  | 1.04 ± 0.12                |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 21.4 ± 0.75 μs      | 23.4 ± 1.8 μs       | 0.916 ± 0.079              |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 3.95 ± 3.5 μs       | 6.89 ± 2.3 μs       | 0.573 ± 0.54               |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.143 ± 0.0044 ms   | 0.123 ± 0.018 ms    | 1.17 ± 0.18                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 28.2 ± 1.2 μs       | 29.4 ± 2.7 μs       | 0.961 ± 0.099              |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.267 ± 0.012 ms    | 0.232 ± 0.019 ms    | 1.15 ± 0.11                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0401 ± 0.0035 ms  | 0.045 ± 0.002 ms    | 0.891 ± 0.088              |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 31.4 ± 4.4 μs       | 0.0525 ± 0.0033 ms  | 0.598 ± 0.092              |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 0.77 ± 0.048 ms     | 0.711 ± 0.027 ms    | 1.08 ± 0.08                |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.0641 ± 0.0027 ms  | 0.0413 ± 0.0012 ms  | 1.55 ± 0.078               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.0904 ± 0.0045 ms  | 0.0871 ± 0.0072 ms  | 1.04 ± 0.1                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 17.6 ± 1.1 μs       | 24.6 ± 0.97 μs      | 0.715 ± 0.052              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 19 ± 3.6 μs         | 18.1 ± 1.8 μs       | 1.05 ± 0.23                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.225 ± 0.029 ms    | 0.241 ± 0.025 ms    | 0.934 ± 0.16               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 25.3 ± 1.7 μs       | 22.6 ± 1.1 μs       | 1.12 ± 0.093               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.174 ± 0.03 ms     | 0.18 ± 0.034 ms     | 0.966 ± 0.25               |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.039 ± 0.0025 ms   | 24.5 ± 1.1 μs       | 1.59 ± 0.12                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 24 ± 1.9 μs         | 22.9 ± 2.4 μs       | 1.05 ± 0.14                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.441 ± 0.057 ms    | 0.444 ± 0.078 ms    | 0.993 ± 0.22               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0422 ± 0.005 ms   | 31.4 ± 4.3 μs       | 1.34 ± 0.24                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.347 ± 0.042 ms    | 0.249 ± 0.019 ms    | 1.4 ± 0.2                  |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0473 ± 0.0019 ms  | 0.0357 ± 0.0018 ms  | 1.32 ± 0.086               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0435 ± 0.0057 ms  | 0.0365 ± 0.0019 ms  | 1.19 ± 0.17                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 0.967 ± 0.14 ms     | 0.921 ± 0.099 ms    | 1.05 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.0621 ± 0.0066 ms  | 0.0436 ± 0.0026 ms  | 1.43 ± 0.17                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 0.837 ± 0.066 ms    | 0.794 ± 0.17 ms     | 1.05 ± 0.24                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.0365 ± 0.0035 ms  | 0.0323 ± 0.0029 ms  | 1.13 ± 0.15                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.0916 ± 0.0072 ms  | 0.0864 ± 0.0089 ms  | 1.06 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 2.02 ± 0.48 ms      | 2.02 ± 0.44 ms      | 1 ± 0.32                   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0494 ± 0.0064 ms  | 0.0334 ± 0.0021 ms  | 1.48 ± 0.21                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0354 ± 0.00094 ms | 0.0337 ± 0.00084 ms | 1.05 ± 0.038               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 1.36 ± 0.51 μs      | 1.69 ± 0.43 μs      | 0.804 ± 0.36               |
| Evaluation/Matrix overview T200_L20_S3                                                    | 27.9 ± 3.1 μs       | 25 ± 10 μs          | 1.12 ± 0.47                |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 4.26 ± 2.1 μs       | 6.33 ± 1.3 μs       | 0.673 ± 0.36               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.0358 ± 0.0037 ms  | 21.6 ± 1 μs         | 1.66 ± 0.19                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                     | 28.7 ± 2.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                     | 8.38 ± 2.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                     | 0.0332 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                     | 2.45 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                     | 0.0356 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                     | 0.0387 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                     | 22.6 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                     | 0.65 ± 0.088 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                     |                     | 27.3 ± 8.4 μs       |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                     | 0.042 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                     | 0.507 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                     | 0.292 ± 0.014 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                     | 1.83 ± 0.078 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                     | 28.4 ± 0.99 μs      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                     | 0.0362 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                     | 0.0483 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                     | 0.0637 ± 0.0033 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                     | 0.613 ± 0.022 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                     | 31.3 ± 4.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                     | 0.753 ± 0.071 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                     | 0.0795 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                     | 0.0661 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                     | 0.329 ± 0.012 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                     | 0.0392 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                     | 29.6 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                     | 0.948 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                     | 0.0474 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                     | 0.122 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                  |                     | 0.0432 ± 0.0015 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                     | 25.4 ± 3 μs         |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                     | 0.0452 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                     | 0.224 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                     | 0.592 ± 0.19 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                     | 0.0524 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                  |                     | 0.196 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                     | 0.0882 ± 0.015 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                     | 18.9 ± 1.3 μs       |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                     | 0.0628 ± 0.0062 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                     | 0.0443 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                     | 0.0429 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                     | 0.228 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                     | 25.4 ± 0.88 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                     | 0.419 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                     | 0.383 ± 0.009 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                     | 24.4 ± 0.85 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                     | 1.34 ± 0.14 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                     | 0.473 ± 0.042 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                     | 0.97 ± 0.073 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                     | 0.0873 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                     | 0.0334 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                     | 0.0877 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                     | 0.615 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                     | 0.175 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                     | 0.0568 ± 0.0058 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                     | 28.9 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                     | 0.526 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                     | 0.0617 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                     | 7.99 ± 0.98 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                     | 0.617 ± 0.04 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                     | 3.18 ± 0.055 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                     | 0.0513 ± 0.0015 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                     | 0.0467 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                     | 0.23 ± 0.0076 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                |                     | 0.0682 ± 0.0049 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                     | 0.308 ± 0.029 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                     | 31.1 ± 4.1 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                            |                     | 0.185 ± 0.0092 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                     | 0.0372 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                     | 7.92 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                     | 0.0333 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                     | 0.0599 ± 0.0086 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                     | 0.0641 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                     | 0.507 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                     | 0.188 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                     | 0.257 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                     | 0.0414 ± 0.026 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                     | 0.0718 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                     | 0.0515 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                     | 20 ± 0.76 μs        |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                     | 0.0357 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                     | 0.0379 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                     | 26.8 ± 1.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                     | 0.48 ± 0.039 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                     | 1.24 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                     | 0.908 ± 0.057 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                     | 0.0354 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                     | 0.0667 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                     | 24.4 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                     | 0.0511 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                     | 0.89 ± 0.13 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                     | 1.92 ± 0.6 ms       |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                     | 27.3 ± 2.4 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                          |                     | 0.556 ± 0.094 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                     | 0.0351 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                     | 0.0401 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                     | 0.0368 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                     | 22.4 ± 2.5 μs       |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                     | 20.1 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                     | 0.203 ± 0.049 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                     | 0.0693 ± 0.005 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                     | 0.0443 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                     | 0.041 ± 0.0065 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                     | 0.276 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                     | 0.18 ± 0.018 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                            |                     | 0.0397 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                     | 0.68 ± 0.055 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                     | 0.328 ± 0.059 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                     | 0.0567 ± 0.0031 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                     | 6.66 ± 0.74 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                          |                     | 0.0529 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                     | 17.7 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                     | 23 ± 0.98 μs        |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                     | 0.0963 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                     | 2.23 ± 0.12 ms      |                            |
| time_to_load                                                                              | 0.136 ± 0.0028 s    | 0.227 ± 0.0082 s    | 0.598 ± 0.025              |

|                                                                                           | v0.1.0                    | 1e16e72f8dc5ad...         | v0.1.0 / 1e16e72f8dc5ad... |
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
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                           | 4.16 k allocs: 0.358 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                           | 23.3 k allocs: 1.18 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                           | 0.252 k allocs: 17.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                           | 0.66 k allocs: 0.0361 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                           | 0.394 k allocs: 0.0323 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                           | 9.56 k allocs: 0.733 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                           | 0.551 k allocs: 24.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                           | 10.1 k allocs: 0.872 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                           | 0.514 k allocs: 0.191 MB  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                           | 1.04 k allocs: 0.0391 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                           | 4.79 k allocs: 0.356 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                           | 0.986 k allocs: 0.0379 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                           | 14.4 k allocs: 0.88 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                           | 0.835 k allocs: 0.341 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                  |                           | 0.399 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                           | 0.356 k allocs: 26.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                           | 16 k allocs: 0.784 MB     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                           | 0.319 k allocs: 20.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                  |                           | 2.25 k allocs: 0.181 MB   |                            |
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
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                           | 0.816 k allocs: 0.0709 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                           | 0.056 k allocs: 11.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                           | 0.0496 M allocs: 2.58 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                           | 1.1 k allocs: 0.0456 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                           | 0.429 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                           | 3.1 k allocs: 0.275 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                |                           | 1.1 k allocs: 0.0359 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                           | 4.69 k allocs: 0.349 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                           | 0.738 k allocs: 31 kB     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                            |                           | 2.25 k allocs: 0.181 MB   |                            |
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
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                           | 0.921 k allocs: 0.0335 MB |                            |
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
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                          |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                           | 0.341 k allocs: 19.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                           | 0.4 k allocs: 24.8 kB     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                           | 0.572 k allocs: 23.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                           | 0.237 k allocs: 0.0936 MB |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                           | 0.149 k allocs: 6.66 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                           | 0.945 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                           | 0.482 k allocs: 0.189 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                           | 0.471 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                           | 0.278 k allocs: 0.116 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                           | 3.56 k allocs: 0.284 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                           | 3.99 k allocs: 0.145 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                            |                           | 0.349 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                           | 14.7 k allocs: 0.68 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                           | 0.893 k allocs: 0.036 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                          |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                           | 0.207 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                           | 0.366 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                           | 1.34 k allocs: 0.118 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                              | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

