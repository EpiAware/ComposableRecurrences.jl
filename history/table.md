|                                                                                    | v0.1.0              | 5e11d1444ab107...   | v0.1.0 / 5e11d1444ab107... |
|:-----------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.076 ± 0.012 ms    | 26.2 ± 2.6 μs       | 2.9 ± 0.55                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.87 ± 0.032 ms     | 0.83 ± 0.026 ms     | 2.26 ± 0.081               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.128 ± 0.019 ms    | 0.0387 ± 0.01 ms    | 3.32 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.2 ± 7.3 μs       | 6.59 ± 4.7 μs       | 2.46 ± 2.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.3 ± 0.028 ms      | 0.327 ± 0.02 ms     | 3.98 ± 0.25                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0537 ± 0.022 ms   | 13 ± 2.1 μs         | 4.14 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.3 ± 5.7 μs       | 6.78 ± 5 μs         | 1.67 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.94 ± 0.51 ms      | 0.428 ± 0.012 ms    | 4.54 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0342 ± 0.0014 ms  | 13 ± 2.6 μs         | 2.64 ± 0.55                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.342 ± 0.06 ms     | 0.0486 ± 0.023 ms   | 7.05 ± 3.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21 ± 1.9 ms         | 3.03 ± 1.1 ms       | 6.95 ± 2.7                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.48 ± 0.038 ms     | 0.0686 ± 0.002 ms   | 7 ± 0.59                   |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.6 ± 0.37 μs       | 0.361 ± 0.061 μs    | 9.99 ± 2                   |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.4 ± 7.2 μs        | 4.79 ± 0.73 μs      | 1.75 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.6 ± 1.5 μs       | 1.26 ± 0.2 μs       | 9.2 ± 1.9                  |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 27.2 ± 7.9 μs       | 11.2 ± 5.9 μs       | 2.43 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.45 ± 0.027 ms     | 0.421 ± 0.013 ms    | 3.45 ± 0.12                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0709 ± 0.0089 ms  | 19.7 ± 6.6 μs       | 3.59 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.497 ± 0.079 ms    | 0.0665 ± 0.037 ms   | 7.47 ± 4.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0415 ± 0.0018 s   | 13.2 ± 0.73 ms      | 3.14 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.603 ± 0.034 ms    | 0.117 ± 0.0083 ms   | 5.16 ± 0.46                |
| Convolution body/BLAS axpy per lag                                                 | 0.702 ± 0.0076 μs   | 0.706 ± 0.0063 μs   | 0.994 ± 0.014              |
| Convolution body/native axpy per lag                                               | 0.431 ± 0.008 μs    | 0.42 ± 0.0058 μs    | 1.03 ± 0.024               |
| Convolution body/package                                                           | 0.699 ± 0.0071 μs   | 0.327 ± 0.0058 μs   | 2.14 ± 0.044               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.1 ± 0.46 μs      | 7.46 ± 0.27 μs      | 1.63 ± 0.085               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.18 ± 0.33 μs      | 2.32 ± 1.3 μs       | 1.8 ± 1                    |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.61 ± 1.1 μs       | 3.78 ± 1.6 μs       | 0.427 ± 0.35               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0331 ± 0.0013 ms  | 17.6 ± 0.96 μs      | 1.88 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.39 ± 0.25 μs      | 0.14 ± 0.04 μs      | 2.79 ± 2                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.74 ± 1.6 μs       | 2.92 ± 0.22 μs      | 2.31 ± 0.58                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0353 ± 0.00096 ms | 23 ± 1.6 μs         | 1.54 ± 0.12                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.59 ± 0.13 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.143 ± 0.0088 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 25 ± 3.3 μs         |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0655 ± 0.0016 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.635 ± 0.022 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.77 ± 3.5 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.703 ± 0.03 ms     |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.25 ± 3.7 μs       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0351 ± 0.0019 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0349 ± 0.011 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0393 ± 0.00098 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.67 ± 3.6 μs       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 6.65 ± 4.1 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.189 ± 0.0095 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 13.9 ± 7.2 μs       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 25.5 ± 3.4 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 19.9 ± 8.8 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.118 ± 0.0068 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.046 ± 0.0017 ms   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.601 ± 0.047 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0941 ± 0.0059 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.639 ± 0.045 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.4 ± 1.1 ms       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 14.5 ± 7.5 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 21.7 ± 8 μs         |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 18.5 ± 4.4 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0477 ± 0.0019 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0332 ± 0.0052 ms  |                            |
| time_to_load                                                                       | 0.192 ± 0.0041 s    | 0.203 ± 0.0022 s    | 0.943 ± 0.023              |

|                                                                                    | v0.1.0                    | 5e11d1444ab107...         | v0.1.0 / 5e11d1444ab107... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 25  allocs: 14 kB         | 1.84                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 18.5 kB   | 3.43                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.081 k allocs: 0.0732 MB | 3.21                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.08 k allocs: 0.0695 MB  | 5.07                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 15  allocs: 1.91 kB       | 2.11                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 29  allocs: 18.3 kB       | 1.56                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 22  allocs: 2.39 kB       | 4.91                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 29  allocs: 18.1 kB       | 1.48                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.034 k allocs: 19.8 kB   | 3.45                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.075 k allocs: 0.116 MB  | 2.3                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.133 k allocs: 0.12 MB   | 2.92                       |
| Convolution body/BLAS axpy per lag                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                           | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 0.035 k allocs: 10.1 kB   | 15  allocs: 7.73 kB       | 1.31                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 7  allocs: 0.703 kB       | 1.69                       |
| Evaluation/Matrix renewal T200_L20_S1                                              | 19  allocs: 7.48 kB       | 11  allocs: 5.53 kB       | 1.35                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.044 k allocs: 0.0432 MB | 23  allocs: 0.0331 MB     | 1.3                        |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                           | 1.89 k allocs: 7.91 MB    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.158 k allocs: 0.129 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.278 k allocs: 0.063 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.116 k allocs: 0.0366 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.121 k allocs: 0.052 MB  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.301 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.103 k allocs: 29 kB     |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.141 k allocs: 0.234 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.11 k allocs: 0.125 MB   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.103 k allocs: 27.9 kB   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.116 k allocs: 0.0383 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

