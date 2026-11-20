|                                                                                    | v0.1.0             | fad6d56c4312c0...  | v0.1.0 / fad6d56c4312c0... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0944 ± 0.016 ms  | 31.1 ± 8.8 μs      | 3.03 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.65 ± 0.026 ms    | 0.86 ± 0.016 ms    | 3.08 ± 0.065               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.145 ± 0.029 ms   | 0.0433 ± 0.011 ms  | 3.34 ± 1.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.9 ± 5.9 μs      | 7.45 ± 5.7 μs      | 2.4 ± 2                    |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.391 ± 0.028 ms   | 0.282 ± 0.013 ms   | 1.39 ± 0.12                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0609 ± 0.023 ms  | 14.5 ± 2.1 μs      | 4.19 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.9 ± 1.1 μs      | 4.01 ± 5.7 μs      | 2.98 ± 4.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.408 ± 0.026 ms   | 0.34 ± 0.012 ms    | 1.2 ± 0.087                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0398 ± 0.0011 ms | 14.3 ± 2.9 μs      | 2.78 ± 0.57                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.53 ± 0.07 ms     | 0.0588 ± 0.026 ms  | 9.01 ± 4.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.4 ± 1.6 ms      | 3.34 ± 0.12 ms     | 3.42 ± 0.48                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.549 ± 0.035 ms   | 0.0835 ± 0.0023 ms | 6.57 ± 0.46                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.5 ± 0.35 μs      | 0.451 ± 0.06 μs    | 12.2 ± 1.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.19 ± 1 μs        | 3.43 ± 0.68 μs     | 1.81 ± 0.46                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 14 ± 1 μs          | 1.54 ± 0.12 μs     | 9.07 ± 0.96                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0329 ± 0.011 ms  | 14.9 ± 7 μs        | 2.21 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.02 ± 0.02 ms     | 0.377 ± 0.015 ms   | 5.35 ± 0.22                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0841 ± 0.0099 ms | 22.2 ± 7.2 μs      | 3.79 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.669 ± 0.068 ms   | 0.0845 ± 0.021 ms  | 7.92 ± 2.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0571 ± 0.0018 s  | 13.2 ± 0.27 ms     | 4.33 ± 0.16                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.714 ± 0.025 ms   | 0.137 ± 0.0099 ms  | 5.23 ± 0.42                |
| Convolution body/BLAS axpy per lag                                                 | 0.782 ± 0.0042 μs  | 0.778 ± 0.0033 μs  | 1.01 ± 0.0069              |
| Convolution body/native axpy per lag                                               | 0.505 ± 0.0053 μs  | 0.495 ± 0.006 μs   | 1.02 ± 0.016               |
| Convolution body/package                                                           | 0.784 ± 0.0097 μs  | 0.358 ± 0.0047 μs  | 2.19 ± 0.04                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.3 ± 3.3 μs      | 9.05 ± 1.9 μs      | 1.58 ± 0.49                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.93 ± 3 μs        | 2.37 ± 1.6 μs      | 0.814 ± 1.4                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.44 ± 1.7 μs      | 2.76 ± 1.8 μs      | 1.61 ± 1.2                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0399 ± 0.0012 ms | 19.4 ± 0.84 μs     | 2.06 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.551 ± 0.16 μs    | 0.16 ± 0.021 μs    | 3.44 ± 1.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.16 ± 3.2 μs      | 3.69 ± 0.2 μs      | 1.94 ± 0.87                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0475 ± 0.0012 ms | 31.4 ± 1.5 μs      | 1.51 ± 0.08                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.69 ± 0.087 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.177 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 28.1 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.088 ± 0.0028 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.664 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 7.86 ± 4.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.661 ± 0.038 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 5.01 ± 4 μs        |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0489 ± 0.0069 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0403 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.052 ± 0.0016 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 5.71 ± 4.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6 ± 4.5 μs         |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.236 ± 0.021 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 16.9 ± 9.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 29.2 ± 3.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 23.4 ± 9.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.157 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0601 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.597 ± 0.025 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.119 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.585 ± 0.029 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 16.5 ± 2.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 18.4 ± 7.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 27 ± 8.1 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 23.5 ± 5 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0534 ± 0.0013 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0372 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.242 ± 0.0013 s   | 0.315 ± 0.001 s    | 0.769 ± 0.0047             |

|                                                                                    | v0.1.0                    | fad6d56c4312c0...         | v0.1.0 / fad6d56c4312c0... |
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

