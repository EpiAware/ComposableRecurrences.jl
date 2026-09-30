|                                                             | d1c7258c1b24d1...  |
|:------------------------------------------------------------|:------------------:|
| AD gradients/placeholder sum_squares/Enzyme forward         | 0.0894 ± 0.0081 μs |
| AD gradients/placeholder sum_squares/Enzyme reverse         | 22.8 ± 17 ns       |
| AD gradients/placeholder sum_squares/ForwardDiff            | 0.0323 ± 0.017 μs  |
| AD gradients/placeholder sum_squares/Mooncake forward       | 0.182 ± 0.016 μs   |
| AD gradients/placeholder sum_squares/Mooncake reverse       | 0.0431 ± 0.023 μs  |
| AD gradients/placeholder sum_squares/ReverseDiff (compiled) | 0.0793 ± 0.021 μs  |
| AD gradients/placeholder sum_squares/ReverseDiff (tape)     | 0.51 ± 0.11 μs     |
| time_to_load                                                | 21.8 ± 1.1 ms      |

|                                                             | d1c7258c1b24d1...       |
|:------------------------------------------------------------|:-----------------------:|
| AD gradients/placeholder sum_squares/Enzyme forward         | 3  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/Enzyme reverse         | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ForwardDiff            | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/Mooncake forward       | 16  allocs: 0.469 kB    |
| AD gradients/placeholder sum_squares/Mooncake reverse       | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ReverseDiff (compiled) | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ReverseDiff (tape)     | 16  allocs: 0.578 kB    |
| time_to_load                                                | 0.196 k allocs: 11.6 kB |

