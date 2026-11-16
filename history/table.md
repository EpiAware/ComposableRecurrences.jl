|                                                                                    | v0.1.0             | 05bc32ffca5355...  | v0.1.0 / 05bc32ffca5355... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0759 ± 0.013 ms  | 26.3 ± 7.3 μs      | 2.89 ± 0.93                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.96 ± 0.11 ms     | 0.87 ± 0.026 ms    | 2.25 ± 0.14                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.128 ± 0.02 ms    | 0.0391 ± 0.0098 ms | 3.28 ± 0.96                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 15.9 ± 7.4 μs      | 3.46 ± 3.9 μs      | 4.6 ± 5.6                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.36 ± 0.076 ms    | 0.343 ± 0.017 ms   | 3.95 ± 0.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0557 ± 0.023 ms  | 13.7 ± 2.3 μs      | 4.06 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.8 ± 1.5 μs      | 6.79 ± 5.4 μs      | 1.74 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.47 ± 0.05 ms     | 0.452 ± 0.015 ms   | 3.24 ± 0.16                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0364 ± 0.0018 ms | 12.8 ± 2.7 μs      | 2.84 ± 0.6                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.354 ± 0.061 ms   | 0.0506 ± 0.024 ms  | 6.99 ± 3.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.9 ± 2.3 ms      | 3.21 ± 0.64 ms     | 6.81 ± 1.5                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.482 ± 0.037 ms   | 0.0712 ± 0.0038 ms | 6.77 ± 0.64                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.94 ± 0.44 μs     | 0.36 ± 0.05 μs     | 10.9 ± 2                   |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.81 ± 6.5 μs      | 5.31 ± 0.63 μs     | 1.66 ± 1.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 12.5 ± 1.3 μs      | 1.26 ± 0.2 μs      | 9.88 ± 1.9                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 31.3 ± 9.6 μs      | 10.7 ± 5.8 μs      | 2.92 ± 1.8                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.52 ± 0.081 ms    | 0.438 ± 0.014 ms   | 3.47 ± 0.21                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0767 ± 0.015 ms  | 16.9 ± 6.5 μs      | 4.54 ± 2                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.541 ± 0.11 ms    | 0.0689 ± 0.026 ms  | 7.86 ± 3.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0447 ± 0.0029 s  | 13.6 ± 0.27 ms     | 3.29 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.628 ± 0.056 ms   | 0.119 ± 0.0081 ms  | 5.28 ± 0.59                |
| Convolution body/BLAS axpy per lag                                                 | 0.718 ± 0.013 μs   | 1.22 ± 0.03 μs     | 0.589 ± 0.018              |
| Convolution body/native axpy per lag                                               | 0.437 ± 0.0067 μs  | 0.554 ± 0.0077 μs  | 0.79 ± 0.016               |
| Convolution body/package                                                           | 0.718 ± 0.012 μs   | 0.557 ± 0.021 μs   | 1.29 ± 0.053               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.7 ± 3.1 μs      | 7.5 ± 0.26 μs      | 1.7 ± 0.42                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.91 ± 2.9 μs      | 2.33 ± 1.4 μs      | 0.82 ± 1.4                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.93 ± 2.2 μs      | 3.78 ± 1.7 μs      | 0.777 ± 0.67               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0329 ± 0.0011 ms | 17.9 ± 0.89 μs     | 1.83 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.381 ± 0.26 μs    | 0.15 ± 0.07 μs     | 2.54 ± 2.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.71 ± 3.1 μs      | 2.79 ± 0.26 μs     | 2.04 ± 1.1                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0365 ± 0.0019 ms | 24.3 ± 10 μs       | 1.5 ± 0.65                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.62 ± 0.064 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.147 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 25.2 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0669 ± 0.0022 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.68 ± 0.039 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.41 ± 1.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.731 ± 0.032 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.3 ± 3.7 μs       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0361 ± 0.0087 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0358 ± 0.012 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0401 ± 0.0013 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.84 ± 3.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 7.67 ± 4.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.199 ± 0.014 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 15 ± 3.8 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 25.9 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 19.5 ± 8.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.125 ± 0.01 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0471 ± 0.0021 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.642 ± 0.044 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0969 ± 0.0088 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.703 ± 1 ms       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 16.2 ± 1.4 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 14.7 ± 7 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 22.1 ± 7.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.4 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0513 ± 0.0014 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0331 ± 0.012 ms  |                            |
| time_to_load                                                                       | 0.19 ± 0.0015 s    | 0.203 ± 0.0014 s   | 0.932 ± 0.0099             |

|                                                                                    | v0.1.0                    | 05bc32ffca5355...         | v0.1.0 / 05bc32ffca5355... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 13.9 kB       | 1.85                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.039 k allocs: 18.6 kB   | 3.42                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.08 k allocs: 0.073 MB   | 3.22                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.083 k allocs: 0.0696 MB | 5.07                       |
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

