# The forward pass compiled as OpenCL device code (see
# `test/device/forward.jl`), on pocl's CPU device, so it runs without a GPU.
# Not part of `Pkg.test`. From the repository root:
#
#   julia --project=test/opencl -e 'using Pkg; Pkg.instantiate()'
#   julia --project=test/opencl --startup-file=no test/opencl/runtests.jl
using OpenCL, pocl_jll

# pocl, even where another OpenCL platform such as a GPU driver is present.
let i = findfirst(p -> occursin("Portable", p.name), cl.platforms())
    i === nothing && error("no pocl OpenCL platform")
    cl.platform!(cl.platforms()[i])
end
@info "OpenCL device" cl.device().name
OpenCL.allowscalar(false)

include(joinpath(@__DIR__, "..", "device", "forward.jl"))

# OpenCL.jl has no sparse matrix type, so the sparse case is skipped.
const GPUCases = gpu_cases("using JLArrays: JLSparseMatrixCSR" => "")
const SKIP = Dict(
    "Recurrence, sparse coupling" => "OpenCL.jl has no sparse matrix type"
)

device_forward_tests(
    "OpenCL forward pass", GPUCases, CLArray, OpenCLBackend(); skip = SKIP
)
