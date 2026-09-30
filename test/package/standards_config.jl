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
# broken until `docs/docstring-maths` (standards-review) adds them. A name
# that passes is reported as an unexpected pass: remove it from the list.
const PENDING_MATHS = (
    :Add, :Clamp, :ComposableRecurrences, :Convolution, :Depletion, :Floor,
    :Hazard, :NoAdjoint, :Pairwise, :PerStratum, :PieceInterface, :Primary,
    :Recurrence, :Redistribute, :Secondary, :State, :TimeVarying, :forward,
    :ispointwise, :param_eltype, :pullback!, :seeded, :with_state,
)
const PENDING_EXAMPLES = (:PieceInterface,)
# Docstrings whose prose still uses the word "piece", fixed on the same
# branch.
const PENDING_WORDING = ("docstring PieceInterface", "docstring pullback!")

# Words that read as filler in docs, docstrings and comments. Each entry is a
# regular expression matched case-insensitively on word boundaries.
const BANNED_WORDS = (
    "comprehensive", "leverag\\w*", "facilitat\\w*", "robust\\w*",
    "novel", "seamless\\w*", "utili[sz]\\w*", "streamlin\\w*", "pivotal",
    "nuanced", "multifaceted", "cornerstone\\w*", "synerg\\w*",
    "overarching", "landscapes?", "harness\\w*", "foster\\w*",
)

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
