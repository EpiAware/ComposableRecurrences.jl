|                                                                                    | v0.1.0             | 3adb2e9a0d9eb5...  | v0.1.0 / 3adb2e9a0d9eb5... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0957 ± 0.014 ms  | 30.6 ± 9.2 μs      | 3.13 ± 1.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.58 ± 0.033 ms    | 0.841 ± 0.019 ms   | 3.07 ± 0.081               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.143 ± 0.018 ms   | 0.0425 ± 0.012 ms  | 3.35 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.8 ± 5.2 μs      | 3.49 ± 4.6 μs      | 5.11 ± 6.9                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.395 ± 0.021 ms   | 0.275 ± 0.014 ms   | 1.43 ± 0.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0598 ± 0.022 ms  | 14.2 ± 2.1 μs      | 4.21 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 16.7 ± 6.4 μs      | 7.18 ± 5.7 μs      | 2.33 ± 2                   |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.394 ± 0.022 ms   | 0.338 ± 0.012 ms   | 1.17 ± 0.076               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0592 ± 0.023 ms  | 14.3 ± 2.9 μs      | 4.14 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.532 ± 0.069 ms   | 0.0581 ± 0.0098 ms | 9.16 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11 ± 1.4 ms        | 3.27 ± 0.089 ms    | 3.37 ± 0.44                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.549 ± 0.038 ms   | 0.0834 ± 0.0022 ms | 6.59 ± 0.49                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.51 ± 0.39 μs     | 0.421 ± 0.06 μs    | 13.1 ± 2.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.1 ± 0.99 μs      | 3.22 ± 0.4 μs      | 1.9 ± 0.39                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.8 ± 0.86 μs     | 1.46 ± 0.16 μs     | 9.44 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0404 ± 0.011 ms  | 14.4 ± 6.7 μs      | 2.8 ± 1.5                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.07 ± 0.029 ms    | 0.366 ± 0.013 ms   | 5.67 ± 0.22                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0877 ± 0.018 ms  | 19.9 ± 7.1 μs      | 4.4 ± 1.8                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.664 ± 0.095 ms   | 0.0804 ± 0.012 ms  | 8.25 ± 1.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0548 ± 0.0027 s  | 13.2 ± 2.8 ms      | 4.15 ± 0.9                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.726 ± 0.032 ms   | 0.136 ± 0.0093 ms  | 5.34 ± 0.43                |
| Convolution body/BLAS axpy per lag                                                 | 0.784 ± 0.0095 μs  | 0.787 ± 0.0029 μs  | 0.996 ± 0.013              |
| Convolution body/native axpy per lag                                               | 0.499 ± 0.0062 μs  | 0.505 ± 0.0075 μs  | 0.987 ± 0.019              |
| Convolution body/package                                                           | 0.784 ± 0.0092 μs  | 0.356 ± 0.0062 μs  | 2.21 ± 0.046               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.1 ± 3 μs        | 8.91 ± 3.1 μs      | 1.58 ± 0.64                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.36 ± 2.9 μs      | 0.872 ± 1.5 μs     | 5 ± 9                      |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.28 ± 1.7 μs      | 1.66 ± 2.8 μs      | 2.58 ± 4.5                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0399 ± 0.0011 ms | 19.1 ± 0.73 μs     | 2.09 ± 0.099               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.541 ± 0.18 μs    | 0.171 ± 0.02 μs    | 3.16 ± 1.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.17 ± 3 μs        | 3.68 ± 0.2 μs      | 1.68 ± 0.81                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0471 ± 0.0012 ms | 31.2 ± 1.1 μs      | 1.51 ± 0.065               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.66 ± 0.077 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.171 ± 0.0089 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 27.4 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0854 ± 0.0023 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.625 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 7.71 ± 4.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.635 ± 0.035 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 6.1 ± 1.8 μs       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0456 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0393 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0488 ± 0.0011 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 6.27 ± 1.8 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.59 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.226 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 15.2 ± 7.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 28.6 ± 3.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 23.4 ± 7 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.149 ± 0.01 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0601 ± 0.0018 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.578 ± 0.027 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.116 ± 0.0092 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.558 ± 0.031 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15 ± 1.5 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 17.2 ± 8.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 27.2 ± 7 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 23.5 ± 4.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0479 ± 0.002 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0364 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.243 ± 0.0026 s   | 0.313 ± 0.0034 s   | 0.776 ± 0.012              |

|                                                                                    | v0.1.0                    | 3adb2e9a0d9eb5...         | v0.1.0 / 3adb2e9a0d9eb5... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.052 k allocs: 26.6 kB   | 1.4                        |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.059 k allocs: 0.0327 MB | 2.51                       |
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
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 31  allocs: 18.3 kB       | 1.46                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.036 k allocs: 20.1 kB   | 3.41                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.077 k allocs: 0.116 MB  | 2.29                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.135 k allocs: 0.12 MB   | 2.91                       |
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
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.16 k allocs: 0.13 MB    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.28 k allocs: 0.0632 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.126 k allocs: 0.0377 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.123 k allocs: 0.0522 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.303 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.113 k allocs: 30.2 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.143 k allocs: 0.234 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.112 k allocs: 0.125 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.113 k allocs: 29.1 kB   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.126 k allocs: 0.0394 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

