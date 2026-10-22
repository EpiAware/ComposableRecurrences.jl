# [Developer FAQ](@id developer-faq)

## My changes do not show up

Load [Revise](https://github.com/timholy/Revise.jl) before the package, so edits reload without restarting Julia.

## How do I run a subset of the tests?

The test entry point takes `skip_quality`, `quality_only`, `readme_only` and `usecase_only`.

```bash
julia --project=test test/runtests.jl skip_quality
```

For finer control, filter test items by name or tag with TestItemRunner.

```julia
using TestItemRunner
run_tests("test"; filter = ti -> occursin("Depletion", ti.name))
```
