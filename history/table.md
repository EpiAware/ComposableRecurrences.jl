|                                                                                    | v0.1.0             | 5f98d609045840...  | v0.1.0 / 5f98d609045840... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0684 ± 0.0092 ms | 23.2 ± 6.6 μs      | 2.95 ± 0.94                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.34 ± 0.078 ms    | 0.662 ± 0.13 ms    | 3.53 ± 0.69                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0962 ± 0.019 ms  | 31.3 ± 6.6 μs      | 3.08 ± 0.89                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.3 ± 4.1 μs      | 3.44 ± 2.9 μs      | 4.74 ± 4.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.913 ± 0.14 ms    | 0.26 ± 0.049 ms    | 3.51 ± 0.84                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0482 ± 0.014 ms  | 11.7 ± 1.9 μs      | 4.11 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 16 ± 4.1 μs        | 5.85 ± 3.7 μs      | 2.74 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.17 ± 0.086 ms    | 0.29 ± 0.047 ms    | 4.03 ± 0.72                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0359 ± 0.0025 ms | 11.5 ± 2.1 μs      | 3.13 ± 0.62                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.428 ± 0.043 ms   | 0.048 ± 0.015 ms   | 8.9 ± 2.8                  |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14 ± 0.55 ms       | 2.5 ± 0.4 ms       | 5.61 ± 0.93                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.447 ± 0.035 ms   | 0.0644 ± 0.0022 ms | 6.93 ± 0.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.61 ± 0.52 μs     | 0.561 ± 0.3 μs     | 8.21 ± 4.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.7 ± 2.6 μs       | 3.83 ± 1.2 μs      | 2.01 ± 0.93                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.2 ± 1.3 μs      | 1.44 ± 0.22 μs     | 7.82 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 30.5 ± 3.6 μs      | 10.8 ± 4.9 μs      | 2.83 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.81 ± 0.034 ms    | 0.334 ± 0.029 ms   | 5.42 ± 0.48                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0664 ± 0.0079 ms | 16.8 ± 5.1 μs      | 3.97 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.588 ± 0.023 ms   | 0.067 ± 0.027 ms   | 8.78 ± 3.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0512 ± 0.0022 s  | 11.4 ± 0.11 ms     | 4.5 ± 0.2                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.551 ± 0.031 ms   | 0.0981 ± 0.0061 ms | 5.62 ± 0.47                |
| Convolution body/BLAS axpy per lag                                                 | 0.582 ± 0.0012 μs  | 0.441 ± 0.0029 μs  | 1.32 ± 0.009               |
| Convolution body/native axpy per lag                                               | 0.445 ± 0.0046 μs  | 0.441 ± 0.00068 μs | 1.01 ± 0.01                |
| Convolution body/package                                                           | 0.582 ± 0.0012 μs  | 0.316 ± 0.00082 μs | 1.84 ± 0.0062              |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12 ± 2.2 μs        | 8.09 ± 0.74 μs     | 1.49 ± 0.31                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.25 ± 0.31 μs     | 1.89 ± 1.1 μs      | 1.72 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.19 ± 1.5 μs      | 3.01 ± 1.4 μs      | 0.726 ± 0.59               |
| Evaluation/Matrix overview T200_L20_S3                                             | 26.8 ± 1.4 μs      | 18.5 ± 1.4 μs      | 1.45 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.374 ± 0.12 μs    | 0.137 ± 0.021 μs   | 2.73 ± 1                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.88 ± 2.1 μs      | 2.62 ± 0.25 μs     | 1.86 ± 0.84                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0375 ± 0.002 ms  | 25.3 ± 2.2 μs      | 1.48 ± 0.15                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.24 ± 0.41 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.122 ± 0.008 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 22 ± 3.6 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0566 ± 0.0021 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.552 ± 0.17 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.99 ± 0.88 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.581 ± 0.2 ms     |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.45 ± 2.9 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0356 ± 0.003 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 30.1 ± 7.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0372 ± 0.003 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.95 ± 2.8 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6 ± 2.3 μs         |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.163 ± 0.017 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 13.7 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 23 ± 2.9 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 18.9 ± 5.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.112 ± 0.016 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0477 ± 0.003 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.53 ± 0.24 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0878 ± 0.0087 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.503 ± 0.25 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 12 ± 0.18 ms       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 15.4 ± 3.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 21.3 ± 4.3 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.8 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0396 ± 0.0019 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 28.2 ± 8.3 μs      |                            |
| time_to_load                                                                       | 0.209 ± 0.00051 s  | 0.268 ± 0.0018 s   | 0.777 ± 0.0055             |

|                                                                                    | v0.1.0                    | 5f98d609045840...         | v0.1.0 / 5f98d609045840... |
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

