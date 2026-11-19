|                                                                                    | v0.1.0              | cc9d0a0cf3a9c1...  | v0.1.0 / cc9d0a0cf3a9c1... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0957 ± 0.016 ms   | 30.9 ± 3 μs        | 3.1 ± 0.6                  |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.67 ± 0.036 ms     | 0.853 ± 0.02 ms    | 3.12 ± 0.086               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.144 ± 0.016 ms    | 0.0432 ± 0.012 ms  | 3.33 ± 0.97                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.5 ± 7.4 μs       | 3.31 ± 4.5 μs      | 5.28 ± 7.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.377 ± 0.023 ms    | 0.271 ± 0.013 ms   | 1.39 ± 0.11                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.06 ± 0.021 ms     | 14.3 ± 2.1 μs      | 4.2 ± 1.6                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.2 ± 6.6 μs       | 7.24 ± 5.7 μs      | 2.1 ± 1.9                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.396 ± 0.023 ms    | 0.338 ± 0.012 ms   | 1.17 ± 0.079               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0597 ± 0.023 ms   | 14.2 ± 2.9 μs      | 4.2 ± 1.8                  |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.534 ± 0.073 ms    | 0.0581 ± 0.025 ms  | 9.19 ± 4.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.2 ± 1.3 ms       | 3.32 ± 0.095 ms    | 3.38 ± 0.4                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.549 ± 0.033 ms    | 0.0835 ± 0.0023 ms | 6.57 ± 0.43                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.49 ± 0.32 μs      | 0.431 ± 0.08 μs    | 12.7 ± 2.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.07 ± 0.87 μs      | 3.35 ± 0.63 μs     | 1.81 ± 0.43                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.8 ± 0.88 μs      | 1.46 ± 0.14 μs     | 9.44 ± 1.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0411 ± 0.011 ms   | 14.6 ± 4.6 μs      | 2.81 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.01 ± 0.025 ms     | 0.368 ± 0.015 ms   | 5.47 ± 0.23                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0905 ± 0.022 ms   | 17.5 ± 7.2 μs      | 5.19 ± 2.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.673 ± 0.092 ms    | 0.0812 ± 0.042 ms  | 8.29 ± 4.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0557 ± 0.0037 s   | 12.3 ± 0.33 ms     | 4.53 ± 0.32                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.718 ± 0.022 ms    | 0.136 ± 0.01 ms    | 5.29 ± 0.43                |
| Convolution body/BLAS axpy per lag                                                 | 0.786 ± 0.0049 μs   | 0.78 ± 0.0072 μs   | 1.01 ± 0.011               |
| Convolution body/native axpy per lag                                               | 0.505 ± 0.0069 μs   | 0.496 ± 0.0059 μs  | 1.02 ± 0.018               |
| Convolution body/package                                                           | 0.785 ± 0.0045 μs   | 0.358 ± 0.0059 μs  | 2.19 ± 0.038               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.5 ± 3.4 μs       | 8.97 ± 0.38 μs     | 1.61 ± 0.38                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.66 ± 2.9 μs       | 2.48 ± 0.55 μs     | 0.669 ± 1.2                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.35 ± 1.7 μs       | 3.97 ± 1.7 μs      | 1.1 ± 0.63                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0399 ± 0.00097 ms | 19.5 ± 0.85 μs     | 2.04 ± 0.1                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.541 ± 0.14 μs     | 0.18 ± 0.031 μs    | 3.01 ± 0.94                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.46 ± 3 μs         | 3.7 ± 0.22 μs      | 2.02 ± 0.82                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0472 ± 0.0011 ms  | 31.3 ± 1.9 μs      | 1.51 ± 0.096               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.67 ± 0.061 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.17 ± 0.01 ms     |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.8 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0875 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.628 ± 0.027 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.2 ± 3.2 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.626 ± 0.027 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.95 ± 4.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0459 ± 0.0091 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0394 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0492 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.47 ± 4.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.93 ± 4.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.23 ± 0.013 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.5 ± 6.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.9 ± 3.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 22.8 ± 9.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.15 ± 0.011 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0597 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.547 ± 0.039 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.117 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.539 ± 0.038 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.2 ± 1.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.4 ± 7.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 27.3 ± 6.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.4 ± 5 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0492 ± 0.0017 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0373 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.243 ± 0.0026 s    | 0.313 ± 0.0019 s   | 0.777 ± 0.0096             |

|                                                                                    | v0.1.0                    | cc9d0a0cf3a9c1...         | v0.1.0 / cc9d0a0cf3a9c1... |
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

