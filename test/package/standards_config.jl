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
const BANNED_EXTRA = ("seamless",)

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
