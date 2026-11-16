|                                                                                    | v0.1.0              | de830b7ec99228...  | v0.1.0 / de830b7ec99228... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0926 ± 0.017 ms   | 0.033 ± 0.01 ms    | 2.81 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 3.95 ± 0.028 ms     | 0.804 ± 0.028 ms   | 4.91 ± 0.18                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.159 ± 0.019 ms    | 0.0484 ± 0.012 ms  | 3.28 ± 0.93                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 20.3 ± 9.3 μs       | 4.23 ± 5 μs        | 4.81 ± 6.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.408 ± 0.027 ms    | 0.289 ± 0.014 ms   | 1.41 ± 0.11                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0678 ± 0.019 ms   | 17.1 ± 2.8 μs      | 3.96 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 14.1 ± 8.5 μs       | 4.54 ± 6.3 μs      | 3.1 ± 4.7                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.43 ± 0.029 ms     | 0.355 ± 0.012 ms   | 1.21 ± 0.092               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0653 ± 0.027 ms   | 16.1 ± 3.4 μs      | 4.06 ± 1.9                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.494 ± 0.085 ms    | 0.0575 ± 0.031 ms  | 8.6 ± 4.8                  |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 12.7 ± 2.1 ms       | 3.72 ± 0.15 ms     | 3.42 ± 0.58                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.59 ± 0.04 ms      | 0.084 ± 0.0027 ms  | 7.02 ± 0.53                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.67 ± 2.3 μs       | 0.451 ± 0.05 μs    | 10.3 ± 5.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.23 ± 0.87 μs      | 4.02 ± 0.61 μs     | 1.8 ± 0.35                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 14.7 ± 1.1 μs       | 1.63 ± 0.21 μs     | 8.97 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0451 ± 0.012 ms   | 15.2 ± 7.8 μs      | 2.97 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.26 ± 0.043 ms     | 0.4 ± 0.015 ms     | 5.65 ± 0.24                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.095 ± 0.019 ms    | 20.7 ± 8.9 μs      | 4.58 ± 2.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.65 ± 0.18 ms      | 0.0835 ± 0.047 ms  | 7.78 ± 4.9                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0637 ± 0.0049 s   | 13.4 ± 0.32 ms     | 4.76 ± 0.39                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.738 ± 0.025 ms    | 0.147 ± 0.011 ms   | 5.02 ± 0.4                 |
| Convolution body/BLAS axpy per lag                                                 | 0.789 ± 0.0069 μs   | 0.844 ± 0.0087 μs  | 0.935 ± 0.013              |
| Convolution body/native axpy per lag                                               | 0.507 ± 0.012 μs    | 0.506 ± 0.01 μs    | 1 ± 0.031                  |
| Convolution body/package                                                           | 0.789 ± 0.0067 μs   | 0.374 ± 0.0096 μs  | 2.11 ± 0.057               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 15.2 ± 3.7 μs       | 9.76 ± 3.6 μs      | 1.56 ± 0.68                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 5.23 ± 0.32 μs      | 2.69 ± 1.8 μs      | 1.94 ± 1.3                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.73 ± 1.9 μs       | 3.04 ± 3.3 μs      | 1.55 ± 1.8                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0425 ± 0.00099 ms | 19.7 ± 1.1 μs      | 2.16 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.521 ± 0.26 μs     | 0.21 ± 0.13 μs     | 2.48 ± 2                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 8.97 ± 2 μs         | 3.48 ± 0.26 μs     | 2.57 ± 0.62                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0476 ± 0.00095 ms | 31.2 ± 2.4 μs      | 1.53 ± 0.12                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.79 ± 0.094 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.183 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 31.5 ± 4.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0824 ± 0.0021 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.692 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.82 ± 5.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.698 ± 0.034 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 5.68 ± 4.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0469 ± 0.013 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0436 ± 0.014 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.052 ± 0.0014 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 6.37 ± 4.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 6.18 ± 5.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.24 ± 0.014 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 17.7 ± 9.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 0.0323 ± 0.0044 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 24.4 ± 9.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.152 ± 0.011 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0587 ± 0.002 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.598 ± 0.039 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.122 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.581 ± 0.039 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 16.7 ± 1.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 18.8 ± 8.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 28 ± 11 μs         |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.4 ± 5.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0532 ± 0.0013 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0419 ± 0.015 ms  |                            |
| time_to_load                                                                       | 0.246 ± 0.00057 s   | 0.256 ± 0.00045 s  | 0.958 ± 0.0028             |

|                                                                                    | v0.1.0                    | de830b7ec99228...         | v0.1.0 / de830b7ec99228... |
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

