|                                                                                    | v0.1.0             | bb297a469d87c3...  | v0.1.0 / bb297a469d87c3... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0579 ± 0.0082 ms | 20.9 ± 5.2 μs      | 2.78 ± 0.8                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.03 ± 0.16 ms     | 0.639 ± 0.081 ms   | 3.18 ± 0.47                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0844 ± 0.016 ms  | 27.9 ± 2.2 μs      | 3.03 ± 0.61                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.4 ± 3.3 μs      | 3.35 ± 2.2 μs      | 5.2 ± 3.6                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.833 ± 0.12 ms    | 0.249 ± 0.049 ms   | 3.34 ± 0.81                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0483 ± 0.011 ms  | 10.4 ± 1.6 μs      | 4.65 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.1 ± 3.7 μs      | 4.02 ± 3.4 μs      | 3.77 ± 3.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.975 ± 0.3 ms     | 0.323 ± 0.051 ms   | 3.02 ± 1                   |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0321 ± 0.0031 ms | 11.8 ± 2 μs        | 2.71 ± 0.52                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.405 ± 0.041 ms   | 0.0489 ± 0.014 ms  | 8.29 ± 2.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 12.2 ± 2 ms        | 2.81 ± 0.48 ms     | 4.36 ± 1                   |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.412 ± 0.038 ms   | 0.0621 ± 0.0072 ms | 6.64 ± 0.98                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.92 ± 0.43 μs     | 0.471 ± 0.23 μs    | 8.31 ± 4.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.45 ± 1.1 μs      | 3.81 ± 0.68 μs     | 1.69 ± 0.42                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 9.63 ± 1 μs        | 1.39 ± 0.3 μs      | 6.94 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 25.3 ± 5.3 μs      | 11.8 ± 3.7 μs      | 2.15 ± 0.8                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.43 ± 0.039 ms    | 0.334 ± 0.033 ms   | 4.29 ± 0.44                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0585 ± 0.011 ms  | 14.1 ± 4.5 μs      | 4.16 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.543 ± 0.037 ms   | 0.0683 ± 0.02 ms   | 7.95 ± 2.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.041 ± 0.003 s    | 11.9 ± 2.1 ms      | 3.46 ± 0.66                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.475 ± 0.042 ms   | 0.0981 ± 0.013 ms  | 4.84 ± 0.77                |
| Convolution body/BLAS axpy per lag                                                 | 0.577 ± 0.016 μs   | 0.537 ± 0.037 μs   | 1.07 ± 0.08                |
| Convolution body/native axpy per lag                                               | 0.421 ± 0.012 μs   | 0.419 ± 0.1 μs     | 1 ± 0.24                   |
| Convolution body/package                                                           | 0.576 ± 0.016 μs   | 0.329 ± 0.0036 μs  | 1.75 ± 0.053               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10 ± 1.4 μs        | 7.01 ± 1.8 μs      | 1.43 ± 0.42                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.19 ± 0.35 μs     | 1.58 ± 0.76 μs     | 2.02 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 3.05 ± 1.4 μs      | 1.28 ± 0.63 μs     | 2.37 ± 1.6                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 27.6 ± 2.2 μs      | 16.2 ± 1.1 μs      | 1.71 ± 0.18                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.333 ± 0.18 μs    | 0.126 ± 0.052 μs   | 2.64 ± 1.8                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.98 ± 0.82 μs     | 2.49 ± 0.52 μs     | 1.6 ± 0.46                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0376 ± 0.0025 ms | 22.6 ± 7.1 μs      | 1.66 ± 0.53                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.1 ± 0.47 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.108 ± 0.014 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 20.2 ± 2.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0491 ± 0.0047 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.567 ± 0.19 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.07 ± 2.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.527 ± 0.19 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.52 ± 2.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0325 ± 0.0062 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 30 ± 3.8 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.034 ± 0.0034 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.56 ± 1.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 3.97 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.152 ± 0.02 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 13.9 ± 3.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 20.7 ± 2.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 18.2 ± 3.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.113 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0449 ± 0.0059 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.469 ± 0.33 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0816 ± 0.01 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.464 ± 0.32 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.8 ± 0.85 ms     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 14.2 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 20.5 ± 4.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 16.3 ± 2.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0372 ± 0.0053 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 25.2 ± 7.3 μs      |                            |
| time_to_load                                                                       | 0.182 ± 0.0028 s   | 0.243 ± 0.022 s    | 0.748 ± 0.067              |

|                                                                                    | v0.1.0                    | bb297a469d87c3...         | v0.1.0 / bb297a469d87c3... |
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
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.204 k allocs: 11.9 kB   | 0.984                      |

