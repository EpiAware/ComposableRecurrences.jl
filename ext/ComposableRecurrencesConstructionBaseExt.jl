# A time-varying wrapper's indexing is a type parameter with no field, so a
# rebuild from its fields must name it, or `TimeVarying(x)` would read the
# kernel as `Secondary()`.
module ComposableRecurrencesConstructionBaseExt

using ComposableRecurrences: TimeVarying
using ConstructionBase: ConstructionBase

ConstructionBase.constructorof(::Type{<:TimeVarying{I}}) where {I} = TimeVarying{I}

end
