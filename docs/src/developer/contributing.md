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

```text
Reference page: docs/src/explanation/operators.md.

Language
1. UK English. One sentence per line, at most 35 words; most 10-25.
2. Plain expository prose: each sentence says one thing and follows from the
   last. Join short sentences about one thing with "and", "so", "because".
   No lists of fragments.
3. Start with the content: no "This page lists/covers", "This tutorial gets",
   and no closing questions ("Want X? See Y.").
4. Say each thing once per page; a summary points back, it does not restate.
5. State what is true now: no "was timed", "used to", or issue numbers.
   Measurement conditions go in table columns or one sentence.
6. Few adjectives; none of the banned words.
7. Define a term in a sentence at its first use on a page, or link its home.
   No private words (mirror, twin, whole-step, local step) used as known.

Format
8. Headings in sentence case, no colons; # title, ## sections, ### for a
   sub-step only.
9. Tutorial: Introduction (2-3 sentences: what it models) > Packages used >
   one ## per model > Performance (one sentence: the model timed) >
   References (if cited) > Learning more.
10. Model section: motivation sentence > display maths > "where X is ...,
    Y the ... and Z the ..." (at most 3 symbols per sentence, never a run of
    "X is ...") > "Here ..." with values > code > plot > result sentences
    with numbers.
11. Lists are full sentences ending in "."; Learning more items are
    "- [Page](@ref id): what it adds."
12. Link the first mention of a public name on each page as [`Name`](@ref);
    later mentions are bare backticks.
13. Code lines <= 80 characters in pages, tutorials and docstrings.
14. Table cells <= about 15 words; long code goes below the table.
15. Extension page: "Loading A with ComposableRecurrences loads `XExt`."
    then what it adds; title = nav label + " extension".
16. Docstring: summary sentence (types: noun phrase; functions: imperative)
    > maths with a "where" sentence > arguments not obvious from the
    signature > one doctest > link to the page that teaches the concept.
    No manual signature line.

Glossary (one meaning each)
stratum/strata: series run side by side (towns, patches are examples).
kernel: weights on lags. movement matrix: strata x strata weights.
gain (gamma_t): multiplies the coupled sum (R_t for a renewal). add (a_t).
pressure: the coupled weighted sum (not "force").
value before the modifiers (v_t): "new infections before depletion" in
  infection models (not "renewal value").
pool: what a Depletion carries (not compartment, stock).
depletion form: Hazard, Floor, Truncate, Share (not "variant").
part: a draw or flow of a Depletion only.
component: a coupling, modifier or form.
rule: the package's reverse pass. plain AD: the backend differentiating the
  forward code. Spell out "automatic differentiation (AD)" once per page.
history: values before start. seed: a history built to start an outbreak.
innovations (eps_t), not "noise".

Symbols
t time from 1; l lag; L length; i, j receiving and giving stratum;
tau input (cohort) time; k_l kernel; g_l generation interval; w_l delay;
K coupling; S_t susceptible pool; N population; rho reporting share;
iota imports. S as a count of strata only in array shapes (S x T).
```

### Maths before code

A section that introduces a model, a modifier, a coupling or a transformation gives the equation first.
It names every symbol, then shows the code.
Take the equation from the docstring of the part the code uses, so the two stay the same.
A section that reuses a model defined above on the same page links to it instead.
The standards tests check the first use of each built-in operator in the tutorials listed in `test/package/standards_config.jl`.
