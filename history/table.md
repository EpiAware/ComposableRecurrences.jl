|                                                                                    | v0.1.0              | 8b6f7d01f2033f...  | v0.1.0 / 8b6f7d01f2033f... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0939 ± 0.015 ms   | 0.0319 ± 0.0033 ms | 2.94 ± 0.56                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.58 ± 0.038 ms     | 0.802 ± 0.025 ms   | 3.21 ± 0.11                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.156 ± 0.016 ms    | 0.0456 ± 0.011 ms  | 3.42 ± 0.92                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.8 ± 7.7 μs       | 3.32 ± 4.2 μs      | 5.37 ± 7.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.376 ± 0.025 ms    | 0.277 ± 0.015 ms   | 1.35 ± 0.12                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0613 ± 0.016 ms   | 14.1 ± 2 μs        | 4.35 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 13.8 ± 6.9 μs       | 3.84 ± 5.6 μs      | 3.6 ± 5.6                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.404 ± 0.025 ms    | 0.339 ± 0.011 ms   | 1.19 ± 0.084               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0599 ± 0.023 ms   | 14.3 ± 3 μs        | 4.19 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.519 ± 0.07 ms     | 0.0587 ± 0.026 ms  | 8.84 ± 4.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.2 ± 1.5 ms       | 3.35 ± 1.5 ms      | 3.34 ± 1.5                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.579 ± 0.033 ms    | 0.0828 ± 0.003 ms  | 6.99 ± 0.47                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.33 ± 0.34 μs      | 0.421 ± 0.039 μs   | 12.7 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.94 ± 0.63 μs      | 3.39 ± 0.46 μs     | 1.75 ± 0.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.7 ± 0.87 μs      | 1.5 ± 0.13 μs      | 9.13 ± 0.98                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0408 ± 0.011 ms   | 14.3 ± 6.7 μs      | 2.85 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.09 ± 0.029 ms     | 0.361 ± 0.014 ms   | 5.79 ± 0.25                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0916 ± 0.017 ms   | 19.3 ± 7.3 μs      | 4.75 ± 2                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.671 ± 0.096 ms    | 0.0804 ± 0.041 ms  | 8.34 ± 4.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0558 ± 0.004 s    | 12.4 ± 0.63 ms     | 4.49 ± 0.39                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.756 ± 0.033 ms    | 0.146 ± 0.0096 ms  | 5.19 ± 0.41                |
| Convolution body/BLAS axpy per lag                                                 | 0.776 ± 0.0056 μs   | 0.787 ± 0.012 μs   | 0.985 ± 0.017              |
| Convolution body/native axpy per lag                                               | 0.491 ± 0.0042 μs   | 0.496 ± 0.0063 μs  | 0.991 ± 0.015              |
| Convolution body/package                                                           | 0.775 ± 0.0035 μs   | 0.352 ± 0.0047 μs  | 2.2 ± 0.031                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.5 ± 3.3 μs       | 9.05 ± 3.1 μs      | 1.61 ± 0.66                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.63 ± 2.9 μs       | 2.43 ± 1.4 μs      | 0.673 ± 1.3                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.31 ± 1.7 μs       | 3.93 ± 1.6 μs      | 1.1 ± 0.62                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0396 ± 0.00074 ms | 19.5 ± 0.84 μs     | 2.04 ± 0.096               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.561 ± 0.14 μs     | 0.18 ± 0.03 μs     | 3.12 ± 0.94                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 8.7 ± 1.8 μs        | 3.7 ± 0.23 μs      | 2.35 ± 0.51                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0473 ± 0.00075 ms | 30.4 ± 1.2 μs      | 1.55 ± 0.064               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.66 ± 0.13 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.182 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 28 ± 3 μs          |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0876 ± 0.0022 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.64 ± 0.035 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 6.94 ± 1.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.628 ± 0.036 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.79 ± 4.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0466 ± 0.0016 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0409 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.047 ± 0.0011 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.38 ± 4.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.44 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.244 ± 0.017 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 15.5 ± 7.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.9 ± 3.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 22.4 ± 7.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.156 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0592 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.574 ± 0.042 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.116 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.588 ± 1.2 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.4 ± 2 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.3 ± 7.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 25.3 ± 8.4 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 21.6 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0511 ± 0.0032 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0386 ± 0.013 ms  |                            |
| time_to_load                                                                       | 0.24 ± 0.00018 s    | 0.312 ± 0.0014 s   | 0.769 ± 0.0036             |

|                                                                                    | v0.1.0                    | 8b6f7d01f2033f...         | v0.1.0 / 8b6f7d01f2033f... |
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

