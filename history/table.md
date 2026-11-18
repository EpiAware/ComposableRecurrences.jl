|                                                                                    | v0.1.0             | 50a132a1e2f5f0...  | v0.1.0 / 50a132a1e2f5f0... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.052 ± 0.0096 ms  | 17.9 ± 5.1 μs      | 2.9 ± 0.99                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.39 ± 0.064 ms    | 0.577 ± 0.034 ms   | 2.41 ± 0.18                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0755 ± 0.012 ms  | 25 ± 3.2 μs        | 3.02 ± 0.62                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 12.2 ± 3.3 μs      | 3.12 ± 3.1 μs      | 3.89 ± 4                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.823 ± 0.038 ms   | 0.249 ± 0.018 ms   | 3.3 ± 0.28                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0368 ± 0.015 ms  | 9.96 ± 1.7 μs      | 3.69 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 9.39 ± 2.1 μs      | 4.89 ± 3.1 μs      | 1.92 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.915 ± 0.031 ms   | 0.285 ± 0.019 ms   | 3.21 ± 0.24                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 23.7 ± 1.2 μs      | 9.02 ± 2 μs        | 2.63 ± 0.58                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.264 ± 0.029 ms   | 0.0331 ± 0.018 ms  | 7.99 ± 4.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14.9 ± 2.6 ms      | 2.09 ± 2.6 ms      | 7.16 ± 9.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.291 ± 0.026 ms   | 0.0438 ± 0.0024 ms | 6.64 ± 0.71                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 2.98 ± 0.49 μs     | 0.261 ± 0.04 μs    | 11.4 ± 2.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.93 ± 5.4 μs      | 3.87 ± 0.96 μs     | 1.53 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 7.87 ± 0.91 μs     | 0.902 ± 0.041 μs   | 8.73 ± 1.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 27 ± 6.9 μs        | 6.62 ± 3.7 μs      | 4.08 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.07 ± 0.032 ms    | 0.39 ± 0.024 ms    | 2.74 ± 0.19                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0465 ± 0.0088 ms | 13.4 ± 4.5 μs      | 3.47 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.411 ± 0.07 ms    | 0.0488 ± 0.027 ms  | 8.42 ± 4.8                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0322 ± 0.0029 s  | 10.4 ± 0.53 ms     | 3.11 ± 0.32                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.364 ± 0.031 ms   | 0.0703 ± 0.0048 ms | 5.18 ± 0.56                |
| Convolution body/BLAS axpy per lag                                                 | 0.38 ± 0.0089 μs   | 0.482 ± 0.0064 μs  | 0.789 ± 0.021              |
| Convolution body/native axpy per lag                                               | 0.274 ± 0.013 μs   | 0.38 ± 0.0067 μs   | 0.721 ± 0.038              |
| Convolution body/package                                                           | 0.381 ± 0.0056 μs  | 0.188 ± 0.0022 μs  | 2.02 ± 0.038               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.76 ± 2.3 μs      | 6.09 ± 0.3 μs      | 1.6 ± 0.39                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.98 ± 0.22 μs     | 1.64 ± 1 μs        | 1.82 ± 1.2                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.8 ± 1.2 μs       | 2.85 ± 1.2 μs      | 0.982 ± 0.59               |
| Evaluation/Matrix overview T200_L20_S3                                             | 19.8 ± 0.99 μs     | 11.2 ± 0.61 μs     | 1.77 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.301 ± 0.19 μs    | 0.111 ± 0.13 μs    | 2.71 ± 3.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.87 ± 2 μs        | 2.12 ± 0.27 μs     | 1.82 ± 0.95                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 23.4 ± 1 μs        | 17.7 ± 1.5 μs      | 1.33 ± 0.13                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.05 ± 0.073 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.0943 ± 0.0073 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 18.5 ± 3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0469 ± 0.0021 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.543 ± 0.025 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.53 ± 2.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.654 ± 0.047 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.16 ± 2.7 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 25.4 ± 1 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 25.1 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 30.2 ± 1.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.64 ± 2.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.85 ± 1.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.131 ± 0.0094 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 12.7 ± 4 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.8 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 16.2 ± 6.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0895 ± 0.0069 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0339 ± 0.0013 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.499 ± 0.024 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.07 ± 0.0066 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.495 ± 0.027 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 12.6 ± 2.7 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 12.8 ± 5.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 18.7 ± 5.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 13.5 ± 3.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0374 ± 0.0029 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 23.6 ± 6.3 μs      |                            |
| time_to_load                                                                       | 0.147 ± 0.004 s    | 0.201 ± 0.0062 s   | 0.735 ± 0.03               |

|                                                                                    | v0.1.0                    | 50a132a1e2f5f0...         | v0.1.0 / 50a132a1e2f5f0... |
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

