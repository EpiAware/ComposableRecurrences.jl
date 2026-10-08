|                                                                                             | v0.1.0              | 66943d4c9210e2...   | v0.1.0 / 66943d4c9210e2... |
|:--------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0544 ± 0.0075 ms  | 0.0508 ± 0.0056 ms  | 1.07 ± 0.19                |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 24 ± 0.63 μs        | 24.8 ± 1.5 μs       | 0.969 ± 0.062              |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 8.34 ± 3.5 μs       | 3.9 ± 4.3 μs        | 2.14 ± 2.5                 |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.194 ± 0.031 ms    | 0.185 ± 0.0047 ms   | 1.05 ± 0.17                |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.0354 ± 0.00092 ms | 0.0325 ± 0.0036 ms  | 1.09 ± 0.12                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                     | 0.21 ± 0.008 ms     | 0.212 ± 0.014 ms    | 0.991 ± 0.076              |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                     | 0.033 ± 0.00088 ms  | 27 ± 0.84 μs        | 1.22 ± 0.05                |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                        | 0.04 ± 0.037 ms     | 0.0332 ± 0.035 ms   | 1.21 ± 1.7                 |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                   | 0.679 ± 0.19 ms     | 0.743 ± 0.034 ms    | 0.913 ± 0.26               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                   | 0.0422 ± 0.0012 ms  | 31.2 ± 1.6 μs       | 1.35 ± 0.078               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.294 ± 0.014 ms    | 0.3 ± 0.013 ms      | 0.982 ± 0.065              |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 28.6 ± 0.99 μs      | 26.8 ± 0.88 μs      | 1.06 ± 0.051               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.039 ± 0.0018 ms   | 0.0397 ± 0.0041 ms  | 0.983 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.763 ± 0.075 ms    | 0.883 ± 0.052 ms    | 0.864 ± 0.099              |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.0436 ± 0.003 ms   | 30.7 ± 0.89 μs      | 1.42 ± 0.11                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.542 ± 0.032 ms    | 0.536 ± 0.026 ms    | 1.01 ± 0.077               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 24.1 ± 1.3 μs       | 21.9 ± 0.89 μs      | 1.1 ± 0.073                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0812 ± 0.0053 ms  | 0.0764 ± 0.005 ms   | 1.06 ± 0.098               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.58 ± 0.17 ms      | 0.986 ± 0.12 ms     | 1.6 ± 0.26                 |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.0364 ± 0.0019 ms  | 23.8 ± 1 μs         | 1.53 ± 0.1                 |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.369 ± 0.015 ms    | 0.739 ± 0.29 ms     | 0.5 ± 0.2                  |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.642 ± 0.25 ms     | 0.648 ± 0.27 ms     | 0.991 ± 0.57               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 13 ± 3.7 ms         | 13.4 ± 4.2 ms       | 0.967 ± 0.41               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 0.0435 ± 0.013 s    | 0.0445 ± 0.01 s     | 0.978 ± 0.36               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 1.15 ± 0.25 ms      | 0.256 ± 0.0089 ms   | 4.5 ± 0.97                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.057 ± 0.0056 s    | 0.0494 ± 0.0023 s   | 1.15 ± 0.13                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 0.906 ± 0.011 ms    | 0.27 ± 0.0099 ms    | 3.36 ± 0.13                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 27.6 ± 8.9 μs       | 10.8 ± 5.8 μs       | 2.55 ± 1.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 1.31 ± 0.57 ms      | 0.428 ± 0.57 ms     | 3.06 ± 4.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.0546 ± 0.0041 ms  | 15.5 ± 2.3 μs       | 3.51 ± 0.58                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.0545 ± 0.014 ms   | 31.5 ± 6.5 μs       | 1.73 ± 0.57                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 1.47 ± 0.012 ms     | 0.475 ± 0.08 ms     | 3.09 ± 0.52                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.0839 ± 0.0045 ms  | 0.042 ± 0.0027 ms   | 2 ± 0.17                   |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.555 ± 0.037 ms    | 0.0742 ± 0.0028 ms  | 7.48 ± 0.58                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 27.7 ± 1.1 ms       | 14.6 ± 7.1 ms       | 1.9 ± 0.93                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.492 ± 0.017 ms    | 0.0922 ± 0.0038 ms  | 5.33 ± 0.29                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0716 ± 0.012 ms   | 0.0505 ± 0.0067 ms  | 1.42 ± 0.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 1.99 ± 0.58 ms      | 1.03 ± 0.56 ms      | 1.94 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.114 ± 0.012 ms    | 0.0589 ± 0.0088 ms  | 1.93 ± 0.35                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.74 ± 0.048 ms     | 0.361 ± 0.032 ms    | 2.05 ± 0.23                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 0.0403 ± 0.012 s    | 0.043 ± 0.00041 s   | 0.939 ± 0.28               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.654 ± 0.02 ms     | 0.232 ± 0.0097 ms   | 2.82 ± 0.15                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                          | 0.918 ± 0.036 ms    | 0.82 ± 0.077 ms     | 1.12 ± 0.11                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                          | 0.104 ± 0.011 ms    | 0.0679 ± 0.0019 ms  | 1.53 ± 0.17                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                             | 0.113 ± 0.012 ms    | 0.113 ± 0.0075 ms   | 1.01 ± 0.13                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                        | 2.51 ± 0.36 ms      | 2.41 ± 0.04 ms      | 1.04 ± 0.15                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                        | 0.118 ± 0.0055 ms   | 0.0889 ± 0.0058 ms  | 1.32 ± 0.11                |
| AD gradients/Recurrence in Float32/Enzyme forward                                           | 0.207 ± 0.025 ms    | 0.188 ± 0.019 ms    | 1.11 ± 0.18                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                           | 0.0409 ± 0.00089 ms | 0.036 ± 0.0027 ms   | 1.14 ± 0.089               |
| AD gradients/Recurrence in Float32/ForwardDiff                                              | 0.0443 ± 0.0048 ms  | 0.0433 ± 0.0033 ms  | 1.02 ± 0.13                |
| AD gradients/Recurrence in Float32/Mooncake forward                                         | 0.727 ± 0.046 ms    | 0.578 ± 0.028 ms    | 1.26 ± 0.1                 |
| AD gradients/Recurrence in Float32/Mooncake reverse                                         | 0.0533 ± 0.0013 ms  | 0.0452 ± 0.0031 ms  | 1.18 ± 0.086               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.324 ± 0.052 ms    | 0.36 ± 0.03 ms      | 0.899 ± 0.16               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.046 ± 0.0029 ms   | 0.0326 ± 0.00094 ms | 1.41 ± 0.098               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0664 ± 0.013 ms   | 0.0778 ± 0.0044 ms  | 0.853 ± 0.18               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 1.1 ± 0.052 ms      | 1.33 ± 0.03 ms      | 0.83 ± 0.043               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0534 ± 0.0013 ms  | 0.0382 ± 0.002 ms   | 1.4 ± 0.081                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.303 ± 0.014 ms    | 0.276 ± 0.028 ms    | 1.1 ± 0.12                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.0413 ± 0.0033 ms  | 0.0384 ± 0.0011 ms  | 1.08 ± 0.09                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.056 ± 0.01 ms     | 0.0513 ± 0.0061 ms  | 1.09 ± 0.24                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 1.03 ± 0.16 ms      | 0.837 ± 0.04 ms     | 1.23 ± 0.2                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0641 ± 0.0042 ms  | 0.0462 ± 0.0013 ms  | 1.39 ± 0.1                 |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0572 ± 0.0016 ms  | 0.0574 ± 0.0018 ms  | 0.997 ± 0.042              |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 30.9 ± 2.4 μs       | 0.0319 ± 0.0031 ms  | 0.969 ± 0.12               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 10.9 ± 2.6 μs       | 9.63 ± 2.7 μs       | 1.13 ± 0.42                |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.183 ± 0.012 ms    | 0.165 ± 0.02 ms     | 1.11 ± 0.15                |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.0489 ± 0.0033 ms  | 0.0394 ± 0.0036 ms  | 1.24 ± 0.14                |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.345 ± 0.037 ms    | 0.26 ± 0.018 ms     | 1.33 ± 0.17                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.05 ± 0.0032 ms    | 0.0465 ± 0.0012 ms  | 1.07 ± 0.074               |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0526 ± 0.008 ms   | 0.0566 ± 0.012 ms   | 0.93 ± 0.24                |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 0.961 ± 0.018 ms    | 0.934 ± 0.021 ms    | 1.03 ± 0.03                |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.0921 ± 0.0047 ms  | 0.0602 ± 0.002 ms   | 1.53 ± 0.093               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.121 ± 0.012 ms    | 0.113 ± 0.0069 ms   | 1.08 ± 0.13                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 22.9 ± 3.1 μs       | 30.2 ± 1.1 μs       | 0.759 ± 0.11               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 30.6 ± 1.8 μs       | 24.3 ± 2.2 μs       | 1.26 ± 0.14                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.259 ± 0.12 ms     | 0.321 ± 0.019 ms    | 0.806 ± 0.39               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.0339 ± 0.0014 ms  | 0.0335 ± 0.0047 ms  | 1.01 ± 0.15                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.217 ± 0.026 ms    | 0.208 ± 0.025 ms    | 1.05 ± 0.18                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0559 ± 0.0031 ms  | 0.0324 ± 0.00085 ms | 1.73 ± 0.11                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.0326 ± 0.0021 ms  | 0.0332 ± 0.02 ms    | 0.984 ± 0.59               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.635 ± 0.08 ms     | 0.674 ± 0.023 ms    | 0.942 ± 0.12               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0592 ± 0.0039 ms  | 0.0399 ± 0.0012 ms  | 1.48 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.435 ± 0.02 ms     | 0.305 ± 0.024 ms    | 1.43 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0626 ± 0.0024 ms  | 0.0461 ± 0.0012 ms  | 1.36 ± 0.064               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0613 ± 0.0037 ms  | 0.0583 ± 0.0087 ms  | 1.05 ± 0.17                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.33 ± 0.11 ms      | 1.15 ± 0.021 ms     | 1.16 ± 0.1                 |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.0948 ± 0.0068 ms  | 0.0617 ± 0.0019 ms  | 1.54 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 0.83 ± 0.27 ms      | 1.56 ± 0.16 ms      | 0.531 ± 0.18               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0465 ± 0.0025 ms  | 0.0418 ± 0.0041 ms  | 1.11 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.126 ± 0.0069 ms   | 0.143 ± 0.014 ms    | 0.88 ± 0.098               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 3.06 ± 0.66 ms      | 3.12 ± 0.49 ms      | 0.981 ± 0.26               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0658 ± 0.0049 ms  | 0.0499 ± 0.0039 ms  | 1.32 ± 0.14                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0534 ± 0.001 ms   | 0.0465 ± 0.001 ms   | 1.15 ± 0.033               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 3.95 ± 0.38 μs      | 4.02 ± 0.34 μs      | 0.983 ± 0.13               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 2.68 ± 1.5 μs       | 2.14 ± 0.42 μs      | 1.25 ± 0.73                |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.0423 ± 0.0099 ms  | 0.0408 ± 0.014 ms   | 1.04 ± 0.42                |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 7.83 ± 1.7 μs       | 8.4 ± 1.7 μs        | 0.932 ± 0.28               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.0533 ± 0.003 ms   | 30.2 ± 0.88 μs      | 1.76 ± 0.11                |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                     | 0.0902 ± 0.0062 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                     | 0.0414 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                     | 1.99 ± 0.038 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                     | 0.0322 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                     | 0.347 ± 0.01 ms     |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                     | 0.042 ± 0.0014 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                     | 0.0463 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                     | 0.763 ± 0.0093 ms   |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                     | 1.11 ± 0.36 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                     | 0.286 ± 0.028 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                     | 1.81 ± 0.26 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                     | 0.0354 ± 0.00088 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                     | 0.676 ± 0.15 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                     | 0.0533 ± 0.0062 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                     | 0.0389 ± 0.0012 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                     | 3.75 ± 0.083 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                     | 0.0391 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                     | 0.996 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                     | 0.109 ± 0.006 ms    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward           |                     | 0.211 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                 |                     | 0.204 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                     | 0.0916 ± 0.0029 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                     | 0.0564 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                     | 0.374 ± 0.027 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                     | 0.0564 ± 0.0016 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                     | 0.215 ± 0.02 ms     |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                     | 0.0465 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                               |                     | 0.0526 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                     | 0.13 ± 0.0057 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                     | 2.12 ± 0.33 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                     | 1.04 ± 0.034 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                     | 0.0538 ± 0.0011 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                     | 0.673 ± 0.038 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                     | 1.1 ± 0.061 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward         |                     | 0.672 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                     | 1.27 ± 0.071 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                     | 27.6 ± 0.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                     | 0.22 ± 0.032 ms     |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                     | 0.0392 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                     | 0.0459 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                     | 0.0643 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                     | 31.3 ± 1 μs         |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                     | 1.03 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                     | 29.7 ± 0.79 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                     | 0.543 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                     | 31.3 ± 3.2 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                     | 0.589 ± 0.038 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                     | 1.39 ± 0.33 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                |                     | 0.0897 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                     | 0.139 ± 0.005 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                     | 0.0827 ± 0.0042 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                     | 0.0448 ± 0.0018 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                     | 0.0376 ± 0.0089 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                     | 0.0733 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward           |                     | 0.225 ± 0.032 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff              |                     | 30 ± 1.8 μs         |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                     | 0.252 ± 0.018 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                     | 0.324 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                     | 0.0681 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                     | 0.827 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                     | 0.699 ± 0.078 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                     | 3.08 ± 0.083 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                     | 30.1 ± 0.75 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                     | 0.0584 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                     | 0.298 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                     | 0.0964 ± 0.0031 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                     | 0.401 ± 0.04 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                     | 0.206 ± 0.028 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                     | 0.208 ± 0.0093 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                     | 0.0397 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                     | 0.045 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                     | 0.0523 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                     | 0.0396 ± 0.00089 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                     | 0.357 ± 0.039 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                     | 0.109 ± 0.0064 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                     | 0.0797 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                     | 24.2 ± 0.73 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                     | 0.072 ± 0.0036 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                     | 0.827 ± 0.088 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                     | 0.0476 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                     | 0.542 ± 0.065 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                     | 1.29 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff              |                     | 0.0363 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                     | 0.0862 ± 0.0087 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                     | 0.0353 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                     | 0.0678 ± 0.0017 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                     | 2.54 ± 0.11 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                     | 0.916 ± 0.081 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                     | 0.0515 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                    |                     | 29 ± 15 μs          |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                     | 0.0467 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                     | 0.199 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                     | 0.0339 ± 0.029 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                     | 0.23 ± 0.043 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                     | 0.0599 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                     | 0.0526 ± 0.0064 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse         |                     | 0.0406 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                     | 0.304 ± 0.025 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                     | 0.333 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                     | 0.0672 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                     | 0.189 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                     | 0.418 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                 |                     | 0.0394 ± 0.0022 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                     | 0.085 ± 0.0028 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                |                     | 0.896 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                     | 0.121 ± 0.0088 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                     | 0.0402 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                     | 11 ± 2.3 μs         |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse              |                     | 0.117 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                     | 0.0417 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                     | 0.0527 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                     | 0.855 ± 0.099 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                     | 0.0325 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                     | 0.0598 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                     | 0.0556 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                     | 0.0527 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                     | 0.0496 ± 0.0012 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                     | 0.841 ± 0.092 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward              |                     | 2.59 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                     | 0.651 ± 0.014 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                     | 0.0691 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                     | 0.046 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                     | 0.0626 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                               |                     | 0.723 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                     | 0.148 ± 0.0063 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                     | 27.8 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                     | 0.0447 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                     | 0.0627 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                     | 0.282 ± 0.013 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                     |                     | 0.0377 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                     | 0.0585 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                     | 0.122 ± 0.096 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                     | 0.94 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                     | 0.0421 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse         |                     | 0.0511 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                     | 0.0891 ± 0.0084 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                     | 0.0543 ± 0.0034 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                     | 0.0591 ± 0.027 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                     | 0.296 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                     | 0.229 ± 0.0087 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                     | 0.579 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                     | 0.628 ± 0.047 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                     | 0.306 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                     | 1.79 ± 0.17 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                     | 0.0408 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                     | 0.0373 ± 0.00092 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                     | 0.13 ± 0.0062 ms    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                     | 0.047 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                     | 0.978 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse           |                     | 31.1 ± 0.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                     | 0.158 ± 0.011 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                     | 0.0371 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                     | 2.01 ± 0.035 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                     | 0.0859 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                     | 9.8 ± 1.4 μs        |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                     | 0.0902 ± 0.0068 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                     | 0.0378 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                     | 0.0472 ± 0.001 ms   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                     | 0.166 ± 0.017 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                     | 0.041 ± 0.0012 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                     | 0.0493 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                     | 0.0576 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                     | 0.0499 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                     | 9.83 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                     | 0.0662 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                     | 0.0597 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                     | 0.0667 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                     | 0.912 ± 0.071 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                     | 0.206 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                     | 0.0567 ± 0.03 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                     | 0.436 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                     | 0.0862 ± 0.0094 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                     | 0.0724 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                     | 0.636 ± 0.089 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                     | 0.038 ± 0.0023 ms   |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                     | 27.7 ± 0.95 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                     | 1.07 ± 0.062 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                     | 0.0523 ± 0.0016 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                     | 0.044 ± 0.0014 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                     | 1.17 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                     | 0.583 ± 0.082 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                     | 0.0385 ± 0.0026 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                     | 0.818 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                     | 28.1 ± 2.7 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                     | 0.0467 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                     | 0.307 ± 0.049 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                     | 0.0411 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                     | 0.0525 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                     | 0.067 ± 0.0069 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                     | 27.5 ± 0.92 μs      |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                     | 0.972 ± 0.023 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                     | 0.104 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                     | 26.3 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                     | 0.0957 ± 0.0054 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                     | 0.0802 ± 0.0051 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                     | 0.0485 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                     | 1.19 ± 0.071 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                     | 1.07 ± 0.061 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                     | 0.959 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                     | 3.55 ± 0.088 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                     | 0.338 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                     | 0.0475 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                     | 0.0759 ± 0.0022 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                     | 9.25 ± 1 μs         |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                     | 2.29 ± 0.17 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                   |                     | 0.102 ± 0.0041 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                     | 0.0474 ± 0.018 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                     | 22.4 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                     | 0.881 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                     | 28.1 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                     | 2.88 ± 0.13 ms      |                            |
| time_to_load                                                                                | 0.185 ± 0.00092 s   | 0.272 ± 0.00072 s   | 0.681 ± 0.0038             |

