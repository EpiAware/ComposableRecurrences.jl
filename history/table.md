|                                                                                    | v0.1.0             | 1532338c1eb3f3...  | v0.1.0 / 1532338c1eb3f3... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0822 ± 0.01 ms   | 26.5 ± 6.9 μs      | 3.1 ± 0.9                  |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.72 ± 0.061 ms    | 0.898 ± 0.029 ms   | 3.03 ± 0.12                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.13 ± 0.016 ms    | 0.0375 ± 0.0087 ms | 3.46 ± 0.91                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 18.2 ± 5.6 μs      | 7.84 ± 5 μs        | 2.33 ± 1.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.18 ± 0.032 ms    | 0.344 ± 0.035 ms   | 3.43 ± 0.36                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.056 ± 0.017 ms   | 15.6 ± 2.6 μs      | 3.58 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 14.1 ± 1.4 μs      | 4.21 ± 4.4 μs      | 3.35 ± 3.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.32 ± 0.46 ms     | 0.383 ± 0.025 ms   | 3.46 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0416 ± 0.0021 ms | 13.4 ± 2.2 μs      | 3.1 ± 0.53                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.412 ± 0.044 ms   | 0.0556 ± 0.011 ms  | 7.42 ± 1.6                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 19.7 ± 3 ms        | 3.46 ± 0.11 ms     | 5.71 ± 0.88                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.559 ± 0.04 ms    | 0.0783 ± 0.0041 ms | 7.14 ± 0.63                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.75 ± 0.46 μs     | 0.754 ± 0.32 μs    | 6.3 ± 2.7                  |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 9 ± 4.9 μs         | 4.17 ± 0.48 μs     | 2.16 ± 1.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.1 ± 0.93 μs     | 1.64 ± 0.26 μs     | 7.95 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0377 ± 0.0024 ms | 9.5 ± 4.5 μs       | 3.97 ± 1.9                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.1 ± 0.058 ms     | 0.466 ± 0.026 ms   | 4.5 ± 0.28                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0797 ± 0.0082 ms | 22.8 ± 5.9 μs      | 3.49 ± 0.97                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.616 ± 0.053 ms   | 0.0771 ± 0.012 ms  | 7.98 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0596 ± 0.0023 s  | 15.3 ± 0.69 ms     | 3.88 ± 0.23                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.713 ± 0.048 ms   | 0.123 ± 0.0074 ms  | 5.78 ± 0.52                |
| Convolution body/BLAS axpy per lag                                                 | 0.563 ± 0.0077 μs  | 0.566 ± 0.023 μs   | 0.995 ± 0.042              |
| Convolution body/native axpy per lag                                               | 0.569 ± 0.02 μs    | 0.563 ± 0.037 μs   | 1.01 ± 0.075               |
| Convolution body/package                                                           | 0.562 ± 0.02 μs    | 0.402 ± 0.016 μs   | 1.4 ± 0.074                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.8 ± 2.6 μs      | 8.98 ± 0.29 μs     | 1.54 ± 0.3                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.55 ± 2.2 μs      | 3.44 ± 2.1 μs      | 1.03 ± 0.88                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.73 ± 1 μs        | 1.51 ± 2.1 μs      | 1.14 ± 1.7                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0317 ± 0.0014 ms | 22.9 ± 1.2 μs      | 1.38 ± 0.095               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.483 ± 0.24 μs    | 0.176 ± 0.029 μs   | 2.74 ± 1.4                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.13 ± 1.6 μs      | 3.29 ± 0.3 μs      | 2.16 ± 0.54                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.044 ± 0.003 ms   | 29.4 ± 5 μs        | 1.5 ± 0.27                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.76 ± 0.11 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.151 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 25.3 ± 3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0714 ± 0.0036 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.896 ± 0.068 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 6.31 ± 2.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.861 ± 0.063 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.07 ± 3.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0413 ± 0.0071 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0356 ± 0.0096 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0443 ± 0.0024 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 5.17 ± 1.9 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 7.84 ± 2.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.202 ± 0.016 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 14.2 ± 6.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 26.4 ± 6.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 21.3 ± 5.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.133 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0554 ± 0.0059 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.881 ± 0.059 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.103 ± 0.0088 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.838 ± 0.1 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 17 ± 2.7 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.7 ± 4.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 22.5 ± 6.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.5 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0619 ± 0.0027 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0341 ± 0.01 ms   |                            |
| time_to_load                                                                       | 0.243 ± 0.0015 s   | 0.258 ± 0.004 s    | 0.942 ± 0.016              |

|                                                                                    | v0.1.0                    | 1532338c1eb3f3...         | v0.1.0 / 1532338c1eb3f3... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 18.5 kB       | 1.39                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.034 k allocs: 24 kB     | 2.65                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.084 k allocs: 0.0867 MB | 2.71                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.081 k allocs: 0.0871 MB | 4.05                       |
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
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 28  allocs: 29.7 kB       | 1.37                       |
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

