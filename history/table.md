|                                                                                    | v0.1.0             | 0ef90ef0e6ddc9...  | v0.1.0 / 0ef90ef0e6ddc9... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0826 ± 0.011 ms  | 27 ± 6.9 μs        | 3.06 ± 0.89                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.72 ± 0.05 ms     | 0.875 ± 0.064 ms   | 3.1 ± 0.23                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.127 ± 0.018 ms   | 0.0378 ± 0.0087 ms | 3.35 ± 0.9                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.6 ± 5.8 μs      | 3.8 ± 3.3 μs       | 4.63 ± 4.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.12 ± 0.087 ms    | 0.331 ± 0.039 ms   | 3.38 ± 0.47                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0555 ± 0.018 ms  | 13.9 ± 2 μs        | 3.99 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 14.2 ± 1.5 μs      | 5.21 ± 4.6 μs      | 2.72 ± 2.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.32 ± 0.45 ms     | 0.382 ± 0.032 ms   | 3.44 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0413 ± 0.0019 ms | 13.5 ± 2.3 μs      | 3.05 ± 0.55                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.416 ± 0.051 ms   | 0.0514 ± 0.0053 ms | 8.11 ± 1.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 17.6 ± 1.2 ms      | 3.5 ± 0.24 ms      | 5.03 ± 0.49                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.552 ± 0.044 ms   | 0.0736 ± 0.0027 ms | 7.5 ± 0.66                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.89 ± 0.4 μs      | 0.51 ± 0.19 μs     | 9.59 ± 3.7                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 9.51 ± 5.4 μs      | 4 ± 0.37 μs        | 2.38 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.5 ± 2 μs        | 1.53 ± 0.36 μs     | 8.85 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0377 ± 0.0056 ms | 10.1 ± 5.5 μs      | 3.73 ± 2.1                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.11 ± 0.063 ms    | 0.423 ± 0.032 ms   | 4.99 ± 0.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0789 ± 0.0088 ms | 21.4 ± 5.8 μs      | 3.69 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.621 ± 0.08 ms    | 0.0777 ± 0.012 ms  | 7.98 ± 1.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.058 ± 0.003 s    | 15 ± 0.39 ms       | 3.86 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.708 ± 0.039 ms   | 0.123 ± 0.0082 ms  | 5.74 ± 0.5                 |
| Convolution body/BLAS axpy per lag                                                 | 0.692 ± 0.027 μs   | 0.562 ± 0.011 μs   | 1.23 ± 0.053               |
| Convolution body/native axpy per lag                                               | 0.567 ± 0.02 μs    | 0.569 ± 0.02 μs    | 0.996 ± 0.049              |
| Convolution body/package                                                           | 0.688 ± 0.029 μs   | 0.401 ± 0.0015 μs  | 1.71 ± 0.073               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.8 ± 2.1 μs      | 9.3 ± 2.3 μs       | 1.49 ± 0.44                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.77 ± 2.2 μs      | 2.16 ± 0.39 μs     | 1.75 ± 1.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.77 ± 1 μs        | 3.47 ± 1.5 μs      | 0.511 ± 0.37               |
| Evaluation/Matrix overview T200_L20_S3                                             | 31.2 ± 1.2 μs      | 20.8 ± 1.4 μs      | 1.5 ± 0.11                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.493 ± 0.25 μs    | 0.183 ± 0.033 μs   | 2.69 ± 1.5                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.28 ± 1.7 μs      | 3.24 ± 0.32 μs     | 2.25 ± 0.58                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0448 ± 0.0016 ms | 29.1 ± 1.7 μs      | 1.54 ± 0.11                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.51 ± 0.36 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.149 ± 0.0071 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 25.5 ± 8.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.07 ± 0.0042 ms   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.767 ± 0.11 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 6.02 ± 2.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.816 ± 0.13 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.05 ± 3.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0412 ± 0.0024 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0358 ± 0.01 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0426 ± 0.0025 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.59 ± 3.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.21 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.2 ± 0.015 ms     |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 15.2 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 26.6 ± 3.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 20.4 ± 7.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.13 ± 0.012 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0547 ± 0.003 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.683 ± 0.22 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.103 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.718 ± 0.19 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15.6 ± 11 ms       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 15.2 ± 6.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 23 ± 5.7 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 19 ± 4 μs          |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0511 ± 0.0025 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0342 ± 0.0096 ms |                            |
| time_to_load                                                                       | 0.248 ± 0.0016 s   | 0.264 ± 0.0011 s   | 0.941 ± 0.0073             |

|                                                                                    | v0.1.0                    | 0ef90ef0e6ddc9...         | v0.1.0 / 0ef90ef0e6ddc9... |
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

