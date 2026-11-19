|                                                                                    | v0.1.0              | 1f5b1655e1c406...  | v0.1.0 / 1f5b1655e1c406... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0743 ± 0.013 ms   | 25.4 ± 7.6 μs      | 2.93 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.87 ± 0.024 ms     | 0.819 ± 0.012 ms   | 2.28 ± 0.045               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.113 ± 0.027 ms    | 0.0367 ± 0.01 ms   | 3.08 ± 1.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.5 ± 6.9 μs       | 3.21 ± 3.8 μs      | 5.14 ± 6.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.3 ± 0.022 ms      | 0.335 ± 0.011 ms   | 3.87 ± 0.15                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0527 ± 0.022 ms   | 13 ± 2.1 μs        | 4.05 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 10.9 ± 0.89 μs      | 6.73 ± 5 μs        | 1.62 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.44 ± 0.024 ms     | 0.444 ± 0.01 ms    | 3.25 ± 0.093               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0343 ± 0.00085 ms | 12.9 ± 2.6 μs      | 2.67 ± 0.54                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.363 ± 0.037 ms    | 0.0463 ± 0.012 ms  | 7.84 ± 2.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.4 ± 1.7 ms       | 3.13 ± 0.071 ms    | 6.85 ± 0.57                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.441 ± 0.036 ms    | 0.0665 ± 0.0023 ms | 6.62 ± 0.59                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.15 ± 0.43 μs      | 0.351 ± 0.05 μs    | 11.8 ± 2.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.64 ± 1.2 μs       | 4.81 ± 0.9 μs      | 1.59 ± 0.39                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.6 ± 1.2 μs       | 1.25 ± 0.18 μs     | 9.3 ± 1.7                  |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.2 ± 8.9 μs       | 7.99 ± 5.3 μs      | 3.28 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.41 ± 0.021 ms     | 0.547 ± 0.013 ms   | 2.58 ± 0.072               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0684 ± 0.012 ms   | 14.5 ± 6.6 μs      | 4.72 ± 2.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.524 ± 0.054 ms    | 0.068 ± 0.01 ms    | 7.72 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0423 ± 0.002 s    | 13.6 ± 0.6 ms      | 3.12 ± 0.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.552 ± 0.025 ms    | 0.109 ± 0.0053 ms  | 5.06 ± 0.34                |
| Convolution body/BLAS axpy per lag                                                 | 0.71 ± 0.0065 μs    | 0.71 ± 0.0058 μs   | 1 ± 0.012                  |
| Convolution body/native axpy per lag                                               | 0.429 ± 0.0065 μs   | 0.415 ± 0.0068 μs  | 1.04 ± 0.023               |
| Convolution body/package                                                           | 0.708 ± 0.0059 μs   | 0.326 ± 0.0065 μs  | 2.17 ± 0.047               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.2 ± 1.4 μs       | 7.46 ± 0.23 μs     | 1.63 ± 0.19                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.01 ± 2.6 μs       | 2.33 ± 1.3 μs      | 1.72 ± 1.5                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.11 ± 2.4 μs       | 3.77 ± 1.7 μs      | 0.56 ± 0.67                |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0326 ± 0.00085 ms | 15.2 ± 1.1 μs      | 2.14 ± 0.16                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.39 ± 0.18 μs      | 0.14 ± 0.021 μs    | 2.79 ± 1.4                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.91 ± 1.8 μs       | 2.92 ± 0.21 μs     | 2.02 ± 0.62                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0353 ± 0.00096 ms | 24 ± 2.6 μs        | 1.47 ± 0.16                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.55 ± 0.063 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.137 ± 0.0082 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 24.9 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.066 ± 0.0018 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.672 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.29 ± 0.75 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.9 ± 0.035 ms     |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.27 ± 3.7 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0342 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0342 ± 0.011 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0415 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.74 ± 3.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.74 ± 2.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.181 ± 0.0099 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 14.6 ± 7.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 25.7 ± 3.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 20.1 ± 8.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.118 ± 0.0085 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0473 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.643 ± 0.025 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0959 ± 0.0076 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.635 ± 0.023 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 16 ± 2 ms          |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 15.9 ± 5.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 23.4 ± 7.9 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 19.8 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.047 ± 0.0013 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0318 ± 0.012 ms  |                            |
| time_to_load                                                                       | 0.189 ± 0.0007 s    | 0.245 ± 0.00074 s  | 0.773 ± 0.0037             |

|                                                                                    | v0.1.0                    | 1f5b1655e1c406...         | v0.1.0 / 1f5b1655e1c406... |
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

