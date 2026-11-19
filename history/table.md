|                                                                                    | v0.1.0             | c129012b5d8e58...  | v0.1.0 / c129012b5d8e58... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0525 ± 0.0089 ms | 17.7 ± 5.1 μs      | 2.97 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.88 ± 0.082 ms    | 0.569 ± 0.024 ms   | 3.31 ± 0.2                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0751 ± 0.013 ms  | 23.9 ± 2.9 μs      | 3.14 ± 0.68                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 12.1 ± 4.7 μs      | 2.91 ± 2.7 μs      | 4.14 ± 4.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.841 ± 0.049 ms   | 0.249 ± 0.017 ms   | 3.38 ± 0.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0382 ± 0.016 ms  | 9.54 ± 1.6 μs      | 4 ± 1.8                    |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 9.21 ± 1.5 μs      | 4.75 ± 3.2 μs      | 1.94 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.942 ± 0.077 ms   | 0.286 ± 0.019 ms   | 3.3 ± 0.35                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 24 ± 1.5 μs        | 9.59 ± 2.1 μs      | 2.5 ± 0.57                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.257 ± 0.039 ms   | 31.2 ± 16 μs       | 8.23 ± 4.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14.5 ± 3.3 ms      | 1.93 ± 0.34 ms     | 7.48 ± 2.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.291 ± 0.026 ms   | 0.043 ± 0.0017 ms  | 6.77 ± 0.67                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 2.97 ± 0.48 μs     | 0.26 ± 0.03 μs     | 11.4 ± 2.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.39 ± 1.5 μs      | 3.99 ± 1.4 μs      | 1.6 ± 0.69                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.43 ± 1.1 μs      | 0.892 ± 0.05 μs    | 9.45 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 22.4 ± 6.2 μs      | 6.35 ± 0.62 μs     | 3.54 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.09 ± 0.03 ms     | 0.383 ± 0.34 ms    | 2.84 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0469 ± 0.0093 ms | 9.96 ± 0.61 μs     | 4.71 ± 0.98                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.392 ± 0.035 ms   | 0.0473 ± 0.0037 ms | 8.28 ± 0.98                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0418 ± 0.0025 s  | 9.45 ± 0.53 ms     | 4.43 ± 0.36                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.368 ± 0.029 ms   | 0.07 ± 0.004 ms    | 5.25 ± 0.51                |
| Convolution body/BLAS axpy per lag                                                 | 0.367 ± 0.011 μs   | 0.38 ± 0.0086 μs   | 0.966 ± 0.037              |
| Convolution body/native axpy per lag                                               | 0.285 ± 0.0076 μs  | 0.278 ± 0.0066 μs  | 1.03 ± 0.037               |
| Convolution body/package                                                           | 0.349 ± 0.0025 μs  | 0.174 ± 0.002 μs   | 2 ± 0.027                  |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10 ± 2.1 μs        | 5.66 ± 0.22 μs     | 1.77 ± 0.38                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.44 ± 1.8 μs      | 1.58 ± 0.99 μs     | 0.911 ± 1.3                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.86 ± 1.2 μs      | 2.84 ± 1.2 μs      | 1.01 ± 0.59                |
| Evaluation/Matrix overview T200_L20_S3                                             | 20.7 ± 1.1 μs      | 11.1 ± 0.55 μs     | 1.86 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.29 ± 0.25 μs     | 0.11 ± 0.09 μs     | 2.64 ± 3.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.96 ± 2.1 μs      | 2.08 ± 0.28 μs     | 1.9 ± 1                    |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 24.8 ± 1.1 μs      | 17.4 ± 1.3 μs      | 1.43 ± 0.13                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.07 ± 0.1 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.0922 ± 0.0056 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 17.8 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0476 ± 0.0024 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.508 ± 0.025 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.22 ± 2 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.639 ± 0.037 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.06 ± 2.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 24.3 ± 1.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 24.2 ± 3.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 30.8 ± 1.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.48 ± 2.4 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.87 ± 2 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.129 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 12 ± 4 μs          |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.1 ± 2.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 16.3 ± 6.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0861 ± 0.0073 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0335 ± 0.0012 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.491 ± 0.031 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0697 ± 0.0065 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.483 ± 0.03 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 12.5 ± 2.9 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 12.8 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 18.4 ± 5.8 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14.3 ± 3.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.035 ± 0.0016 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 22.4 ± 7.2 μs      |                            |
| time_to_load                                                                       | 0.148 ± 0.0046 s   | 0.2 ± 0.005 s      | 0.738 ± 0.029              |

|                                                                                    | v0.1.0                    | c129012b5d8e58...         | v0.1.0 / c129012b5d8e58... |
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