|                                                                                             | v0.1.0                    | 66943d4c9210e2...         | v0.1.0 / 66943d4c9210e2... |
|:--------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 0.147 k allocs: 7.97 kB   | 0.157 k allocs: 8.25 kB   | 0.966                      |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                     | 1.94 k allocs: 0.195 MB   | 1.94 k allocs: 0.195 MB   | 1                          |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                     | 0.204 k allocs: 18 kB     | 0.166 k allocs: 12.6 kB   | 1.43                       |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                        | 0.188 k allocs: 0.113 MB  | 0.188 k allocs: 0.113 MB  | 1                          |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                   | 13.7 k allocs: 0.635 MB   | 10.8 k allocs: 0.558 MB   | 1.14                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                   | 0.829 k allocs: 31.1 kB   | 0.585 k allocs: 22.2 kB   | 1.4                        |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 2.99 k allocs: 0.267 MB   | 2.99 k allocs: 0.267 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.15 k allocs: 11.9 kB    | 0.17 k allocs: 12.7 kB    | 0.942                      |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 4.7 k allocs: 0.505 MB    | 4.7 k allocs: 0.505 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 0.122 k allocs: 12.5 kB   | 0.139 k allocs: 11.6 kB   | 1.08                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 3.26 k allocs: 0.495 MB   | 0.556 k allocs: 0.163 MB  | 3.03                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 8.89 k allocs: 0.0511 GB  | 7.26 k allocs: 0.0492 GB  | 1.04                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 9.4 k allocs: 0.381 MB    | 1.34 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.054 k allocs: 0.0376 MB | 0.051 k allocs: 19.4 kB   | 1.98                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.161 k allocs: 0.0396 MB | 0.166 k allocs: 22 kB     | 1.85                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 1.53 k allocs: 0.294 MB   | 0.214 k allocs: 0.101 MB  | 2.9                        |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 2.1 k allocs: 24.8 MB     | 1.7 k allocs: 24.2 MB     | 1.03                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 5.84 k allocs: 0.353 MB   | 0.16 k allocs: 0.1 MB     | 3.51                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.18 k allocs: 0.0375 MB  | 0.22 k allocs: 29 kB      | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 2.31 k allocs: 0.0849 MB  | 0.67 k allocs: 0.0404 MB  | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 1.53 k allocs: 0.308 MB   | 0.386 k allocs: 0.14 MB   | 2.2                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 6.2 k allocs: 0.0508 GB   | 5.43 k allocs: 0.0489 GB  | 1.04                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 9.06 k allocs: 0.369 MB   | 0.994 k allocs: 0.156 MB  | 2.37                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                          | 8.54 k allocs: 0.784 MB   | 8.1 k allocs: 0.748 MB    | 1.05                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                          | 0.652 k allocs: 0.0473 MB | 0.487 k allocs: 0.0391 MB | 1.21                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                             | 0.713 k allocs: 0.321 MB  | 0.659 k allocs: 0.298 MB  | 1.08                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                        | 0.0394 M allocs: 1.95 MB  | 0.0373 M allocs: 1.89 MB  | 1.03                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                        | 1.69 k allocs: 0.0622 MB  | 1.38 k allocs: 0.0631 MB  | 0.986                      |
| AD gradients/Recurrence in Float32/Enzyme forward                                           | 2.77 k allocs: 0.162 MB   | 2.54 k allocs: 0.148 MB   | 1.09                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                           | 0.295 k allocs: 16.2 kB   | 0.241 k allocs: 12.2 kB   | 1.33                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                              | 0.222 k allocs: 0.0645 MB | 0.192 k allocs: 0.0578 MB | 1.11                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                         | 11.5 k allocs: 0.443 MB   | 10.3 k allocs: 0.411 MB   | 1.08                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                         | 1.02 k allocs: 0.033 MB   | 0.697 k allocs: 25.1 kB   | 1.34                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 3.14 k allocs: 0.279 MB   | 3.13 k allocs: 0.314 MB   | 0.887                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.246 k allocs: 20 kB     | 0.212 k allocs: 16.2 kB   | 1.23                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.303 k allocs: 0.154 MB  | 0.317 k allocs: 0.187 MB  | 0.824                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 17.4 k allocs: 0.834 MB   | 16.2 k allocs: 0.89 MB    | 0.938                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.691 k allocs: 26.1 kB   | 0.675 k allocs: 28.7 kB   | 0.911                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 3.18 k allocs: 0.261 MB   | 2.9 k allocs: 0.239 MB    | 1.1                        |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.8 kB   | 0.91                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.29 k allocs: 0.13 MB    | 0.26 k allocs: 0.115 MB   | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 15.7 k allocs: 0.716 MB   | 14.3 k allocs: 0.658 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 1.15 k allocs: 0.0397 MB  | 0.847 k allocs: 0.0331 MB | 1.2                        |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.176 k allocs: 7.66 kB   | 0.22 k allocs: 10 kB      | 0.762                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 4.09 k allocs: 0.137 MB   | 3.73 k allocs: 0.131 MB   | 1.05                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.809 k allocs: 25.5 kB   | 0.677 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 3.93 k allocs: 0.263 MB   | 3.3 k allocs: 0.237 MB    | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.336 k allocs: 21.5 kB   | 0.392 k allocs: 21.3 kB   | 1.01                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.287 k allocs: 0.125 MB  | 0.277 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 15.9 k allocs: 0.718 MB   | 12.2 k allocs: 0.623 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 1.3 k allocs: 0.0436 MB   | 0.931 k allocs: 0.0355 MB | 1.23                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 1.5 k allocs: 0.132 MB    | 1.33 k allocs: 0.119 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 0.198 k allocs: 15.6 kB   | 0.272 k allocs: 21.2 kB   | 0.737                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 0.174 k allocs: 0.0836 MB | 0.15 k allocs: 0.0748 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 5.38 k allocs: 0.321 MB   | 4.56 k allocs: 0.291 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.39 k allocs: 16.1 kB    | 0.47 k allocs: 25 kB      | 0.645                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 2.74 k allocs: 0.209 MB   | 2.5 k allocs: 0.189 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.382 k allocs: 21.7 kB   | 0.227 k allocs: 14.3 kB   | 1.51                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.237 k allocs: 0.105 MB  | 0.207 k allocs: 0.0924 MB | 1.14                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 12.3 k allocs: 0.571 MB   | 11.1 k allocs: 0.527 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 1.02 k allocs: 0.0353 MB  | 0.717 k allocs: 28.3 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 4.32 k allocs: 0.329 MB   | 3.48 k allocs: 0.275 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.382 k allocs: 24.6 kB   | 0.365 k allocs: 23.2 kB   | 1.06                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.338 k allocs: 0.149 MB  | 0.302 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.742 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 1.35 k allocs: 0.046 MB   | 0.985 k allocs: 0.0389 MB | 1.18                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 10.7 k allocs: 0.915 MB   | 9.8 k allocs: 0.841 MB    | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.383 k allocs: 25 kB     | 0.274 k allocs: 21.9 kB   | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.886 k allocs: 0.384 MB  | 0.784 k allocs: 0.337 MB  | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 0.0515 M allocs: 2.58 MB  | 0.0472 M allocs: 2.44 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.863 k allocs: 0.033 MB  | 0.841 k allocs: 0.0346 MB | 0.952                      |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.091 k allocs: 0.0452 MB | 0.073 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.04 k allocs: 0.0395 MB  | 0.034 k allocs: 0.0383 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 0.034 k allocs: 7.98 kB   | 30  allocs: 7.72 kB       | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.072 k allocs: 0.0443 MB | 0.054 k allocs: 0.0419 MB | 1.06                       |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                           | 1.2 k allocs: 0.0459 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                           | 0.276 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                           | 23.5 k allocs: 1.21 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                           | 0.337 k allocs: 14.5 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                           | 0.282 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                           | 0.919 k allocs: 0.119 MB  |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                           | 3.37 k allocs: 0.241 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                           | 23.2 k allocs: 1.19 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                           | 0.252 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                           | 0.623 k allocs: 26.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                           | 0.0417 M allocs: 2.23 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                           | 0.56 k allocs: 24.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                           | 10 k allocs: 0.87 MB      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                           | 0.474 k allocs: 0.19 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward           |                           | 2.54 k allocs: 0.185 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                 |                           | 2.61 k allocs: 0.152 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.03 k allocs: 0.0396 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.433 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.77 k allocs: 0.355 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.988 k allocs: 0.038 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                           | 2.48 k allocs: 0.183 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.352 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                               |                           | 0.703 k allocs: 24.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.623 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.8 k allocs: 0.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.397 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                           | 10.3 k allocs: 0.499 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                           | 19.1 k allocs: 0.91 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward         |                           | 11 k allocs: 0.568 MB     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                           | 16.5 k allocs: 0.904 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                           | 0.588 k allocs: 25.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                           | 0.233 k allocs: 16.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                           | 0.15 k allocs: 0.0748 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                           | 0.297 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                           | 0.252 k allocs: 19 kB     |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                           | 0.169 k allocs: 12.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                           | 4.93 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                           | 0.179 k allocs: 8.25 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                           | 5.95 k allocs: 0.466 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                           | 21.5 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                |                           | 0.641 k allocs: 0.0434 MB |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                           | 0.685 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                           | 1.26 k allocs: 0.0522 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                           | 0.805 k allocs: 0.0314 MB |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward           |                           | 2.02 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff              |                           | 0.194 k allocs: 0.114 MB  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                           | 2.57 k allocs: 0.193 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                           | 5.43 k allocs: 0.339 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                           | 0.967 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                           | 11.7 k allocs: 0.564 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                           | 0.048 M allocs: 2.48 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                           | 0.43 k allocs: 29.1 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                           | 3.1 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                           | 1.09 k allocs: 0.0358 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                           | 4.68 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                           | 0.355 k allocs: 19.8 kB   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                           | 0.202 k allocs: 0.248 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                           | 0.666 k allocs: 28 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                           | 0.287 k allocs: 18.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                           | 3.23 k allocs: 0.322 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                           | 0.614 k allocs: 0.222 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                           | 0.966 k allocs: 0.032 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                           | 0.133 k allocs: 12.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                           | 0.324 k allocs: 0.187 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                           | 17.3 k allocs: 0.991 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                           | 0.361 k allocs: 23.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                           | 6.05 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                           | 21.8 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff              |                           | 0.232 k allocs: 0.1 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                           | 0.469 k allocs: 30 kB     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                           | 0.0406 M allocs: 2.13 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                           | 10.3 k allocs: 0.783 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                    |                           | 0.212 k allocs: 0.0587 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.348 k allocs: 23 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.227 k allocs: 0.0934 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.943 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.457 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.284 k allocs: 0.117 MB  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse         |                           | 0.758 k allocs: 29.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.55 k allocs: 0.284 MB   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                           | 0.314 k allocs: 0.163 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.95 k allocs: 0.144 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.89 k allocs: 0.274 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                 |                           | 0.287 k allocs: 16.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                |                           | 8.22 k allocs: 0.772 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.33 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.07 k allocs: 13.7 kB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse              |                           | 1.37 k allocs: 0.0547 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.252 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.744 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.77 k allocs: 0.748 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.408 k allocs: 26.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.346 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.53 k allocs: 0.731 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward              |                           | 0.0377 M allocs: 1.93 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                           | 10.5 k allocs: 0.505 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.528 k allocs: 0.0355 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.693 k allocs: 22.5 kB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.183 k allocs: 0.0407 MB |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                               |                           | 10.9 k allocs: 0.446 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                           | 0.801 k allocs: 0.339 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                           | 0.354 k allocs: 26.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                           | 0.407 k allocs: 24.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                           | 0.829 k allocs: 0.033 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                           | 2.98 k allocs: 0.246 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                     |                           | 0.316 k allocs: 19.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                           | 0.315 k allocs: 20.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                           | 0.834 k allocs: 0.301 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                           | 10.5 k allocs: 0.792 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse         |                           | 0.753 k allocs: 27 kB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                           | 1.11 k allocs: 0.0594 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.161 k allocs: 0.034 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                           | 0.227 k allocs: 0.0997 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.56 k allocs: 0.291 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                           | 0.242 k allocs: 15.2 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 0.718 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.19 k allocs: 0.565 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                           | 0.225 k allocs: 15.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                           | 0.77 k allocs: 0.298 MB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                           | 0.514 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse           |                           | 0.196 k allocs: 14 kB     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                           | 0.782 k allocs: 0.401 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                           | 31.1 k allocs: 1.49 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                           | 0.053 k allocs: 11.4 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                           | 1.11 k allocs: 0.0465 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                           | 0.358 k allocs: 19.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                           | 0.77 k allocs: 0.401 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                           | 0.738 k allocs: 31.1 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                           | 0.482 k allocs: 0.226 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                           | 0.851 k allocs: 0.032 MB  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                           | 0.24 k allocs: 0.06 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                           | 0.448 k allocs: 29.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                           | 0.814 k allocs: 0.0409 MB |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                           | 0.464 k allocs: 0.175 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                           | 2.81 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                           | 0.308 k allocs: 0.135 MB  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                           | 1.14 k allocs: 0.0607 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                           | 0.915 k allocs: 0.034 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                           | 7.07 k allocs: 0.55 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                           | 0.166 k allocs: 13.5 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                           | 0.712 k allocs: 26.8 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                           | 0.845 k allocs: 0.0326 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                           | 15.3 k allocs: 0.756 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                           | 3.77 k allocs: 0.332 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                           | 0.243 k allocs: 17.7 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                           | 0.047 k allocs: 0.0318 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                           | 0.341 k allocs: 19.6 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                           | 4.89 k allocs: 0.382 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                           | 0.452 k allocs: 0.145 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                           | 0.562 k allocs: 23.7 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                           | 1.04 k allocs: 0.0369 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                           | 0.251 k allocs: 17 kB     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                           | 18.2 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                           | 0.466 k allocs: 0.188 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                           | 0.151 k allocs: 6.98 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                           | 1.08 k allocs: 0.0401 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                           | 1.14 k allocs: 0.0435 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                           | 0.346 k allocs: 17.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                           | 19.9 k allocs: 0.954 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                           | 14.8 k allocs: 0.965 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                           | 15 k allocs: 0.706 MB     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                           | 0.0423 M allocs: 2.26 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                           | 5.52 k allocs: 0.342 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                           | 0.632 k allocs: 25.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                           | 0.863 k allocs: 32 kB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                           | 30.7 k allocs: 1.46 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                   |                           | 0.668 k allocs: 0.3 MB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                           | 0.476 k allocs: 0.146 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                           | 0.205 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                           | 0.363 k allocs: 27.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                           | 0.0427 M allocs: 2.26 MB  |                            |
| time_to_load                                                                                | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

