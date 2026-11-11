|                                                                                    | v0.1.0             | fed49953b2ac91...  | v0.1.0 / fed49953b2ac91... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0583 ± 0.0098 ms | 18.8 ± 2.2 μs      | 3.1 ± 0.64                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.44 ± 0.026 ms    | 0.604 ± 0.017 ms   | 2.38 ± 0.078               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0977 ± 0.012 ms  | 25.8 ± 2.5 μs      | 3.79 ± 0.59                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 12.6 ± 5.2 μs      | 5.54 ± 3.9 μs      | 2.28 ± 1.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.838 ± 0.028 ms   | 0.241 ± 0.017 ms   | 3.48 ± 0.27                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0391 ± 0.017 ms  | 11.1 ± 2.1 μs      | 3.52 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 8.98 ± 1.3 μs      | 3.1 ± 3.4 μs       | 2.89 ± 3.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.942 ± 0.035 ms   | 0.283 ± 0.012 ms   | 3.33 ± 0.19                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 25.7 ± 1.3 μs      | 9.29 ± 2.1 μs      | 2.77 ± 0.63                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.251 ± 0.012 ms   | 0.0342 ± 0.0013 ms | 7.36 ± 0.45                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14.5 ± 1.7 ms      | 2 ± 0.06 ms        | 7.24 ± 0.86                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.325 ± 0.03 ms    | 0.0475 ± 0.0015 ms | 6.85 ± 0.67                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 2.85 ± 0.44 μs     | 0.25 ± 0.029 μs    | 11.4 ± 2.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.47 ± 4.7 μs      | 3.39 ± 0.61 μs     | 1.91 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 9.01 ± 0.99 μs     | 0.922 ± 0.14 μs    | 9.78 ± 1.8                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 28.7 ± 6.7 μs      | 8.58 ± 4.6 μs      | 3.34 ± 2                   |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.07 ± 0.036 ms    | 0.331 ± 0.014 ms   | 3.22 ± 0.18                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0496 ± 0.011 ms  | 14 ± 4.8 μs        | 3.53 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.402 ± 0.027 ms   | 0.0485 ± 0.029 ms  | 8.29 ± 5                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 31.3 ± 1.8 ms      | 10.3 ± 0.56 ms     | 3.02 ± 0.24                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.426 ± 0.028 ms   | 0.08 ± 0.0031 ms   | 5.33 ± 0.41                |
| Convolution body/BLAS axpy per lag                                                 | 0.451 ± 0.0023 μs  | 0.458 ± 0.0071 μs  | 0.985 ± 0.016              |
| Convolution body/native axpy per lag                                               | 0.4 ± 0.006 μs     | 0.359 ± 0.011 μs   | 1.11 ± 0.037               |
| Convolution body/package                                                           | 0.458 ± 0.0067 μs  | 0.192 ± 0.0016 μs  | 2.38 ± 0.04                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.89 ± 1.6 μs      | 5.85 ± 0.68 μs     | 1.69 ± 0.34                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3 ± 0.26 μs        | 2.83 ± 0.17 μs     | 1.06 ± 0.11                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.23 ± 1.2 μs      | 2.62 ± 1.2 μs      | 0.851 ± 0.59               |
| Evaluation/Matrix overview T200_L20_S3                                             | 20.7 ± 0.77 μs     | 13.8 ± 0.58 μs     | 1.5 ± 0.084                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.281 ± 0.08 μs    | 0.12 ± 0.06 μs     | 2.34 ± 1.3                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.2 ± 2.1 μs       | 2.02 ± 0.22 μs     | 1.58 ± 1                   |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 24.5 ± 0.69 μs     | 16.5 ± 0.65 μs     | 1.49 ± 0.072               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.09 ± 0.053 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.0993 ± 0.0043 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 18 ± 2.8 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0457 ± 0.0018 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.538 ± 0.042 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.56 ± 3 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.578 ± 0.052 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.08 ± 2.6 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 25.4 ± 1.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 26.1 ± 6 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 29.2 ± 1.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.56 ± 2.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.05 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.131 ± 0.0054 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.7 ± 4.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.6 ± 2.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.4 ± 6.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0884 ± 0.056 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0324 ± 0.0011 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.509 ± 0.022 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0688 ± 0.0036 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.492 ± 0.022 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.5 ± 2.6 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 12.5 ± 5.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 17.8 ± 5.3 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 13.7 ± 3.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0403 ± 0.0028 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 23.8 ± 6.5 μs      |                            |
| time_to_load                                                                       | 0.147 ± 0.0028 s   | 0.159 ± 0.004 s    | 0.925 ± 0.029              |

|                                                                                    | v0.1.0                    | fed49953b2ac91...         | v0.1.0 / fed49953b2ac91... |
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

