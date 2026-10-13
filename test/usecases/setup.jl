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

    # CTIDM's renewal step with susceptible depletion from a population `N`.
    # The interval `g` is lag 1 first; CTIDM stores it reversed.
    function depleting_renewal_step(g, N)
        C = CTIDMReference
        return C.RenewalStep(
            C.ConstantRenewalStep(reverse(g)), (C.SusceptibleDepletion(N),)
        )
    end
end
