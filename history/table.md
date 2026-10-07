|                                                                                           | v0.1.0             | 9b9a11cd54a14e...   | v0.1.0 / 9b9a11cd54a14e... |
|:------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                | 0.067 ± 0.008 ms   | 0.0697 ± 0.01 ms    | 0.962 ± 0.18               |
| AD gradients/Convolution delay with history/Enzyme reverse                                | 29.8 ± 0.56 μs     | 0.0339 ± 0.0032 ms  | 0.88 ± 0.086               |
| AD gradients/Convolution delay with history/ForwardDiff                                   | 8.96 ± 1.6 μs      | 9.67 ± 1.7 μs       | 0.926 ± 0.23               |
| AD gradients/Convolution delay with history/Mooncake forward                              | 0.215 ± 0.043 ms   | 0.208 ± 0.02 ms     | 1.03 ± 0.23                |
| AD gradients/Convolution delay with history/Mooncake reverse                              | 0.0528 ± 0.003 ms  | 0.0446 ± 0.0033 ms  | 1.18 ± 0.11                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward             | 0.34 ± 0.026 ms    | 0.34 ± 0.017 ms     | 1 ± 0.091                  |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse             | 0.0359 ± 0.0011 ms | 0.0326 ± 0.00073 ms | 1.1 ± 0.041                |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                | 0.037 ± 0.0021 ms  | 0.0365 ± 0.0025 ms  | 1.01 ± 0.092               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward           | 0.957 ± 0.2 ms     | 1.08 ± 0.046 ms     | 0.885 ± 0.19               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse           | 0.0635 ± 0.0029 ms | 0.0446 ± 0.0014 ms  | 1.42 ± 0.079               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                               | 0.624 ± 0.041 ms   | 0.66 ± 0.14 ms      | 0.944 ± 0.2                |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                               | 30.3 ± 3.8 μs      | 29.1 ± 0.77 μs      | 1.04 ± 0.13                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                  | 0.0776 ± 0.0075 ms | 0.0782 ± 0.014 ms   | 0.992 ± 0.2                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                             | 1.82 ± 0.43 ms     | 1.67 ± 0.42 ms      | 1.09 ± 0.38                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                             | 0.0606 ± 0.0034 ms | 0.039 ± 0.0035 ms   | 1.55 ± 0.16                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                  | 1.39 ± 0.071 ms    | 0.315 ± 0.014 ms    | 4.41 ± 0.3                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                | 1.31 ± 0.033 ms    | 0.36 ± 0.086 ms     | 3.63 ± 0.87                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                | 0.063 ± 0.0042 ms  | 0.0409 ± 0.0076 ms  | 1.54 ± 0.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                              | 0.108 ± 0.023 ms   | 0.0595 ± 0.003 ms   | 1.82 ± 0.39                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                   | 0.657 ± 0.025 ms   | 0.126 ± 0.0065 ms   | 5.23 ± 0.33                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                 | 0.662 ± 0.022 ms   | 0.142 ± 0.0033 ms   | 4.66 ± 0.19                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                    | 0.0797 ± 0.017 ms  | 0.0745 ± 0.0061 ms  | 1.07 ± 0.24                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                  | 0.14 ± 0.012 ms    | 0.0839 ± 0.0062 ms  | 1.67 ± 0.19                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                              | 0.972 ± 0.042 ms   | 0.198 ± 0.0082 ms   | 4.92 ± 0.29                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                            | 1.01 ± 0.1 ms      | 0.26 ± 0.013 ms     | 3.88 ± 0.44                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                    | 0.411 ± 0.06 ms    | 0.441 ± 0.052 ms    | 0.934 ± 0.17               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                    | 0.0616 ± 0.0022 ms | 0.0741 ± 0.0014 ms  | 0.832 ± 0.034              |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                       | 0.0564 ± 0.045 ms  | 0.0897 ± 0.006 ms   | 0.629 ± 0.5                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                  | 1.4 ± 0.17 ms      | 1.41 ± 0.036 ms     | 0.99 ± 0.12                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                  | 0.0899 ± 0.0081 ms | 0.0557 ± 0.0025 ms  | 1.62 ± 0.16                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward              | 0.368 ± 0.019 ms   | 0.364 ± 0.035 ms    | 1.01 ± 0.11                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse              | 0.0568 ± 0.0055 ms | 0.0692 ± 0.002 ms   | 0.82 ± 0.083               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                 | 0.0661 ± 0.013 ms  | 0.109 ± 0.006 ms    | 0.609 ± 0.12               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward            | 1.17 ± 0.19 ms     | 1.33 ± 0.03 ms      | 0.878 ± 0.14               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse            | 0.094 ± 0.0058 ms  | 0.0706 ± 0.0018 ms  | 1.33 ± 0.09                |
| AD gradients/Recurrence renewal/Enzyme forward                                            | 0.0695 ± 0.0016 ms | 0.0671 ± 0.0022 ms  | 1.03 ± 0.042               |
| AD gradients/Recurrence renewal/Enzyme reverse                                            | 0.0387 ± 0.0031 ms | 0.0395 ± 0.0036 ms  | 0.98 ± 0.12                |
| AD gradients/Recurrence renewal/ForwardDiff                                               | 13.8 ± 3.4 μs      | 10.7 ± 1.9 μs       | 1.28 ± 0.39                |
| AD gradients/Recurrence renewal/Mooncake forward                                          | 0.229 ± 0.011 ms   | 0.198 ± 0.026 ms    | 1.16 ± 0.16                |
| AD gradients/Recurrence renewal/Mooncake reverse                                          | 0.0744 ± 0.0047 ms | 0.0589 ± 0.0041 ms  | 1.26 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme forward                                | 0.43 ± 0.051 ms    | 0.295 ± 0.034 ms    | 1.46 ± 0.24                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                | 0.0711 ± 0.0066 ms | 0.0639 ± 0.0021 ms  | 1.11 ± 0.11                |
| AD gradients/Recurrence returning its state/ForwardDiff                                   | 0.0605 ± 0.011 ms  | 0.06 ± 0.005 ms     | 1.01 ± 0.2                 |
| AD gradients/Recurrence returning its state/Mooncake forward                              | 1.35 ± 0.027 ms    | 1.24 ± 0.021 ms     | 1.08 ± 0.028               |
| AD gradients/Recurrence returning its state/Mooncake reverse                              | 0.139 ± 0.0048 ms  | 0.0911 ± 0.0024 ms  | 1.53 ± 0.066               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward               | 0.143 ± 0.0091 ms  | 0.137 ± 0.0076 ms   | 1.05 ± 0.088               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse               | 28.3 ± 4 μs        | 0.048 ± 0.0015 ms   | 0.588 ± 0.085              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                  | 26.2 ± 1.4 μs      | 25 ± 1.1 μs         | 1.05 ± 0.074               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward             | 0.38 ± 0.077 ms    | 0.394 ± 0.018 ms    | 0.964 ± 0.2                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse             | 0.0555 ± 0.0023 ms | 0.0578 ± 0.0064 ms  | 0.959 ± 0.11               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                    | 0.26 ± 0.038 ms    | 0.23 ± 0.031 ms     | 1.13 ± 0.22                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                    | 0.0778 ± 0.0034 ms | 0.0409 ± 0.00096 ms | 1.9 ± 0.095                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                       | 0.033 ± 0.0023 ms  | 0.0619 ± 0.031 ms   | 0.533 ± 0.27               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                  | 0.795 ± 0.14 ms    | 0.881 ± 0.014 ms    | 0.902 ± 0.16               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                  | 0.0901 ± 0.005 ms  | 0.0632 ± 0.002 ms   | 1.43 ± 0.091               |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                     | 0.528 ± 0.025 ms   | 0.344 ± 0.038 ms    | 1.53 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                     | 0.0907 ± 0.0068 ms | 0.0584 ± 0.0015 ms  | 1.55 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                        | 0.0666 ± 0.0034 ms | 0.0595 ± 0.0057 ms  | 1.12 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                   | 1.86 ± 0.3 ms      | 1.49 ± 0.025 ms     | 1.25 ± 0.21                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                   | 0.135 ± 0.0085 ms  | 0.0922 ± 0.0023 ms  | 1.47 ± 0.099               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                   | 1.24 ± 0.1 ms      | 1.07 ± 0.22 ms      | 1.15 ± 0.26                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                   | 0.0628 ± 0.0064 ms | 0.0544 ± 0.002 ms   | 1.16 ± 0.13                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                      | 0.128 ± 0.0082 ms  | 0.13 ± 0.007 ms     | 0.983 ± 0.082              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                 | 3.39 ± 0.63 ms     | 4.18 ± 0.19 ms      | 0.812 ± 0.16               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                 | 0.0951 ± 0.0056 ms | 0.0699 ± 0.0028 ms  | 1.36 ± 0.097               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                   | 0.0713 ± 0.002 ms  | 0.0635 ± 0.0015 ms  | 1.12 ± 0.041               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                 | 2.83 ± 2.7 μs      | 2.56 ± 0.74 μs      | 1.11 ± 1.1                 |
| Evaluation/Matrix overview T200_L20_S3                                                    | 0.0521 ± 0.0032 ms | 0.0479 ± 0.004 ms   | 1.09 ± 0.11                |
| Evaluation/Matrix renewal T200_L20_S1                                                     | 9.87 ± 1.7 μs      | 10.1 ± 2 μs         | 0.981 ± 0.26               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                               | 0.067 ± 0.0036 ms  | 0.0393 ± 0.00083 ms | 1.7 ± 0.098                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse |                    | 0.0678 ± 0.0077 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                     |                    | 12.4 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse            |                    | 0.14 ± 0.0056 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse    |                    | 0.0544 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward      |                    | 3 ± 0.04 ms         |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                          |                    | 0.0547 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse            |                    | 0.0868 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse   |                    | 0.048 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward              |                    | 0.96 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                     |                    | 0.0657 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff      |                    | 0.0496 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                  |                    | 0.954 ± 0.0099 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                      |                    | 0.409 ± 0.047 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                |                    | 2.56 ± 0.081 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                        |                    | 0.0459 ± 0.0011 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward               |                    | 1.07 ± 0.051 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse  |                    | 0.0812 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                      |                    | 0.0699 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                      |                    | 0.115 ± 0.0018 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                        |                    | 0.91 ± 0.12 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse            |                    | 0.0575 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward         |                    | 1.08 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff           |                    | 0.126 ± 0.0065 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse      |                    | 0.141 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                |                    | 0.445 ± 0.041 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                        |                    | 0.0884 ± 0.0035 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                        |                    | 0.138 ± 0.003 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                    | 0.0696 ± 0.0045 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                 |                    | 0.125 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                 |                    | 0.154 ± 0.0085 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                    |                    | 1.71 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                          |                    | 0.0783 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff            |                    | 0.254 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                  |                    | 0.0771 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward              |                    | 0.0637 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse       |                    | 0.103 ± 0.0036 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward    |                    | 0.298 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                        |                    | 1.25 ± 0.087 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                |                    | 0.0809 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                  |                    | 0.405 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                 |                    | 0.146 ± 0.0061 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff        |                    | 26.2 ± 27 μs        |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff          |                    | 0.0426 ± 0.0034 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward            |                    | 0.14 ± 0.0078 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                         |                    | 0.0805 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                      |                    | 0.068 ± 0.0042 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward   |                    | 0.373 ± 0.081 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse   |                    | 0.0629 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                     |                    | 0.697 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                       |                    | 0.716 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                  |                    | 0.0395 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward              |                    | 0.741 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                    | 6 ± 0.19 ms         |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                    | 0.732 ± 0.026 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                    | 1.42 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                    | 0.173 ± 0.0081 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                    | 0.0506 ± 0.0011 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                      |                    | 0.125 ± 0.0059 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                    | 0.133 ± 0.006 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                    |                    | 0.0453 ± 0.0084 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse               |                    | 0.118 ± 0.0048 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                    | 1.31 ± 0.016 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                    | 0.299 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                    | 0.112 ± 0.0038 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                    | 0.0349 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward            |                    | 3.19 ± 0.072 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                |                    | 2.79 ± 0.035 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                    |                    | 0.115 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff       |                    | 10.8 ± 1.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                        |                    | 0.976 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward       |                    | 4.63 ± 0.075 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                |                    | 0.13 ± 0.0087 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                  |                    | 0.101 ± 0.0025 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse       |                    | 0.0703 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward   |                    | 0.389 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                |                    | 0.151 ± 0.0062 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                          |                    | 0.471 ± 0.036 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                      |                    | 0.064 ± 0.0018 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                            |                    | 0.257 ± 0.041 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                 |                    | 0.26 ± 0.018 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                        |                    | 0.0847 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                         |                    | 11.2 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse              |                    | 0.0933 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                    | 0.0526 ± 0.00097 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                    | 0.0718 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                    | 0.0798 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                    | 0.94 ± 0.081 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                    | 0.292 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                    | 0.368 ± 0.048 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                           |                    | 0.171 ± 0.0087 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                    | 0.0659 ± 0.04 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                    | 0.128 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse     |                    | 0.129 ± 0.0042 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                    | 0.113 ± 0.003 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                        |                    | 0.971 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                     |                    | 0.0443 ± 0.00099 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                             |                    | 0.0544 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse           |                    | 0.0641 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                    |                    | 0.0571 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward        |                    | 0.645 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward              |                    | 1.95 ± 0.03 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward |                    | 2.45 ± 0.043 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                        |                    | 0.0848 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                        |                    | 0.0943 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                   |                    | 0.0598 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse        |                    | 0.0952 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward         |                    | 1.69 ± 0.025 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                      |                    | 3.07 ± 0.05 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse              |                    | 0.127 ± 0.0043 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                          |                    | 1.19 ± 0.028 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                          |                    | 0.0606 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse         |                    | 0.0602 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse  |                    | 0.0848 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward       |                    | 0.237 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                             |                    | 0.0405 ± 0.0061 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                      |                    | 0.0349 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                         |                    | 0.351 ± 0.054 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                     |                    | 0.11 ± 0.0096 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                             |                    | 0.06 ± 0.0022 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff       |                    | 0.0536 ± 0.0087 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward           |                    | 0.366 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                |                    | 0.257 ± 0.032 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                            |                    | 0.0697 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward  |                    | 1.15 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                    |                    | 0.442 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                    |                    | 0.114 ± 0.0023 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                 |                    | 0.106 ± 0.0034 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                          |                    | 0.134 ± 0.005 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                      |                    | 3.46 ± 0.088 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                    | 30 ± 3.9 μs         |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward     |                    | 1.21 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                    | 0.0331 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                    | 0.142 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                    | 3.69 ± 0.076 ms     |                            |
| time_to_load                                                                              | 0.242 ± 0.00098 s  | 0.367 ± 0.0052 s    | 0.658 ± 0.0097             |

