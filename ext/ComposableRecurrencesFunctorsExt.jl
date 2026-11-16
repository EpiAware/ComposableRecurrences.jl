module ComposableRecurrencesFunctorsExt

using ComposableRecurrences: ComposableRecurrences
using Functors: fmap

# Every leaf `fmap` reaches: float arrays and single floats convert, all
# else is kept. `fmap` rebuilds each struct around its converted fields.
function ComposableRecurrences._convert_floats(::Type{T}, x) where {T <: AbstractFloat}
    return fmap(y -> _convert(T, y), x)
end
_convert(::Type{T}, y::AbstractFloat) where {T} = T(y)
_convert(::Type{T}, y::AbstractArray{<:AbstractFloat}) where {T} = T.(y)
_convert(::Type, y) = y

end
