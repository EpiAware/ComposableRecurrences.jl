module ComposableRecurrencesMooncakeExt

using ComposableRecurrences: ComposableRecurrences, Serial, _Current, _current
using Mooncake: Mooncake, @is_primitive, @zero_derivative, CoDual, DefaultCtx,
    ForwardMode, NoPullback, ReverseMode, zero_fcodual

# Reading the `EXECUTOR` scoped value walks task-local state Mooncake cannot
# differentiate, and the executor carries no derivative. Reverse mode does
# not differentiate tasks, so a call it differentiates runs serially
# whatever executor is set; forward mode keeps the executor.
@zero_derivative DefaultCtx Tuple{typeof(_current)} ForwardMode
@is_primitive DefaultCtx ReverseMode Tuple{typeof(_current)}
function Mooncake.rrule!!(f::CoDual{typeof(_current)})
    return zero_fcodual(_Current(Serial())), NoPullback(f)
end

end
