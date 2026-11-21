|                                                                                    | v0.1.0             | 8d84ce4d165e61...  | v0.1.0 / 8d84ce4d165e61... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0526 ± 0.0095 ms | 18.5 ± 5.9 μs      | 2.85 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.38 ± 0.044 ms    | 0.57 ± 0.023 ms    | 2.42 ± 0.13                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0736 ± 0.012 ms  | 23.9 ± 2.2 μs      | 3.09 ± 0.58                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 11.9 ± 4.7 μs      | 2.86 ± 2.7 μs      | 4.17 ± 4.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.799 ± 0.024 ms   | 0.227 ± 0.019 ms   | 3.51 ± 0.31                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.037 ± 0.015 ms   | 9.02 ± 1.5 μs      | 4.1 ± 1.8                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 8.33 ± 0.92 μs     | 3.02 ± 3.4 μs      | 2.76 ± 3.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.91 ± 0.03 ms     | 0.256 ± 0.014 ms   | 3.55 ± 0.23                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 23.4 ± 1.4 μs      | 9.21 ± 2 μs        | 2.54 ± 0.57                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.266 ± 0.032 ms   | 31.5 ± 17 μs       | 8.46 ± 4.8                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14 ± 2.1 ms        | 1.9 ± 0.2 ms       | 7.36 ± 1.3                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.3 ± 0.031 ms     | 0.0423 ± 0.0015 ms | 7.1 ± 0.77                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.01 ± 0.45 μs     | 0.25 ± 0.03 μs     | 12.1 ± 2.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.25 ± 4.5 μs      | 3.69 ± 1.4 μs      | 1.7 ± 1.4                  |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8 ± 0.94 μs        | 0.881 ± 0.1 μs     | 9.08 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 25.8 ± 6.9 μs      | 10.4 ± 5 μs        | 2.48 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.05 ± 0.018 ms    | 0.358 ± 0.012 ms   | 2.94 ± 0.11                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0481 ± 0.0085 ms | 13 ± 4.8 μs        | 3.69 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.388 ± 0.052 ms   | 0.0485 ± 0.013 ms  | 7.99 ± 2.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 30.6 ± 2.2 ms      | 9.15 ± 0.9 ms      | 3.35 ± 0.41                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.359 ± 0.028 ms   | 0.0711 ± 0.0032 ms | 5.05 ± 0.45                |
| Convolution body/BLAS axpy per lag                                                 | 0.46 ± 0.0026 μs   | 0.429 ± 0.0027 μs  | 1.07 ± 0.0091              |
| Convolution body/native axpy per lag                                               | 0.375 ± 0.0038 μs  | 0.308 ± 0.0035 μs  | 1.22 ± 0.019               |
| Convolution body/package                                                           | 0.46 ± 0.015 μs    | 0.219 ± 0.0021 μs  | 2.1 ± 0.073                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.58 ± 2.2 μs      | 5.79 ± 2.2 μs      | 1.66 ± 0.73                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.38 ± 1.9 μs      | 0.881 ± 0.78 μs    | 1.57 ± 2.6                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.98 ± 1.6 μs      | 1.63 ± 1.6 μs      | 1.22 ± 1.5                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 19.8 ± 0.85 μs     | 12 ± 0.47 μs       | 1.65 ± 0.096               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.291 ± 0.25 μs    | 0.09 ± 0.071 μs    | 3.23 ± 3.8                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.82 ± 2.1 μs      | 1.99 ± 0.19 μs     | 1.92 ± 1.1                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 23.3 ± 1.1 μs      | 16.6 ± 7.1 μs      | 1.41 ± 0.6                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 0.985 ± 0.09 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.0901 ± 0.0055 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 17.3 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0435 ± 0.0013 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.452 ± 0.03 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 3.88 ± 0.82 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.597 ± 0.032 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.15 ± 1.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 25.1 ± 1.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 23.5 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 29.3 ± 1.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4 ± 1.3 μs         |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 3.45 ± 3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.117 ± 0.006 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.1 ± 5.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.1 ± 2.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.7 ± 5.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0835 ± 0.0052 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0317 ± 0.001 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.452 ± 0.041 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0662 ± 0.0043 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.443 ± 0.036 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 10.4 ± 1.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 11.9 ± 5.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 16.7 ± 6 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 13.8 ± 3.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 30.6 ± 1.2 ms      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 22.2 ± 7.8 μs      |                            |
| time_to_load                                                                       | 0.143 ± 0.0046 s   | 0.186 ± 0.0022 s   | 0.767 ± 0.026              |

|                                                                                    | v0.1.0                    | 8d84ce4d165e61...         | v0.1.0 / 8d84ce4d165e61... |
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

