|                                                                                    | v0.1.0              | 16b7b2f7221037...   | v0.1.0 / 16b7b2f7221037... |
|:-----------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.117 ± 0.015 ms    | 30.5 ± 7.9 μs       | 3.82 ± 1.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.61 ± 0.043 ms     | 0.807 ± 0.77 ms     | 3.24 ± 3.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.194 ± 0.02 ms     | 0.0455 ± 0.0032 ms  | 4.27 ± 0.52                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.4 ± 8.1 μs       | 8.67 ± 7 μs         | 2 ± 1.9                    |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.367 ± 0.027 ms    | 0.27 ± 0.013 ms     | 1.36 ± 0.12                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0632 ± 0.024 ms   | 16.9 ± 3.1 μs       | 3.75 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.8 ± 0.76 μs      | 3.95 ± 5.5 μs       | 2.99 ± 4.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.396 ± 0.029 ms    | 0.341 ± 0.01 ms     | 1.16 ± 0.092               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.074 ± 0.0012 ms   | 13.9 ± 2.8 μs       | 5.33 ± 1.1                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.455 ± 0.066 ms    | 0.061 ± 0.0016 ms   | 7.45 ± 1.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.4 ± 1.2 ms       | 3.34 ± 0.11 ms      | 3.4 ± 0.38                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.597 ± 0.021 ms    | 0.0868 ± 0.0021 ms  | 6.89 ± 0.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 8.21 ± 0.4 μs       | 0.43 ± 0.031 μs     | 19.1 ± 1.7                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.22 ± 8.3 μs       | 3.25 ± 0.39 μs      | 1.92 ± 2.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.0331 ± 0.001 ms   | 1.47 ± 0.091 μs     | 22.5 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.036 ± 0.01 ms     | 14.3 ± 6.8 μs       | 2.51 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.06 ± 0.022 ms     | 0.366 ± 0.012 ms    | 5.63 ± 0.19                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0894 ± 0.0096 ms  | 23.9 ± 7.1 μs       | 3.75 ± 1.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.669 ± 0.023 ms    | 0.0803 ± 0.04 ms    | 8.33 ± 4.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0566 ± 0.0021 s   | 12.5 ± 0.31 ms      | 4.55 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.779 ± 0.036 ms    | 0.144 ± 0.0091 ms   | 5.4 ± 0.42                 |
| Convolution body/BLAS axpy per lag                                                 | 0.779 ± 0.0053 μs   | 0.784 ± 0.0024 μs   | 0.993 ± 0.0074             |
| Convolution body/native axpy per lag                                               | 0.493 ± 0.006 μs    | 0.504 ± 0.0055 μs   | 0.977 ± 0.016              |
| Convolution body/package                                                           | 0.779 ± 0.0052 μs   | 0.341 ± 0.0078 μs   | 2.28 ± 0.055               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 15 ± 0.39 μs        | 8.99 ± 3.1 μs       | 1.67 ± 0.59                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.38 ± 0.25 μs      | 4.14 ± 0.27 μs      | 1.06 ± 0.092               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.83 ± 2.8 μs       | 3.93 ± 1.7 μs       | 0.467 ± 0.73               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0399 ± 0.00076 ms | 21.2 ± 0.74 μs      | 1.88 ± 0.075               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.571 ± 0.15 μs     | 0.181 ± 0.021 μs    | 3.15 ± 0.9                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.75 ± 1.8 μs       | 3.66 ± 0.16 μs      | 2.12 ± 0.51                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.048 ± 0.00083 ms  | 30.5 ± 1.1 μs       | 1.58 ± 0.061               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.62 ± 0.071 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.18 ± 0.0042 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.7 ± 3.8 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0862 ± 0.002 ms   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.627 ± 0.025 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 6.74 ± 0.42 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.604 ± 0.023 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.76 ± 4.3 μs       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0456 ± 0.0012 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0409 ± 0.013 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0465 ± 0.00093 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.46 ± 4.3 μs       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.91 ± 4.5 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.239 ± 0.0099 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 15.9 ± 6.1 μs       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.8 ± 3.7 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 21.9 ± 9.6 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.148 ± 0.004 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.058 ± 0.0015 ms   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.566 ± 0.028 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.115 ± 0.0027 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.525 ± 0.035 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.6 ± 1.9 ms       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.8 ± 11 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 24.7 ± 9.3 μs       |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 21.7 ± 5 μs         |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0493 ± 0.0018 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0382 ± 0.013 ms   |                            |
| time_to_load                                                                       | 0.239 ± 0.00041 s   | 0.253 ± 0.0023 s    | 0.944 ± 0.0088             |

|                                                                                    | v0.1.0                    | 16b7b2f7221037...         | v0.1.0 / 16b7b2f7221037... |
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

