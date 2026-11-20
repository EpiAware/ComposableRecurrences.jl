|                                                                                    | v0.1.0             | fc7d1711b53394...  | v0.1.0 / fc7d1711b53394... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0783 ± 0.011 ms  | 26.6 ± 6.8 μs      | 2.95 ± 0.85                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.68 ± 0.08 ms     | 0.843 ± 0.015 ms   | 3.18 ± 0.11                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.111 ± 0.023 ms   | 0.0356 ± 0.0086 ms | 3.13 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 18.2 ± 4.9 μs      | 3.72 ± 3.3 μs      | 4.89 ± 4.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.18 ± 0.044 ms    | 0.338 ± 0.017 ms   | 3.5 ± 0.22                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0537 ± 0.017 ms  | 12.9 ± 1.9 μs      | 4.15 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.4 ± 1.9 μs      | 4.1 ± 4.2 μs       | 3.77 ± 3.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.32 ± 0.43 ms     | 0.369 ± 0.021 ms   | 3.57 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0409 ± 0.0024 ms | 12.8 ± 2.2 μs      | 3.18 ± 0.58                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.468 ± 0.052 ms   | 0.0503 ± 0.014 ms  | 9.3 ± 2.8                  |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 18.3 ± 3.1 ms      | 3.17 ± 0.15 ms     | 5.78 ± 1                   |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.509 ± 0.037 ms   | 0.0705 ± 0.0025 ms | 7.22 ± 0.59                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.47 ± 0.46 μs     | 0.546 ± 0.23 μs    | 10 ± 4.4                   |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 9.03 ± 4.9 μs      | 4.08 ± 1.1 μs      | 2.21 ± 1.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 12.8 ± 1.3 μs      | 1.61 ± 0.24 μs     | 7.94 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0347 ± 0.0017 ms | 9.14 ± 5.7 μs      | 3.8 ± 2.4                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.09 ± 0.056 ms    | 0.451 ± 0.023 ms   | 4.62 ± 0.27                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0753 ± 0.008 ms  | 16 ± 5.9 μs        | 4.72 ± 1.8                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.683 ± 0.031 ms   | 0.0768 ± 0.01 ms   | 8.89 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0603 ± 0.003 s   | 15 ± 0.2 ms        | 4.03 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.648 ± 0.039 ms   | 0.111 ± 0.0074 ms  | 5.87 ± 0.53                |
| Convolution body/BLAS axpy per lag                                                 | 0.628 ± 0.011 μs   | 0.618 ± 0.0077 μs  | 1.02 ± 0.022               |
| Convolution body/native axpy per lag                                               | 0.516 ± 0.0024 μs  | 0.515 ± 0.0051 μs  | 1 ± 0.011                  |
| Convolution body/package                                                           | 0.627 ± 0.011 μs   | 0.365 ± 0.00068 μs | 1.72 ± 0.03                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.2 ± 0.42 μs     | 9.18 ± 0.29 μs     | 1.43 ± 0.064               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.68 ± 0.33 μs     | 2.09 ± 1.2 μs      | 1.76 ± 1.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.22 ± 2 μs        | 3.3 ± 1.5 μs       | 0.673 ± 0.68               |
| Evaluation/Matrix overview T200_L20_S3                                             | 30.4 ± 1.1 μs      | 19.7 ± 1.3 μs      | 1.55 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.462 ± 0.24 μs    | 0.147 ± 0.007 μs   | 3.14 ± 1.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.96 ± 2.1 μs      | 3.19 ± 0.34 μs     | 1.86 ± 0.69                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0423 ± 0.0018 ms | 28.3 ± 2.1 μs      | 1.5 ± 0.13                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.72 ± 0.15 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.137 ± 0.0093 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 24.9 ± 4.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.07 ± 0.0036 ms   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.87 ± 0.06 ms     |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.89 ± 1 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.885 ± 0.061 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.81 ± 3.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0405 ± 0.0018 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0344 ± 0.0095 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0467 ± 0.0022 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.41 ± 3.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.59 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.189 ± 0.02 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 16.5 ± 4.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 25.9 ± 3.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 22 ± 6.1 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.134 ± 0.013 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0534 ± 0.0038 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.842 ± 0.037 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.101 ± 0.0092 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.828 ± 0.036 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15.8 ± 2.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.9 ± 5.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 24.7 ± 6.5 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 20.6 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0538 ± 0.0017 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0319 ± 0.0097 ms |                            |
| time_to_load                                                                       | 0.243 ± 0.00068 s  | 0.311 ± 0.0011 s   | 0.779 ± 0.0036             |

|                                                                                    | v0.1.0                    | fc7d1711b53394...         | v0.1.0 / fc7d1711b53394... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.055 k allocs: 28.7 kB   | 1.3                        |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.059 k allocs: 0.0327 MB | 2.51                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 29  allocs: 14.4 kB       | 1.78                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 18.5 kB   | 3.43                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 24  allocs: 16 kB         | 1.44                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.091 k allocs: 0.074 MB  | 3.18                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.08 k allocs: 0.0695 MB  | 5.07                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 17  allocs: 1.97 kB       | 2.04                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 23  allocs: 18.1 kB       | 1.58                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 22  allocs: 2.39 kB       | 4.91                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 0.033 k allocs: 20.4 kB   | 1.31                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.036 k allocs: 20.1 kB   | 3.41                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.085 k allocs: 0.134 MB  | 1.99                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.135 k allocs: 0.12 MB   | 2.91                       |
| Convolution body/BLAS axpy per lag                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                           | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 0.035 k allocs: 10.1 kB   | 15  allocs: 7.73 kB       | 1.31                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 5  allocs: 0.641 kB       | 1.85                       |
| Evaluation/Matrix renewal T200_L20_S1                                              | 19  allocs: 7.48 kB       | 11  allocs: 5.53 kB       | 1.35                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.044 k allocs: 0.0432 MB | 23  allocs: 0.0331 MB     | 1.3                        |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                           | 1.89 k allocs: 7.91 MB    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.16 k allocs: 0.13 MB    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.28 k allocs: 0.0632 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.126 k allocs: 0.0377 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.136 k allocs: 0.0637 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.303 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.115 k allocs: 31.1 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.156 k allocs: 0.288 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.121 k allocs: 0.135 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.115 k allocs: 30 kB     |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.126 k allocs: 0.0394 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

