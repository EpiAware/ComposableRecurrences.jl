|                                                                                    | v0.1.0             | aee614e981d65e...  | v0.1.0 / aee614e981d65e... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.052 ± 0.009 ms   | 18.6 ± 5.4 μs      | 2.8 ± 0.95                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.37 ± 0.056 ms    | 0.575 ± 0.029 ms   | 2.38 ± 0.15                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0743 ± 0.012 ms  | 24.5 ± 2.2 μs      | 3.03 ± 0.57                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 11.5 ± 4.6 μs      | 3.09 ± 2.7 μs      | 3.72 ± 3.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.812 ± 0.036 ms   | 0.234 ± 0.019 ms   | 3.46 ± 0.33                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0364 ± 0.014 ms  | 9.27 ± 1.5 μs      | 3.93 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 8.68 ± 1.3 μs      | 5.22 ± 3.7 μs      | 1.66 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.934 ± 0.42 ms    | 0.29 ± 0.021 ms    | 3.22 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 23.8 ± 0.87 μs     | 9.65 ± 2.1 μs      | 2.47 ± 0.54                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.255 ± 0.021 ms   | 0.0327 ± 0.018 ms  | 7.79 ± 4.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 13.9 ± 1.5 ms      | 1.98 ± 0.17 ms     | 7.05 ± 0.95                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.292 ± 0.029 ms   | 0.0438 ± 0.0021 ms | 6.65 ± 0.73                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.05 ± 0.51 μs     | 0.261 ± 0.03 μs    | 11.7 ± 2.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.64 ± 4.7 μs      | 3.75 ± 1 μs        | 1.77 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 7.93 ± 1 μs        | 0.882 ± 0.041 μs   | 8.99 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 21.6 ± 6.1 μs      | 7.32 ± 4.6 μs      | 2.95 ± 2                   |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.11 ± 0.047 ms    | 0.382 ± 0.012 ms   | 2.89 ± 0.16                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0461 ± 0.0069 ms | 13.5 ± 5 μs        | 3.42 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.375 ± 0.021 ms   | 0.0486 ± 0.0092 ms | 7.71 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 30.5 ± 1.4 ms      | 9.81 ± 1.9 ms      | 3.11 ± 0.63                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.367 ± 0.027 ms   | 0.0711 ± 0.0036 ms | 5.16 ± 0.46                |
| Convolution body/BLAS axpy per lag                                                 | 0.442 ± 0.0027 μs  | 0.641 ± 0.012 μs   | 0.69 ± 0.014               |
| Convolution body/native axpy per lag                                               | 0.35 ± 0.0067 μs   | 0.512 ± 0.02 μs    | 0.685 ± 0.03               |
| Convolution body/package                                                           | 0.444 ± 0.0081 μs  | 0.28 ± 0.0091 μs   | 1.59 ± 0.059               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.45 ± 0.68 μs     | 5.98 ± 2.2 μs      | 1.58 ± 0.6                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.87 ± 0.19 μs     | 0.841 ± 0.25 μs    | 3.42 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.8 ± 1.2 μs       | 1.18 ± 0.94 μs     | 2.37 ± 2.1                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 20.3 ± 0.74 μs     | 12.5 ± 0.52 μs     | 1.62 ± 0.09                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.321 ± 0.22 μs    | 0.1 ± 0.081 μs     | 3.21 ± 3.4                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.3 ± 1.3 μs       | 1.97 ± 0.19 μs     | 2.18 ± 0.68                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 23.8 ± 0.92 μs     | 16.6 ± 7 μs        | 1.43 ± 0.6                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1 ± 0.071 ms       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.0924 ± 0.0053 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 17.6 ± 2.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0447 ± 0.0022 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.527 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.31 ± 2.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.622 ± 0.033 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.29 ± 1.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 25.7 ± 9 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 25 ± 5.1 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 30.2 ± 1.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.75 ± 1.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 3.59 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.124 ± 0.0077 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.9 ± 4.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.9 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.6 ± 5.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0889 ± 0.005 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0322 ± 0.0014 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.517 ± 0.028 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0693 ± 0.005 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.469 ± 0.029 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.5 ± 2.7 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 13.4 ± 6.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 20.5 ± 5.9 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14 ± 3.1 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0339 ± 0.0021 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 22.1 ± 4.1 μs      |                            |
| time_to_load                                                                       | 0.14 ± 0.0018 s    | 0.191 ± 0.0094 s   | 0.732 ± 0.037              |

|                                                                                    | v0.1.0                    | aee614e981d65e...         | v0.1.0 / aee614e981d65e... |
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
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.08 k allocs: 0.0695 MB  | 5.07                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 17  allocs: 1.97 kB       | 2.04                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 23  allocs: 18.1 kB       | 1.58                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 22  allocs: 2.39 kB       | 4.91                       |
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
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 5  allocs: 0.641 kB       | 1.85                       |
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
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.134 k allocs: 0.0635 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.301 k allocs: 0.265 MB  |                            |
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