|                                                                                           | v0.1.0                    | 9b9a11cd54a14e...         | v0.1.0 / 9b9a11cd54a14e... |
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
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse            |                           | 1.21 k allocs: 0.0457 MB  |                            |
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
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                        |                           | 0.53 k allocs: 0.0355 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                 |                           | 0.355 k allocs: 16.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                 |                           | 0.668 k allocs: 0.227 MB  |                            |
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
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward              |                           | 7.21 k allocs: 0.566 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                   |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                  |                           | 5.97 k allocs: 0.467 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                        |                           | 21.6 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                        |                           | 0.689 k allocs: 0.036 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse    |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                      |                           | 1.26 k allocs: 0.0518 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                           |                           | 0.802 k allocs: 0.298 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                    |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse               |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                      |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                          |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse              |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                               |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward            |                           | 0.0319 M allocs: 1.54 MB  |                            |
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
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse              |                           | 0.47 k allocs: 31.3 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse              |                           | 0.321 k allocs: 19.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                  |                           | 0.82 k allocs: 0.0411 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                   |                           | 0.499 k allocs: 0.176 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                        |                           | 2.83 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                    |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                          |                           | 2.89 k allocs: 0.257 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                           |                           | 0.632 k allocs: 0.223 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff              |                           | 0.338 k allocs: 0.136 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward  |                           | 1.18 k allocs: 0.0635 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse     |                           | 0.97 k allocs: 0.0321 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse         |                           | 0.921 k allocs: 0.0335 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                        |                           | 7.09 k allocs: 0.551 MB   |                            |
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
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                      |                           | 30.8 k allocs: 1.46 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse     |                           | 0.207 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward     |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward    |                           | 0.366 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward     |                           | 1.34 k allocs: 0.118 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward            |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                              | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

