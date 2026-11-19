|                                                                                    | v0.1.0             | 71cc76f4f41c7e...  | v0.1.0 / 71cc76f4f41c7e... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0551 ± 0.01 ms   | 17.8 ± 5.8 μs      | 3.09 ± 1.2                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.96 ± 0.043 ms    | 0.557 ± 0.022 ms   | 3.51 ± 0.16                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0785 ± 0.013 ms  | 23.9 ± 2.3 μs      | 3.29 ± 0.62                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 14.8 ± 5.3 μs      | 3.73 ± 3.1 μs      | 3.96 ± 3.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.879 ± 0.035 ms   | 0.232 ± 0.012 ms   | 3.79 ± 0.25                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0393 ± 0.017 ms  | 9.64 ± 1.5 μs      | 4.07 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.5 ± 3.2 μs      | 4.96 ± 3.6 μs      | 2.31 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1 ± 0.4 ms         | 0.268 ± 0.01 ms    | 3.73 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 25.3 ± 1 μs        | 9.61 ± 2.2 μs      | 2.64 ± 0.6                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.285 ± 0.043 ms   | 30.3 ± 17 μs       | 9.41 ± 5.6                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 15.9 ± 2.7 ms      | 1.95 ± 0.15 ms     | 8.17 ± 1.5                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.307 ± 0.027 ms   | 0.0426 ± 0.0027 ms | 7.2 ± 0.78                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.37 ± 0.5 μs      | 0.251 ± 0.021 μs   | 13.4 ± 2.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.35 ± 1.7 μs      | 3.33 ± 1.3 μs      | 1.9 ± 0.88                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.45 ± 1.1 μs      | 0.901 ± 0.11 μs    | 9.38 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 22.6 ± 6.5 μs      | 5.89 ± 0.58 μs     | 3.83 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.14 ± 0.019 ms    | 0.366 ± 0.04 ms    | 3.12 ± 0.34                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0496 ± 0.0076 ms | 9.79 ± 0.58 μs     | 5.06 ± 0.83                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.439 ± 0.021 ms   | 0.0453 ± 0.0053 ms | 9.67 ± 1.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0444 ± 0.0025 s  | 9.63 ± 1.3 ms      | 4.61 ± 0.67                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.388 ± 0.035 ms   | 0.0677 ± 0.0045 ms | 5.73 ± 0.64                |
| Convolution body/BLAS axpy per lag                                                 | 0.493 ± 0.0034 μs  | 0.533 ± 0.0038 μs  | 0.927 ± 0.0092             |
| Convolution body/native axpy per lag                                               | 0.416 ± 0.0052 μs  | 0.386 ± 0.0048 μs  | 1.08 ± 0.019               |
| Convolution body/package                                                           | 0.492 ± 0.0034 μs  | 0.209 ± 0.0013 μs  | 2.35 ± 0.022               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.2 ± 2.4 μs      | 5.98 ± 1.3 μs      | 1.71 ± 0.54                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.37 ± 2 μs        | 1.05 ± 0.88 μs     | 1.3 ± 2.2                  |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.96 ± 1.2 μs      | 1.8 ± 1.7 μs       | 1.64 ± 1.7                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 21 ± 1.1 μs        | 11.1 ± 0.52 μs     | 1.89 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.321 ± 0.25 μs    | 0.11 ± 0.07 μs     | 2.92 ± 2.9                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.16 ± 1.2 μs      | 2.04 ± 0.18 μs     | 1.55 ± 0.62                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 25.3 ± 1.2 μs      | 17.1 ± 7.6 μs      | 1.48 ± 0.66                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.02 ± 0.063 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.0893 ± 0.0075 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 18.4 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0463 ± 0.0015 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.497 ± 0.041 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.03 ± 0.58 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.64 ± 0.047 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.33 ± 1.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 24.6 ± 0.88 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 23.9 ± 7.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 30.2 ± 0.96 μs     |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.95 ± 2.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 3.98 ± 3.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.122 ± 0.0087 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.7 ± 5.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.9 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.9 ± 6 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0852 ± 0.006 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0329 ± 0.0013 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.475 ± 0.037 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0656 ± 0.0063 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.458 ± 0.037 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.4 ± 2.7 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 12.6 ± 4 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 18.4 ± 5 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14.5 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 31.6 ± 3.6 ms      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 22.4 ± 7.7 μs      |                            |
| time_to_load                                                                       | 0.158 ± 0.001 s    | 0.204 ± 0.002 s    | 0.775 ± 0.0091             |

|                                                                                    | v0.1.0                    | 71cc76f4f41c7e...         | v0.1.0 / 71cc76f4f41c7e... |
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

