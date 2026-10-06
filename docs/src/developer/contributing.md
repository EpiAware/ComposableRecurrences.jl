# [Contributing](@id contributing)

Contributions are welcome as issues and pull requests on [GitHub](https://github.com/EpiAware/ComposableRecurrences.jl).
The package follows [ColPrac](https://github.com/SciML/ColPrac) and is formatted with [Runic](https://github.com/fredrikekre/Runic.jl).

## Workflow

1. Open or find an issue that describes the change.
2. Work on a branch, never on `main`.
3. Write a failing test first, commit it, then make it pass and commit again.
4. Run the checks below before opening a pull request.

## Checks

Common tasks run through the [Taskfile](https://taskfile.dev).

| Task | What it runs |
|---|---|
| `task test-fast` | the unit and use-case tests, without the quality gates |
| `task test-quality` | Aqua, formatting, linting and doctests |
| `task test-ad` | gradient tests on every AD backend |
| `task format` | Runic over the source, tests and docs |
| `task docs-fast` | the documentation, with heavy tutorials stubbed |
| `task precommit` | the pre-commit hooks |

On a shared machine, run one Julia process at a time.

## Use-case tests

A new operator, modifier or coupling adds a use case when it replaces code in a modelling package.
[Testing and benchmarking](@ref testing) describes the use-case tests and how to run them.

## Documentation

Pages follow the org's writing style: UK English, one sentence per line, short sentences.
Docstrings describe the maths and name no other package.
Tutorials are Literate scripts under `docs/src/getting-started/tutorials/`, registered in `docs/docs_config.jl`.
Navigation is generated into `docs/pages.jl`, which is not edited by hand.
