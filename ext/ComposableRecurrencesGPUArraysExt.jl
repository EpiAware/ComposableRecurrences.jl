module ComposableRecurrencesGPUArraysExt

using ComposableRecurrences: ComposableRecurrences, Pressure, Serial, _each!
using GPUArrays: AbstractGPUSparseMatrixCSR
using GPUArraysCore: AnyGPUArray

# A device CSR coupling gives each stratum its own row, so the rows run as
# one loop with no shared writes.
function ComposableRecurrences.forward(
        C::AbstractGPUSparseMatrixCSR, ::Pressure, q::AnyGPUArray, p, t
    )
    n = length(q)
    _each!(
        _csr_row_body!, Serial(), q, n, n + length(C.nzVal),
        q, C.rowPtr, C.colVal, C.nzVal, p
    )
    return nothing
end

function _csr_row_body!(a, q, rowptr, colval, nzval, p)
    acc = zero(eltype(q))
    for i in rowptr[a]:(rowptr[a + 1] - 1)
        acc += nzval[i] * p[colval[i]]
    end
    q[a] = acc
    return nothing
end

end
