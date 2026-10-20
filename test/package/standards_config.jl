# PACKAGE-OWNED: the inputs of the documentation standards checks in
# `standards.jl`. Each list is kept as short as the check allows.

const STANDARDS_ROOT = normpath(joinpath(@__DIR__, "..", ".."))

# Public names whose docstring needs no ```math block, because the maths
# lives in the docstring of the type that uses them.
const MATHS_ALLOW = (
    # Roles are singleton tags; each operator or modifier docstring states
    # what it computes in that role.
    :Run, :Step, :Init, :Pressure,
)

# Public names still missing a ```math block or a runnable example, marked
# broken until they gain one. A name that passes is reported as an
# unexpected pass: remove it from the list.
const PENDING_MATHS = ()
const PENDING_EXAMPLES = ()
# Labels of sources whose prose still uses a banned word, marked broken.
const PENDING_WORDING = ()

# Words that read as filler in docs, docstrings and comments: the shared
# `BANNED_README_WORDS` from EpiAwarePackageTools, minus the entries this
# package uses as plain terms, plus local additions. Each entry is matched
# by stem, case-insensitively, at a word boundary. The word "piece" is
# checked separately, so that "piecewise" passes.
const BANNED_SHARED_SKIP = ()
const BANNED_EXTRA = ("seamless", "stock")

# Package names that docstrings and src comments must not use: sibling
# packages and automatic differentiation backends. Matched case-sensitively.
# Tests and the docs tutorials may name them.
const OTHER_PACKAGES = (
    "EpiAware", "EpiAwareADTools", "EpiAwarePackageTools", "EpiNow2",
    "EpiBranch", "ComposableTuringIDModels", "CTIDM",
    "ConvolvedDistributions", "CensoredDistributions",
    "PrimaryCensored", "BVD", "BVDOutbreakSize", "Turing", "DynamicPPL",
    "ForwardDiff", "ReverseDiff", "Mooncake", "Enzyme", "Zygote",
    "ChainRules", "ChainRulesCore", "DifferentiationInterface", "Reactant",
)

# Files the package-name check skips: scaffold-managed headers that name
# the tooling they configure.
const PACKAGE_NAME_SKIP = ("src/docstrings.jl",)

# Pages whose sections give the maths before the code, relative to the
# package root: a section whose code uses one of `MATHS_FIRST_CALLS`
# introduces a model, and has a ```math block before that code. Markdown
# pages are read from their ```julia and ```@example blocks. The threads
# tutorial is a draft outside the build and is not listed.
const MATHS_FIRST_PAGES = (
    "README.md",
    "docs/src/getting-started/index.md",
    "docs/src/developer/extending.md",
    "docs/src/getting-started/tutorials/backend-case-study.jl",
    "docs/src/getting-started/tutorials/latent-processes.jl",
    "docs/src/getting-started/tutorials/occupancy.jl",
    "docs/src/getting-started/tutorials/renewal-then-delay.jl",
    "docs/src/getting-started/tutorials/spatial-strata.jl",
    "docs/src/getting-started/tutorials/time-varying-delays.jl",
    "docs/src/getting-started/tutorials/transform.jl",
)
const MATHS_FIRST_CALLS = (
    "Recurrence", "Convolution", "Depletion", "Redistribute", "Add", "Clamp",
    "Allocate", "Transform", "Routes", "Pairwise", "Pool",
)
# Sections that only reuse a model introduced earlier on the page, as
# `page => heading`, so need no equation of their own.
const MATHS_FIRST_REUSE = (
    # Runs the smoothing modifier through the operator to check its rule.
    "docs/src/developer/extending.md" => "Checking a new type",
)
# Sections still giving prose before their code, as `page => heading`,
# marked broken until they gain a ```math block.
const PENDING_MATHS_FIRST = ()

# Concepts with one home: `anchor => (page, phrases)`. The page holds the
# anchor and every phrase, and no other README, docs page or tutorial uses
# a phrase. Other pages link to the anchor rather than explain it again.
const ONE_HOME = (
    "explanation-lag-origin" => (
        "docs/src/explanation/operators.md",
        ("cannot depend on itself in the same step",),
    ),
    "adjoint-routing" => (
        "docs/src/explanation/adjoints-and-backends.md",
        ("local ForwardDiff step", "ConstructionBase.constructorof"),
    ),
    "adjoint-backends" => (
        "docs/src/explanation/adjoints-and-backends.md",
        ("which is not a target",),
    ),
    "extension-reactant" => (
        "docs/src/extensions/reactant.md",
        ("Reactant.@compile", "Reactant.to_rarray"),
    ),
    "tutorial-imports" => (
        "docs/src/getting-started/tutorials/renewal-then-delay.jl",
        ("drawn from the pool like local cases",),
    ),
    "explanation-seeding" => (
        "docs/src/explanation/operators.md",
        ("The two placements give the same run",),
    ),
    "extending" => (
        "docs/src/developer/extending.md",
        ("selects the role by dispatch",),
    ),
)

# Markdown sources for the prose checks: the README and every page and
# Literate tutorial under docs/src.
function standards_prose_files()
    files = [joinpath(STANDARDS_ROOT, "README.md")]
    for (dir, _, names) in walkdir(joinpath(STANDARDS_ROOT, "docs", "src"))
        occursin("node_modules", dir) && continue
        for name in names
            endswith(name, ".md") || endswith(name, ".jl") || continue
            push!(files, joinpath(dir, name))
        end
    end
    return sort!(files)
end
