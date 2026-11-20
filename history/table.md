|                                                                                    | v0.1.0            | 6907204cf51a02...  | v0.1.0 / 6907204cf51a02... |
|:-----------------------------------------------------------------------------------|:-----------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.051 ± 0.009 ms  | 18.3 ± 5.4 μs      | 2.79 ± 0.96                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.36 ± 0.025 ms   | 0.536 ± 0.019 ms   | 2.53 ± 0.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0747 ± 0.012 ms | 23.2 ± 6.6 μs      | 3.22 ± 1.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 11.8 ± 5 μs       | 3.97 ± 3.3 μs      | 2.98 ± 2.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.8 ± 0.023 ms    | 0.211 ± 0.012 ms   | 3.79 ± 0.24                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0365 ± 0.015 ms | 8.92 ± 1.4 μs      | 4.09 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 8.29 ± 0.84 μs    | 4.24 ± 3.4 μs      | 1.96 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.897 ± 0.022 ms  | 0.247 ± 0.016 ms   | 3.63 ± 0.25                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 23 ± 1.5 μs       | 9.01 ± 2 μs        | 2.55 ± 0.58                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.258 ± 0.042 ms  | 30.3 ± 18 μs       | 8.52 ± 5.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 13.7 ± 1.4 ms     | 1.87 ± 0.39 ms     | 7.35 ± 1.7                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.285 ± 0.027 ms  | 0.0416 ± 0.0014 ms | 6.86 ± 0.69                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.43 ± 0.44 μs    | 0.241 ± 0.02 μs    | 14.2 ± 2.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.19 ± 0.96 μs    | 3.02 ± 1 μs        | 1.72 ± 0.67                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 7.72 ± 0.79 μs    | 0.861 ± 0.04 μs    | 8.97 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 25.6 ± 6.9 μs     | 9.02 ± 4.3 μs      | 2.84 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.05 ± 0.025 ms   | 0.349 ± 0.012 ms   | 3.01 ± 0.13                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0484 ± 0.014 ms | 12.5 ± 4.4 μs      | 3.88 ± 1.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.376 ± 0.046 ms  | 0.0459 ± 0.025 ms  | 8.18 ± 4.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 30.6 ± 1.7 ms     | 8.67 ± 0.19 ms     | 3.53 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.354 ± 0.028 ms  | 0.0674 ± 0.003 ms  | 5.26 ± 0.47                |
| Convolution body/BLAS axpy per lag                                                 | 0.437 ± 0.0012 μs | 0.463 ± 0.0037 μs  | 0.943 ± 0.008              |
| Convolution body/native axpy per lag                                               | 0.343 ± 0.0035 μs | 0.409 ± 0.011 μs   | 0.84 ± 0.023               |
| Convolution body/package                                                           | 0.437 ± 0.0011 μs | 0.184 ± 0.0005 μs  | 2.37 ± 0.0088              |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.07 ± 0.36 μs    | 5.73 ± 2.1 μs      | 1.58 ± 0.59                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.87 ± 0.21 μs    | 0.781 ± 0.8 μs     | 3.68 ± 3.8                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.81 ± 1.2 μs     | 0.972 ± 0.78 μs    | 2.89 ± 2.6                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 19.4 ± 0.63 μs    | 10.7 ± 0.47 μs     | 1.82 ± 0.1                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.28 ± 0.2 μs     | 0.091 ± 0.06 μs    | 3.08 ± 3                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.09 ± 1.3 μs     | 1.94 ± 0.19 μs     | 2.1 ± 0.7                  |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 22.9 ± 0.59 μs    | 16.7 ± 7.7 μs      | 1.38 ± 0.64                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                   | 0.944 ± 0.073 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                   | 0.0852 ± 0.0031 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                   | 17 ± 2.7 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                   | 0.0422 ± 0.0011 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                   | 0.434 ± 0.024 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                   | 4.48 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                   | 0.572 ± 0.031 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                   | 3.52 ± 1.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                   | 23.5 ± 6.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                   | 23.2 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                   | 28.8 ± 1 μs        |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                   | 4.34 ± 1.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                   | 3.33 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                   | 0.115 ± 0.0063 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                   | 11.1 ± 4.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                   | 17.5 ± 2.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                   | 15.6 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                   | 0.0812 ± 0.005 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                   | 31.6 ± 0.89 μs     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                   | 0.405 ± 0.045 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                   | 0.0635 ± 0.0034 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                   | 0.407 ± 0.047 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                   | 10.3 ± 1.3 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                   | 11.1 ± 5.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                   | 17.3 ± 5.2 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                   | 13.9 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                   | 28.4 ± 0.24 ms     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                   | 21.3 ± 8.2 μs      |                            |
| time_to_load                                                                       | 0.138 ± 0.00084 s | 0.179 ± 0.0014 s   | 0.768 ± 0.0077             |

|                                                                                    | v0.1.0                    | 6907204cf51a02...         | v0.1.0 / 6907204cf51a02... |
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

