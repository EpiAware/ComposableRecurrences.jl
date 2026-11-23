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
Run the [use-case tests](@ref testing) with `julia --project=test test/runtests.jl usecase_only`.

## Documentation

Pages, tutorials and docstrings follow the [style sheet](@ref contributing-style).
Docstrings describe the maths and name no other package.
Tutorials are Literate scripts under `docs/src/getting-started/tutorials/`, registered in `docs/docs_config.jl`.
A heavy tutorial runs on its own with `julia --project=docs docs/run_literate_tutorial.jl <tutorial.jl> <outdir>`.
Navigation is generated into `docs/pages.jl`, which is not edited by hand.

### [Style](@id contributing-style)

The standards tests check the banned words, one sentence per line, sentence length and code line length.
The rest of the style sheet is for review.

The reference page is `docs/src/explanation/operators.md`.

#### Language

1. Write in UK English, one sentence per line, at most 35 words; most sentences have 10 to 25.
2. Write plain expository prose: each sentence says one thing and follows from the last.
   Join short sentences about one thing with "and", "so" or "because".
   Do not write lists of fragments.
3. Start with the content: no "This page lists", "This page covers" or "This tutorial gets", and no closing questions such as `Want X? See Y.`
4. Say each thing once per page; a summary points back and does not restate.
5. State what is true now: no "was timed", "used to" or issue numbers.
   Measurement conditions go in table columns or one sentence.
6. Use few adjectives, and none of the banned words.
7. Define a term in a sentence at its first use on a page, or link its home.
   Do not use private words, such as mirror, twin, whole-step or local step, as if they were known.

#### Format

8. Write headings in sentence case, with no colons: `#` for the title, `##` for sections and `###` for a sub-step only.
9. A tutorial has an introduction of two or three sentences on what it models, then Packages used, one `##` per model, Performance, References if cited, and Learning more.
   Performance is one sentence naming the model timed.
10. A model section has a motivation sentence, display maths, a "where" sentence, a "Here" sentence with values, code, a plot and result sentences with numbers.
    The "where" sentence reads "where X is ..., Y the ... and Z the ...", with at most 3 symbols per sentence and never a run of "X is ...".
11. List items are full sentences ending in a full stop.
    Learning more items read `- [Page](@ref id): what it adds.`
12. Link the first mention of a public name on each page as ``[`Name`](@ref)``; later mentions are bare backticks.
13. Code lines are at most 80 characters in pages, tutorials and docstrings.
14. Table cells hold at most about 15 words; long code goes below the table.
15. An extension page starts `Loading A with ComposableRecurrences loads XExt.` and then says what it adds.
    Its title is the nav label followed by " extension".
16. A docstring has a summary sentence, maths with a "where" sentence, the arguments not obvious from the signature, one doctest and a link to the page that teaches the concept.
    The summary of a type is a noun phrase, and that of a function is imperative.
    It has no manual signature line.

#### Glossary

Each term has one meaning.

- stratum, strata: series run side by side, such as towns or patches.
- kernel: weights on lags.
- movement matrix: strata × strata weights.
- gain (``\gamma_t``): multiplies the coupled sum, such as ``R_t`` for a renewal.
- add (``a_t``): the input added after the gain.
- pressure: the coupled weighted sum, not `force`.
- value before the modifiers (``v_t``): "new infections before depletion" in infection models, not `renewal value`.
- pool: what a `Depletion` carries, not `compartment` or `stock`.
- depletion form: `Hazard`, `Floor`, `Truncate` or `Share`, not `variant`.
- part: a draw or flow of a `Depletion` only.
- component: a coupling, modifier or form.
- rule: the package's reverse pass.
- plain AD: the backend differentiating the forward code; spell out "automatic differentiation (AD)" once per page.
- history: values before `start`.
- seed: a history built to start an outbreak.
- innovations (``\epsilon_t``): not `noise`.

#### Symbols

- ``t`` is time from 1, ``l`` a lag and ``L`` a length.
- ``i`` and ``j`` are the receiving and giving stratum, and ``\tau`` the input or cohort time.
- ``k_l`` is a kernel, ``g_l`` a generation interval and ``w_l`` a delay.
- ``K`` is a coupling, ``S_t`` the susceptible pool and ``N`` a population.
- ``\rho`` is a reporting share and ``\iota`` the imports.
- ``S`` is a count of strata only in array shapes, as in ``S \times T``.

### Maths before code

A section that introduces a model, a modifier, a coupling or a transformation gives the equation first.
It names every symbol, then shows the code.
Take the equation from the docstring of the part the code uses, so the two stay the same.
A section that reuses a model defined above on the same page links to it instead.
The standards tests check the first use of each built-in operator in the tutorials listed in `test/package/standards_config.jl`.
