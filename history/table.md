|                                                                                    | v0.1.0             | c02c0538c28fe2...  | v0.1.0 / c02c0538c28fe2... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0859 ± 0.01 ms   | 27.5 ± 2.6 μs      | 3.13 ± 0.47                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.64 ± 0.061 ms    | 0.929 ± 0.05 ms    | 2.84 ± 0.17                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.127 ± 0.013 ms   | 0.0351 ± 0.0077 ms | 3.61 ± 0.87                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.7 ± 5.4 μs      | 5.88 ± 3.8 μs      | 2.83 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 4.43 ± 0.079 ms    | 0.496 ± 0.016 ms   | 8.92 ± 0.33                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0488 ± 0.017 ms  | 12.6 ± 1.8 μs      | 3.88 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 16.9 ± 1.9 μs      | 4.34 ± 4.2 μs      | 3.9 ± 3.8                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 5.05 ± 0.066 ms    | 0.538 ± 0.015 ms   | 9.37 ± 0.29                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0398 ± 0.0016 ms | 12.5 ± 2 μs        | 3.18 ± 0.52                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.574 ± 0.055 ms   | 0.0591 ± 0.0048 ms | 9.72 ± 1.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 0.0425 ± 0.0041 s  | 4.24 ± 0.13 ms     | 10 ± 1                     |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.553 ± 0.034 ms   | 0.0792 ± 0.0028 ms | 6.99 ± 0.49                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.61 ± 0.6 μs      | 0.587 ± 0.16 μs    | 9.55 ± 2.7                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 10.5 ± 4.8 μs      | 7.07 ± 0.58 μs     | 1.48 ± 0.69                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.4 ± 0.77 μs     | 1.58 ± 0.31 μs     | 8.52 ± 1.8                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0357 ± 0.0046 ms | 9.94 ± 4.1 μs      | 3.6 ± 1.6                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.04 ± 0.039 ms    | 0.556 ± 0.027 ms   | 3.67 ± 0.19                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0773 ± 0.0058 ms | 16 ± 5.1 μs        | 4.83 ± 1.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.766 ± 0.026 ms   | 0.0956 ± 0.0094 ms | 8.01 ± 0.83                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0598 ± 0.0029 s  | 18.9 ± 0.53 ms     | 3.16 ± 0.18                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.679 ± 0.036 ms   | 0.13 ± 0.0065 ms   | 5.23 ± 0.38                |
| Convolution body/BLAS axpy per lag                                                 | 0.825 ± 0.0016 μs  | 1.11 ± 0.00094 μs  | 0.742 ± 0.0016             |
| Convolution body/native axpy per lag                                               | 0.513 ± 0.0016 μs  | 0.495 ± 0.0083 μs  | 1.04 ± 0.018               |
| Convolution body/package                                                           | 0.825 ± 0.0018 μs  | 0.373 ± 0.0011 μs  | 2.21 ± 0.0081              |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.7 ± 0.77 μs     | 9.35 ± 1.3 μs      | 1.46 ± 0.22                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.81 ± 0.37 μs     | 1.97 ± 1 μs        | 1.94 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.73 ± 1.9 μs      | 2.29 ± 1.6 μs      | 1.19 ± 1.2                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0371 ± 0.0015 ms | 20.4 ± 0.82 μs     | 1.82 ± 0.1                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.881 ± 0.28 μs    | 0.179 ± 0.014 μs   | 4.92 ± 1.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.3 ± 2.1 μs       | 3.6 ± 0.24 μs      | 1.75 ± 0.59                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0476 ± 0.0023 ms | 0.0328 ± 0.0019 ms | 1.45 ± 0.11                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 2.08 ± 0.2 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.153 ± 0.009 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 23.4 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0763 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.961 ± 0.071 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 7.32 ± 3.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.986 ± 0.082 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.02 ± 2.9 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0454 ± 0.0023 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0328 ± 0.0087 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0523 ± 0.0026 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.63 ± 3 μs        |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.27 ± 3.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.219 ± 0.018 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 14.4 ± 5.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 24.6 ± 2.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 21.7 ± 5.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.16 ± 0.012 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0634 ± 0.0045 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 1.01 ± 0.052 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.123 ± 0.0082 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 1.01 ± 0.049 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 20.4 ± 2.9 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.1 ± 5.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 24.3 ± 6.1 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 22.1 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0634 ± 0.0022 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 29.9 ± 8.9 μs      |                            |
| time_to_load                                                                       | 0.227 ± 0.0011 s   | 0.295 ± 0.003 s    | 0.77 ± 0.0087              |

|                                                                                    | v0.1.0                    | c02c0538c28fe2...         | v0.1.0 / c02c0538c28fe2... |
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

