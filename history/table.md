|                                                                                    | v0.1.0              | 47a3c801c1fe34...  | v0.1.0 / 47a3c801c1fe34... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0965 ± 0.016 ms   | 30.9 ± 7.8 μs      | 3.12 ± 0.94                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.65 ± 0.023 ms     | 0.852 ± 0.014 ms   | 3.11 ± 0.057               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.144 ± 0.032 ms    | 0.0426 ± 0.011 ms  | 3.38 ± 1.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 18.1 ± 5.8 μs       | 3.21 ± 4.5 μs      | 5.63 ± 8                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.384 ± 0.024 ms    | 0.274 ± 0.014 ms   | 1.4 ± 0.11                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0614 ± 0.022 ms   | 14.2 ± 2 μs        | 4.33 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.8 ± 6.8 μs       | 7.5 ± 5.7 μs       | 2.1 ± 1.8                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.4 ± 0.023 ms      | 0.339 ± 0.012 ms   | 1.18 ± 0.079               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.058 ± 0.023 ms    | 14.7 ± 2.9 μs      | 3.95 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.532 ± 0.067 ms    | 0.058 ± 0.011 ms   | 9.17 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.1 ± 1.4 ms       | 3.31 ± 0.098 ms    | 3.36 ± 0.42                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.551 ± 0.034 ms    | 0.085 ± 0.0021 ms  | 6.48 ± 0.43                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.53 ± 0.34 μs      | 0.411 ± 0.05 μs    | 13.5 ± 1.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.22 ± 0.89 μs      | 3.47 ± 0.66 μs     | 1.79 ± 0.43                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.8 ± 0.97 μs      | 1.47 ± 0.16 μs     | 9.39 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0419 ± 0.012 ms   | 14.3 ± 6.9 μs      | 2.93 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.02 ± 0.033 ms     | 0.366 ± 0.013 ms   | 5.51 ± 0.22                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0888 ± 0.024 ms   | 21.8 ± 7.3 μs      | 4.07 ± 1.8                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.664 ± 0.12 ms     | 0.0823 ± 0.042 ms  | 8.07 ± 4.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0567 ± 0.0025 s   | 12.6 ± 1.1 ms      | 4.51 ± 0.43                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.72 ± 0.027 ms     | 0.136 ± 0.009 ms   | 5.3 ± 0.4                  |
| Convolution body/BLAS axpy per lag                                                 | 0.785 ± 0.0029 μs   | 0.776 ± 0.0043 μs  | 1.01 ± 0.0068              |
| Convolution body/native axpy per lag                                               | 0.55 ± 0.012 μs     | 0.493 ± 0.006 μs   | 1.12 ± 0.029               |
| Convolution body/package                                                           | 0.786 ± 0.0042 μs   | 0.358 ± 0.0056 μs  | 2.2 ± 0.036                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.9 ± 0.35 μs      | 9.08 ± 3.1 μs      | 1.54 ± 0.53                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.41 ± 0.23 μs      | 2.29 ± 1.6 μs      | 1.92 ± 1.3                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.36 ± 1.7 μs       | 2.7 ± 2.7 μs       | 1.61 ± 1.7                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0394 ± 0.00095 ms | 19.5 ± 0.94 μs     | 2.02 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.541 ± 0.19 μs     | 0.18 ± 0.02 μs     | 3.01 ± 1.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.92 ± 1.7 μs       | 3.67 ± 0.2 μs      | 1.61 ± 0.48                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0473 ± 0.00095 ms | 31.2 ± 1.1 μs      | 1.52 ± 0.06                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.63 ± 0.084 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.172 ± 0.0088 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.8 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0869 ± 0.0022 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.626 ± 0.031 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.75 ± 4.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.62 ± 0.025 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 5.05 ± 4 μs        |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0462 ± 0.0041 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0396 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0492 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.61 ± 3.9 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.95 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.232 ± 0.014 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.1 ± 7 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.6 ± 3.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 23 ± 9.2 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.151 ± 0.0098 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0599 ± 0.0016 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.566 ± 0.043 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.117 ± 0.0092 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.542 ± 0.035 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.7 ± 2 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.4 ± 6.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 26.3 ± 9.6 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.3 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.051 ± 0.0016 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.037 ± 0.014 ms   |                            |
| time_to_load                                                                       | 0.241 ± 0.00093 s   | 0.31 ± 0.002 s     | 0.777 ± 0.0058             |

|                                                                                    | v0.1.0                    | 47a3c801c1fe34...         | v0.1.0 / 47a3c801c1fe34... |
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

