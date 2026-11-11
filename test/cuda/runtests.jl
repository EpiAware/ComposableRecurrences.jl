# The forward pass on an NVIDIA GPU (see `test/device/forward.jl`). Not part
# of `Pkg.test`, and needs a CUDA GPU. From the repository root:
#
#   julia --project=test/cuda -e 'using Pkg; Pkg.instantiate()'
#   julia --project=test/cuda --startup-file=no test/cuda/runtests.jl
using CUDA

CUDA.functional() || error("no functional CUDA GPU")
CUDA.allowscalar(false)

include(joinpath(@__DIR__, "..", "device", "forward.jl"))

# The cases with CUDA's sparse matrix.
const GPUCases = gpu_cases(
    "using JLArrays: JLSparseMatrixCSR" =>
        "using CUDA.CUSPARSE: CuSparseMatrixCSR",
    "JLSparseMatrixCSR(" => "CuSparseMatrixCSR("
)

device_forward_tests("CUDA forward pass", GPUCases, CuArray, CUDABackend())
