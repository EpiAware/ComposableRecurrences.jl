# Reference implementations shared by the use-case test items. Each item
# builds a real model through the package API and checks its values and
# ForwardDiff gradients against the original code in `references/`.
#
# Run only these items with `Pkg.test(test_args = ["usecase_only"])`; the
# default run skips items tagged `:usecase_pending`.

@testmodule UseCaseReferences begin
    include(joinpath(@__DIR__, "references", "ctidm.jl"))
    include(joinpath(@__DIR__, "references", "bvd.jl"))
    include(joinpath(@__DIR__, "references", "epibranch.jl"))
    include(joinpath(@__DIR__, "references", "epibranch_homogeneous.jl"))
    include(joinpath(@__DIR__, "references", "epibranch_isolation.jl"))
end
