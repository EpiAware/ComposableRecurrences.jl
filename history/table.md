|                                                                                    | v0.1.0              | 12978dffcb47b5...  | v0.1.0 / 12978dffcb47b5... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0952 ± 0.015 ms   | 30.9 ± 3.2 μs      | 3.09 ± 0.57                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.66 ± 0.03 ms      | 0.848 ± 0.018 ms   | 3.14 ± 0.076               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.141 ± 0.017 ms    | 0.0433 ± 0.012 ms  | 3.26 ± 0.97                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.2 ± 7.3 μs       | 3.26 ± 4.4 μs      | 5.28 ± 7.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.382 ± 0.022 ms    | 0.273 ± 0.015 ms   | 1.4 ± 0.11                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0608 ± 0.005 ms   | 14.2 ± 2 μs        | 4.28 ± 0.71                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 14 ± 5.9 μs         | 7.17 ± 5.6 μs      | 1.95 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.412 ± 0.022 ms    | 0.334 ± 0.012 ms   | 1.23 ± 0.079               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0591 ± 0.023 ms   | 14.3 ± 2.9 μs      | 4.15 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.518 ± 0.064 ms    | 0.0582 ± 0.025 ms  | 8.9 ± 4                    |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.5 ± 1.6 ms       | 3.32 ± 0.16 ms     | 3.47 ± 0.51                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.555 ± 0.041 ms    | 0.0831 ± 0.0021 ms | 6.68 ± 0.52                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.41 ± 0.38 μs      | 0.411 ± 0.05 μs    | 13.2 ± 1.9                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.92 ± 0.66 μs      | 3.41 ± 0.67 μs     | 1.74 ± 0.39                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.5 ± 0.83 μs      | 1.51 ± 0.19 μs     | 8.95 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0408 ± 0.011 ms   | 14.3 ± 6.9 μs      | 2.85 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.02 ± 0.027 ms     | 0.366 ± 0.015 ms   | 5.52 ± 0.23                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0895 ± 0.017 ms   | 22.2 ± 7.3 μs      | 4.04 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.678 ± 0.11 ms     | 0.0819 ± 0.04 ms   | 8.28 ± 4.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0567 ± 0.003 s    | 12.7 ± 0.95 ms     | 4.47 ± 0.41                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.732 ± 0.041 ms    | 0.136 ± 0.0095 ms  | 5.4 ± 0.49                 |
| Convolution body/BLAS axpy per lag                                                 | 0.777 ± 0.0086 μs   | 0.788 ± 0.012 μs   | 0.986 ± 0.019              |
| Convolution body/native axpy per lag                                               | 0.493 ± 0.0058 μs   | 0.496 ± 0.0061 μs  | 0.994 ± 0.017              |
| Convolution body/package                                                           | 0.777 ± 0.0065 μs   | 0.356 ± 0.0054 μs  | 2.18 ± 0.038               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.1 ± 3 μs         | 9.1 ± 3.1 μs       | 1.55 ± 0.62                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.28 ± 2.9 μs       | 2.41 ± 1.4 μs      | 1.78 ± 1.6                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 3.02 ± 1.7 μs       | 3.97 ± 1.6 μs      | 0.763 ± 0.54               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0397 ± 0.00082 ms | 19.5 ± 1 μs        | 2.03 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.531 ± 0.2 μs      | 0.18 ± 0.031 μs    | 2.95 ± 1.2                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 8.75 ± 1.7 μs       | 3.7 ± 0.19 μs      | 2.37 ± 0.48                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0471 ± 0.00086 ms | 31.2 ± 1.1 μs      | 1.51 ± 0.059               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.66 ± 0.098 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.173 ± 0.018 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.8 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0864 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.623 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.08 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.621 ± 0.032 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.79 ± 4.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0459 ± 0.0095 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0395 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0491 ± 0.0013 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.43 ± 4.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 6.39 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.227 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.4 ± 4.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 29 ± 3.6 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 23 ± 9.9 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.15 ± 0.011 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0599 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.54 ± 0.055 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.119 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.599 ± 1.2 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.1 ± 1.3 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.1 ± 8.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 27.2 ± 6.2 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.4 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0493 ± 0.0018 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0372 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.244 ± 0.0015 s    | 0.313 ± 0.0033 s   | 0.779 ± 0.0095             |

|                                                                                    | v0.1.0                    | 12978dffcb47b5...         | v0.1.0 / 12978dffcb47b5... |
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

