# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# QA configuration values the managed `quality.jl` testset reads. Fill in the
# package-specific inputs the shared helpers need; the standard testset logic
# stays in `quality.jl` (managed). Edit freely.

using ComposableRecurrences

const QA_CONFIG = (
    # The module under test.
    mod = ComposableRecurrences,

    # Path to the isolated JET environment (see test/jet/Project.toml).
    jet_env = joinpath(@__DIR__, "..", "jet"),

    # Path to the isolated formatter environment (see
    # test/formatter/Project.toml). Runs the formatting check in a subprocess
    # pinned to the exact Runic version, rather than whatever version the
    # shared test environment resolves on the CI Julia in use (#321).
    formatter_env = joinpath(@__DIR__, "..", "formatter"),

    # Per-check Aqua relaxations, e.g. (; ambiguities = false). Empty = all on.
    aqua = (;),

    # ExplicitImports `ignore`: symbols the main module legitimately imports
    # non-publicly. Tuple of Symbols, e.g. (:_internal_helper,). Package
    # extensions are handled automatically (#189), so their import lists do not
    # need listing here.
    ei_ignore = (),

    # Docstring `crossref_ignore`: upstream names docstrings link to via
    # `[`name`](@ref)`, e.g. (:pdf, :cdf, :logpdf).
    # Docstrings link to public, unexported names in qualified form, which
    # Documenter resolves but the check matches only as bare names.
    crossref_ignore = Tuple(
        Symbol(:ComposableRecurrences, '.', name)
            for name in names(ComposableRecurrences)
    ),

    # Extra docstring-format options, e.g.
    # (; exported_only_examples = true, require_field_docs = true).
    # Docstring examples are doctests, so that they run and the API page
    # shows their output; this check matches only `@example`.
    # "Standards: docstring examples" requires an example on every public
    # name and accepts doctests.
    docstring = (; require_examples = false),

    # README section-structure check. `path` is the package root (its
    # README.md). Override `required`/`order` to extend or relax the standard
    # section set, e.g.
    #   (; required = vcat(STANDARD_README_SECTIONS, [("Benchmarks",)]))
    # Empty `(;)` uses the standard structure in standard order.
    readme = (; path = joinpath(@__DIR__, "..", "..")),

    # Package extensions to ambiguity-check. Each entry:
    #   (; name = :MyPkgSomeTriggerExt,
    #      triggers = ("SomeTrigger",),       # packages to load first
    #      prefixes = ("MyPkg", "SomeTrigger"),
    #      expect_phantoms = false,    # true if a third party adds phantoms
    #      broken = false)             # true to quarantine a known ambiguity
    extensions = (
        (;
            name = :ComposableRecurrencesConstructionBaseExt,
            triggers = ("ConstructionBase",),
            prefixes = ("ComposableRecurrences",),
        ),
        (;
            name = :ComposableRecurrencesMooncakeExt,
            triggers = ("ADTypes", "Mooncake", "Random"),
            prefixes = ("ComposableRecurrences",),
        ),
        (;
            name = :ComposableRecurrencesEnzymeExt, triggers = ("Enzyme",),
            prefixes = ("ComposableRecurrences",),
        ),
        (;
            name = :ComposableRecurrencesEnzymeTestUtilsExt,
            triggers = ("ADTypes", "Enzyme", "EnzymeTestUtils"),
            prefixes = ("ComposableRecurrences",),
        ),
    ),
)
