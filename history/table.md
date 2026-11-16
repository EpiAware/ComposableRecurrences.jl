|                                                                                    | v0.1.0            | 8130359eb14d90...  | v0.1.0 / 8130359eb14d90... |
|:-----------------------------------------------------------------------------------|:-----------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0579 ± 0.01 ms  | 19.1 ± 5.7 μs      | 3.02 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.48 ± 0.056 ms   | 0.603 ± 0.025 ms   | 2.46 ± 0.14                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0934 ± 0.02 ms  | 26.8 ± 2.5 μs      | 3.48 ± 0.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 13 ± 3.5 μs       | 5.85 ± 3.8 μs      | 2.22 ± 1.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.872 ± 0.058 ms  | 0.227 ± 0.028 ms   | 3.84 ± 0.54                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0391 ± 0.017 ms | 11 ± 2.2 μs        | 3.55 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 8.77 ± 0.85 μs    | 5.11 ± 3.2 μs      | 1.72 ± 1.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.973 ± 0.4 ms    | 0.278 ± 0.014 ms   | 3.5 ± 1.4                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 24.9 ± 1.2 μs     | 9.51 ± 2.1 μs      | 2.62 ± 0.6                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.243 ± 0.024 ms  | 0.0346 ± 0.008 ms  | 7.03 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 15 ± 1.9 ms       | 2.06 ± 0.5 ms      | 7.29 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.334 ± 0.029 ms  | 0.0486 ± 0.0016 ms | 6.86 ± 0.63                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 2.9 ± 0.44 μs     | 0.261 ± 0.03 μs    | 11.1 ± 2.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.84 ± 4.3 μs     | 4.02 ± 1 μs        | 1.7 ± 1.2                  |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.6 ± 1.2 μs      | 0.961 ± 0.05 μs    | 8.95 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.1 ± 7 μs       | 6.93 ± 4.6 μs      | 3.76 ± 2.7                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.15 ± 0.055 ms   | 0.318 ± 0.013 ms   | 3.63 ± 0.23                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0503 ± 0.011 ms | 15.6 ± 4.5 μs      | 3.21 ± 1.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.381 ± 0.062 ms  | 0.0476 ± 0.03 ms   | 8.01 ± 5.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0335 ± 0.0024 s | 8.89 ± 0.36 ms     | 3.77 ± 0.31                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.438 ± 0.039 ms  | 0.0795 ± 0.0029 ms | 5.51 ± 0.54                |
| Convolution body/BLAS axpy per lag                                                 | 0.451 ± 0.0069 μs | 0.533 ± 0.018 μs   | 0.846 ± 0.032              |
| Convolution body/native axpy per lag                                               | 0.378 ± 0.0074 μs | 0.399 ± 0.011 μs   | 0.948 ± 0.032              |
| Convolution body/package                                                           | 0.465 ± 0.021 μs  | 0.197 ± 0.0042 μs  | 2.36 ± 0.12                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.53 ± 0.77 μs    | 6.21 ± 1.2 μs      | 1.54 ± 0.32                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.83 ± 0.22 μs    | 1.34 ± 1.7 μs      | 2.11 ± 2.7                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2 ± 1.5 μs        | 1.14 ± 0.69 μs     | 1.75 ± 1.7                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 20.2 ± 0.88 μs    | 15.9 ± 0.54 μs     | 1.26 ± 0.07                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.29 ± 0.24 μs    | 0.12 ± 0.021 μs    | 2.42 ± 2.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.98 ± 2.2 μs     | 2.09 ± 0.22 μs     | 1.9 ± 1                    |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 24.6 ± 1.1 μs     | 18.1 ± 1.3 μs      | 1.36 ± 0.12                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                   | 1.2 ± 0.081 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                   | 0.101 ± 0.0048 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                   | 18.4 ± 2.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                   | 0.0476 ± 0.0018 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                   | 0.485 ± 0.022 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                   | 4.96 ± 3.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                   | 0.569 ± 0.023 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                   | 4.12 ± 1.1 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                   | 26.4 ± 0.93 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                   | 26.1 ± 6.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                   | 31 ± 1.6 μs        |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                   | 4.71 ± 1.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                   | 3.56 ± 3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                   | 0.135 ± 0.0091 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                   | 11.4 ± 3.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                   | 19.2 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                   | 15 ± 6.8 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                   | 0.0875 ± 0.0063 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                   | 0.0338 ± 0.0011 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                   | 0.464 ± 0.056 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                   | 0.071 ± 0.0065 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                   | 0.466 ± 0.049 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                   | 11.3 ± 1.7 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                   | 11.9 ± 4.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                   | 17.3 ± 5.2 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                   | 13.6 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                   | 0.0345 ± 0.0031 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                   | 24.6 ± 5 μs        |                            |
| time_to_load                                                                       | 0.158 ± 0.0028 s  | 0.164 ± 0.0066 s   | 0.968 ± 0.043              |

|                                                                                    | v0.1.0                    | 8130359eb14d90...         | v0.1.0 / 8130359eb14d90... |
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

