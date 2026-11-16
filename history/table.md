|                                                                                    | v0.1.0            | cf7768350d99c6...  | v0.1.0 / cf7768350d99c6... |
|:-----------------------------------------------------------------------------------|:-----------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0566 ± 0.01 ms  | 17.9 ± 5.6 μs      | 3.16 ± 1.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.48 ± 0.054 ms   | 0.59 ± 0.023 ms    | 2.52 ± 0.13                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0869 ± 0.019 ms | 25.1 ± 6.5 μs      | 3.46 ± 1.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 12.1 ± 5.2 μs     | 2.58 ± 2.6 μs      | 4.68 ± 5.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.846 ± 0.041 ms  | 0.237 ± 0.022 ms   | 3.56 ± 0.37                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.04 ± 0.016 ms   | 9.84 ± 1.8 μs      | 4.07 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 9.76 ± 1.1 μs     | 5.12 ± 3.3 μs      | 1.91 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.999 ± 0.042 ms  | 0.27 ± 0.018 ms    | 3.7 ± 0.29                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 26.1 ± 3.6 μs     | 9.03 ± 1.9 μs      | 2.89 ± 0.72                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.265 ± 0.034 ms  | 31.6 ± 16 μs       | 8.38 ± 4.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 15.8 ± 2.9 ms     | 1.98 ± 1.2 ms      | 7.97 ± 5.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.342 ± 0.03 ms   | 0.0444 ± 0.0021 ms | 7.7 ± 0.77                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 2.87 ± 0.43 μs    | 0.241 ± 0.03 μs    | 11.9 ± 2.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.08 ± 4.3 μs     | 3.58 ± 0.66 μs     | 1.98 ± 1.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.48 ± 1.2 μs     | 0.871 ± 0.059 μs   | 9.74 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 30.1 ± 7.3 μs     | 6.67 ± 1.2 μs      | 4.51 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.14 ± 0.03 ms    | 0.341 ± 0.35 ms    | 3.34 ± 3.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0535 ± 0.015 ms | 11.4 ± 0.95 μs     | 4.67 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.427 ± 0.1 ms    | 0.0477 ± 0.014 ms  | 8.96 ± 3.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0347 ± 0.0034 s | 9.39 ± 0.68 ms     | 3.69 ± 0.45                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.428 ± 0.037 ms  | 0.0784 ± 0.005 ms  | 5.46 ± 0.58                |
| Convolution body/BLAS axpy per lag                                                 | 0.398 ± 0.014 μs  | 0.397 ± 0.0081 μs  | 1 ± 0.04                   |
| Convolution body/native axpy per lag                                               | 0.289 ± 0.0085 μs | 0.287 ± 0.0074 μs  | 1.01 ± 0.04                |
| Convolution body/package                                                           | 0.4 ± 0.0069 μs   | 0.173 ± 0.0025 μs  | 2.32 ± 0.052               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.5 ± 2.2 μs     | 5.81 ± 0.32 μs     | 1.8 ± 0.4                  |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.51 ± 1.8 μs     | 1.6 ± 1 μs         | 0.944 ± 1.3                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 3.03 ± 1.3 μs     | 2.64 ± 1.2 μs      | 1.15 ± 0.69                |
| Evaluation/Matrix overview T200_L20_S3                                             | 21 ± 1.7 μs       | 12.3 ± 0.55 μs     | 1.71 ± 0.16                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.301 ± 0.23 μs   | 0.12 ± 0.17 μs     | 2.51 ± 4                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.43 ± 1.7 μs     | 2.15 ± 0.3 μs      | 1.59 ± 0.81                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 25 ± 1.3 μs       | 17.3 ± 1.7 μs      | 1.45 ± 0.16                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                   | 1.08 ± 0.083 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                   | 0.097 ± 0.006 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                   | 18.5 ± 3.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                   | 0.0482 ± 0.0029 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                   | 0.48 ± 0.05 ms     |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                   | 3.92 ± 0.59 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                   | 0.577 ± 0.046 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                   | 3.1 ± 2.5 μs       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                   | 25.6 ± 1.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                   | 24.8 ± 5.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                   | 28.6 ± 1.4 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                   | 3.59 ± 2.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                   | 5.89 ± 2 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                   | 0.131 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                   | 11.7 ± 4.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                   | 19 ± 3 μs          |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                   | 16 ± 5.2 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                   | 0.0838 ± 0.0053 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                   | 0.0322 ± 0.0013 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                   | 0.477 ± 0.028 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                   | 0.0677 ± 0.0053 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                   | 0.467 ± 0.031 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                   | 10.6 ± 0.56 ms     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                   | 11.8 ± 5.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                   | 16.4 ± 5.9 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                   | 13.4 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                   | 31.4 ± 3.3 ms      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                   | 23.8 ± 7.9 μs      |                            |
| time_to_load                                                                       | 0.16 ± 0.0014 s   | 0.156 ± 0.004 s    | 1.03 ± 0.028               |

|                                                                                    | v0.1.0                    | cf7768350d99c6...         | v0.1.0 / cf7768350d99c6... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 13.9 kB       | 1.85                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.039 k allocs: 18.6 kB   | 3.42                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.08 k allocs: 0.073 MB   | 3.22                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.083 k allocs: 0.0696 MB | 5.07                       |
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
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
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

