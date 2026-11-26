|                                                                                    | v0.1.0              | a65f1736f04bfb...  | v0.1.0 / a65f1736f04bfb... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0734 ± 0.012 ms   | 26.7 ± 8 μs        | 2.75 ± 0.94                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.88 ± 0.042 ms     | 0.83 ± 0.011 ms    | 2.27 ± 0.059               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.116 ± 0.014 ms    | 0.0371 ± 0.01 ms   | 3.11 ± 0.94                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.4 ± 6.8 μs       | 3.43 ± 3.8 μs      | 4.78 ± 5.7                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.3 ± 0.036 ms      | 0.34 ± 0.015 ms    | 3.83 ± 0.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0535 ± 0.022 ms   | 13.2 ± 2.2 μs      | 4.07 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 10.9 ± 0.72 μs      | 3.89 ± 4.8 μs      | 2.82 ± 3.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.43 ± 0.049 ms     | 0.449 ± 0.011 ms   | 3.19 ± 0.14                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0351 ± 0.0011 ms  | 12.9 ± 2.7 μs      | 2.72 ± 0.57                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.378 ± 0.065 ms    | 0.0477 ± 0.024 ms  | 7.92 ± 4.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.7 ± 2.4 ms       | 3.07 ± 0.15 ms     | 7.06 ± 0.85                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.439 ± 0.037 ms    | 0.0672 ± 0.0026 ms | 6.53 ± 0.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.37 ± 0.41 μs      | 0.21 ± 0.091 μs    | 20.8 ± 9.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.64 ± 1.2 μs       | 3.6 ± 1 μs         | 2.12 ± 0.69                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 12 ± 0.96 μs        | 1.03 ± 0.13 μs     | 11.6 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.032 ± 0.0089 ms   | 8.3 ± 6.6 μs       | 3.85 ± 3.2                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.42 ± 0.037 ms     | 0.553 ± 0.019 ms   | 2.56 ± 0.11                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0672 ± 0.0086 ms  | 14 ± 1.1 μs        | 4.81 ± 0.73                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.545 ± 0.066 ms    | 0.0703 ± 0.0078 ms | 7.75 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0425 ± 0.0022 s   | 14.3 ± 0.51 ms     | 2.98 ± 0.19                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.563 ± 0.029 ms    | 0.11 ± 0.0065 ms   | 5.1 ± 0.4                  |
| Convolution body/BLAS axpy per lag                                                 | 0.716 ± 0.0058 μs   | 0.696 ± 0.0068 μs  | 1.03 ± 0.013               |
| Convolution body/native axpy per lag                                               | 0.431 ± 0.0061 μs   | 0.417 ± 0.0066 μs  | 1.03 ± 0.022               |
| Convolution body/package                                                           | 0.715 ± 0.0059 μs   | 0.32 ± 0.0072 μs   | 2.24 ± 0.054               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.6 ± 3.2 μs       | 7.45 ± 0.23 μs     | 1.69 ± 0.43                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.72 ± 2.9 μs       | 2.35 ± 1.4 μs      | 0.732 ± 1.3                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.88 ± 1.8 μs       | 3.74 ± 1.6 μs      | 0.772 ± 0.6                |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0325 ± 0.00098 ms | 15.3 ± 0.94 μs     | 2.13 ± 0.15                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.381 ± 0.23 μs     | 0.08 ± 0.03 μs     | 4.76 ± 3.4                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.3 ± 2.7 μs        | 2.73 ± 0.27 μs     | 1.94 ± 1                   |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0353 ± 0.0012 ms  | 24.3 ± 10 μs       | 1.45 ± 0.62                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.54 ± 0.083 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.141 ± 0.0098 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 24.8 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0598 ± 0.0015 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.682 ± 0.04 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.48 ± 1.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.903 ± 0.037 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.48 ± 3.9 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0348 ± 0.0041 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0336 ± 0.011 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0432 ± 0.0013 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.86 ± 3.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.67 ± 2.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.175 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.6 ± 7.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 25.5 ± 3.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 20.4 ± 8.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.126 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0474 ± 0.0021 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.656 ± 0.028 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0973 ± 0.0096 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.633 ± 0.038 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 17.2 ± 3 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.1 ± 4.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 24.4 ± 7 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 19.8 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0506 ± 0.0017 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 31.3 ± 12 μs       |                            |
| time_to_load                                                                       | 0.191 ± 0.00091 s   | 0.251 ± 0.0027 s   | 0.76 ± 0.0088              |

|                                                                                    | v0.1.0                    | a65f1736f04bfb...         | v0.1.0 / a65f1736f04bfb... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.053 k allocs: 28.5 kB   | 1.31                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 29  allocs: 14.4 kB       | 1.78                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 18.5 kB   | 3.43                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 24  allocs: 16 kB         | 1.44                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.091 k allocs: 0.074 MB  | 3.18                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.078 k allocs: 0.0695 MB | 5.08                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 9  allocs: 1.47 kB        | 2.73                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 20  allocs: 17.6 kB       | 1.63                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 14  allocs: 1.86 kB       | 6.31                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 31  allocs: 20.1 kB       | 1.33                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.034 k allocs: 19.8 kB   | 3.45                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.083 k allocs: 0.134 MB  | 1.99                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.133 k allocs: 0.12 MB   | 2.92                       |
| Convolution body/BLAS axpy per lag                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                           | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 0.035 k allocs: 10.1 kB   | 15  allocs: 7.73 kB       | 1.31                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 4  allocs: 0.594 kB       | 2                          |
| Evaluation/Matrix renewal T200_L20_S1                                              | 19  allocs: 7.48 kB       | 11  allocs: 5.53 kB       | 1.35                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.044 k allocs: 0.0432 MB | 23  allocs: 0.0331 MB     | 1.3                        |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                           | 1.89 k allocs: 7.91 MB    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.158 k allocs: 0.129 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.171 k allocs: 0.0601 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.116 k allocs: 0.0366 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.134 k allocs: 0.0635 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.194 k allocs: 0.262 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.105 k allocs: 29.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.154 k allocs: 0.288 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.119 k allocs: 0.135 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.105 k allocs: 28.9 kB   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.116 k allocs: 0.0383 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

