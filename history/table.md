|                                                                                    | v0.1.0              | 9c64bd3d6e2815...  | v0.1.0 / 9c64bd3d6e2815... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0967 ± 0.016 ms   | 31.2 ± 9 μs        | 3.1 ± 1                    |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.66 ± 0.028 ms     | 0.847 ± 0.023 ms   | 3.14 ± 0.091               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.145 ± 0.017 ms    | 0.043 ± 0.012 ms   | 3.38 ± 0.99                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.5 ± 7.1 μs       | 3.4 ± 4.5 μs       | 5.16 ± 7.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.386 ± 0.025 ms    | 0.272 ± 0.018 ms   | 1.42 ± 0.13                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0611 ± 0.022 ms   | 14.3 ± 2.1 μs      | 4.27 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 12.4 ± 1.9 μs       | 7.51 ± 5.6 μs      | 1.65 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.417 ± 0.13 ms     | 0.338 ± 0.013 ms   | 1.23 ± 0.39                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.041 ± 0.00093 ms  | 14.3 ± 3 μs        | 2.86 ± 0.59                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.536 ± 0.066 ms    | 0.0589 ± 0.012 ms  | 9.1 ± 2.2                  |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.4 ± 1.3 ms       | 3.31 ± 0.1 ms      | 3.44 ± 0.42                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.567 ± 0.037 ms    | 0.0836 ± 0.0025 ms | 6.78 ± 0.49                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.53 ± 0.39 μs      | 0.45 ± 0.06 μs     | 12.3 ± 1.9                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.39 ± 1.1 μs       | 3.41 ± 0.79 μs     | 1.88 ± 0.54                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 14.2 ± 0.94 μs      | 1.56 ± 0.16 μs     | 9.08 ± 1.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0321 ± 0.01 ms    | 14.3 ± 6.9 μs      | 2.25 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.01 ± 0.023 ms     | 0.371 ± 0.018 ms   | 5.43 ± 0.27                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0849 ± 0.0094 ms  | 21.8 ± 7.3 μs      | 3.9 ± 1.4                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.674 ± 0.054 ms    | 0.0847 ± 0.022 ms  | 7.95 ± 2.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0554 ± 0.0021 s   | 12.4 ± 0.33 ms     | 4.45 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.73 ± 0.036 ms     | 0.136 ± 0.0094 ms  | 5.38 ± 0.46                |
| Convolution body/BLAS axpy per lag                                                 | 0.78 ± 0.0046 μs    | 0.788 ± 0.0031 μs  | 0.989 ± 0.007              |
| Convolution body/native axpy per lag                                               | 0.496 ± 0.0057 μs   | 0.521 ± 0.0051 μs  | 0.953 ± 0.014              |
| Convolution body/package                                                           | 0.78 ± 0.004 μs     | 0.359 ± 0.0063 μs  | 2.17 ± 0.04                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.5 ± 3.4 μs       | 8.98 ± 1.6 μs      | 1.61 ± 0.48                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.7 ± 2.9 μs        | 2.4 ± 1.4 μs       | 0.709 ± 1.3                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.32 ± 1.6 μs       | 3.95 ± 1.7 μs      | 1.09 ± 0.62                |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0397 ± 0.00094 ms | 19.3 ± 0.88 μs     | 2.06 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.541 ± 0.23 μs     | 0.161 ± 0.021 μs   | 3.36 ± 1.5                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.66 ± 1.9 μs       | 3.71 ± 0.27 μs     | 2.07 ± 0.52                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0474 ± 0.0012 ms  | 31.3 ± 1.4 μs      | 1.51 ± 0.077               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.67 ± 0.086 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.172 ± 0.0098 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.8 ± 3.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0856 ± 0.002 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.622 ± 0.027 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.62 ± 4.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.628 ± 0.034 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.82 ± 4.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.046 ± 0.0028 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0398 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0504 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.47 ± 4.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 6.04 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.228 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.5 ± 7.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 29.1 ± 3.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 23.5 ± 8.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.156 ± 0.011 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0598 ± 0.0015 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.551 ± 0.053 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.122 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.534 ± 0.05 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.5 ± 1.9 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 18 ± 7.9 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 27.7 ± 7.4 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.5 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0507 ± 0.0022 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.037 ± 0.014 ms   |                            |
| time_to_load                                                                       | 0.243 ± 0.0025 s    | 0.316 ± 0.0017 s   | 0.769 ± 0.009              |

|                                                                                    | v0.1.0                    | 9c64bd3d6e2815...         | v0.1.0 / 9c64bd3d6e2815... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.055 k allocs: 28.7 kB   | 1.3                        |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.059 k allocs: 0.0327 MB | 2.51                       |
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
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 0.033 k allocs: 20.4 kB   | 1.31                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.036 k allocs: 20.1 kB   | 3.41                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.085 k allocs: 0.134 MB  | 1.99                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.135 k allocs: 0.12 MB   | 2.91                       |
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
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.16 k allocs: 0.13 MB    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.28 k allocs: 0.0632 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.126 k allocs: 0.0377 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.136 k allocs: 0.0637 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.303 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.115 k allocs: 31.1 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.156 k allocs: 0.288 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.121 k allocs: 0.135 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.115 k allocs: 30 kB     |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.126 k allocs: 0.0394 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

