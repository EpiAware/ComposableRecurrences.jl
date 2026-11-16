|                                                                                    | v0.1.0             | 41a74172e0472d...  | v0.1.0 / 41a74172e0472d... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0762 ± 0.012 ms  | 26.2 ± 7.9 μs      | 2.91 ± 0.99                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.9 ± 0.038 ms     | 0.842 ± 0.022 ms   | 2.26 ± 0.074               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.127 ± 0.016 ms   | 0.0384 ± 0.01 ms   | 3.32 ± 0.96                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.4 ± 6.6 μs      | 3.46 ± 4.3 μs      | 4.76 ± 6.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.31 ± 0.029 ms    | 0.343 ± 0.012 ms   | 3.8 ± 0.16                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0544 ± 0.022 ms  | 13.4 ± 2.2 μs      | 4.05 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.6 ± 1.6 μs      | 6.68 ± 4.9 μs      | 1.74 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.47 ± 0.058 ms    | 0.486 ± 0.011 ms   | 3.02 ± 0.14                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0359 ± 0.0011 ms | 12.6 ± 2.6 μs      | 2.85 ± 0.59                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.348 ± 0.06 ms    | 0.0484 ± 0.011 ms  | 7.19 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.8 ± 2.7 ms      | 3.14 ± 0.097 ms    | 6.96 ± 0.88                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.49 ± 0.04 ms     | 0.0694 ± 0.0019 ms | 7.07 ± 0.61                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.64 ± 0.41 μs     | 0.351 ± 0.031 μs   | 10.4 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.26 ± 6.5 μs      | 4.84 ± 0.54 μs     | 1.71 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.7 ± 0.99 μs     | 1.26 ± 0.2 μs      | 9.24 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.033 ± 0.009 ms   | 12.4 ± 6 μs        | 2.67 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.44 ± 0.029 ms    | 0.429 ± 0.012 ms   | 3.35 ± 0.12                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0711 ± 0.01 ms   | 20.1 ± 6.6 μs      | 3.53 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.514 ± 0.079 ms   | 0.0668 ± 0.017 ms  | 7.7 ± 2.3                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0555 ± 0.0021 s  | 13.7 ± 0.72 ms     | 4.05 ± 0.26                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.608 ± 0.038 ms   | 0.118 ± 0.0084 ms  | 5.17 ± 0.49                |
| Convolution body/BLAS axpy per lag                                                 | 0.707 ± 0.0072 μs  | 0.707 ± 0.0061 μs  | 0.999 ± 0.013              |
| Convolution body/native axpy per lag                                               | 0.419 ± 0.0055 μs  | 0.419 ± 0.0071 μs  | 1 ± 0.021                  |
| Convolution body/package                                                           | 0.705 ± 0.0059 μs  | 0.326 ± 0.0044 μs  | 2.16 ± 0.034               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.2 ± 0.55 μs     | 7.48 ± 0.35 μs     | 1.63 ± 0.11                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.24 ± 0.31 μs     | 2.29 ± 1.4 μs      | 1.85 ± 1.2                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.71 ± 1.2 μs      | 3.76 ± 1.7 μs      | 0.456 ± 0.39               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0329 ± 0.0011 ms | 17.6 ± 0.84 μs     | 1.86 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.39 ± 0.26 μs     | 0.151 ± 0.05 μs    | 2.58 ± 1.9                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.74 ± 1.7 μs      | 2.96 ± 0.25 μs     | 2.28 ± 0.59                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0355 ± 0.0012 ms | 23.6 ± 2 μs        | 1.51 ± 0.14                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.61 ± 0.057 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.145 ± 0.0081 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 24.9 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0664 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.67 ± 0.047 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.45 ± 2.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.716 ± 0.031 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.28 ± 3.6 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0353 ± 0.002 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0353 ± 0.0056 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0402 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.75 ± 3.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.89 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.189 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 14 ± 7 μs          |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 25.8 ± 3.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 19.4 ± 7.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.119 ± 0.008 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0465 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.644 ± 0.032 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.096 ± 0.0052 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.635 ± 0.038 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15.9 ± 2 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 15 ± 7.7 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 22 ± 8.7 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.8 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0509 ± 0.0016 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0332 ± 0.012 ms  |                            |
| time_to_load                                                                       | 0.193 ± 0.0016 s   | 0.204 ± 0.00092 s  | 0.946 ± 0.0089             |

|                                                                                    | v0.1.0                    | 41a74172e0472d...         | v0.1.0 / 41a74172e0472d... |
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

