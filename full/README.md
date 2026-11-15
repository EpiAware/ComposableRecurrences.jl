# Full benchmark grid

Commit 40bf737d2360611c7f61dcb1fccdb8b12fe1aecc, run on 2026-11-15.
Load `latest.json` with `BenchmarkTools.load("latest.json")[1]`.

```
primal: 45 entries
ForwardDiff: 234 entries
Enzyme forward: 0 entries
Enzyme reverse: 0 entries
Mooncake reverse: 234 entries
Mooncake forward: 234 entries
::warning::no full benchmark results for Enzyme forward
::warning::no full benchmark results for Enzyme reverse
Wrote public/latest.json with groups AD gradients, Convolution body, Convolution methods, Evaluation
```
