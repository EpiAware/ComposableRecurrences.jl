# The backends a test item that checks several of them runs in this job.
# Each per-backend AD job passes its backend's tag to `runtests.jl`, and an
# item tagged for several backends runs in each of those jobs. Checking only
# the job's own backend there keeps every check in the matrix once, without
# compiling the other backends' gradients in every job. A run without a
# backend tag (every item, or a tag such as `compat_floor`) checks them all.

@testsnippet JobBackends begin
    const BACKEND_TAGS = (
        :forwarddiff, :reversediff, :reversediff_compiled, :enzyme_forward,
        :enzyme_reverse, :mooncake_reverse, :mooncake_forward,
    )

    # Whether this job checks the backend tagged `tag`.
    function job_runs(tag::Symbol)
        tags = filter(in(BACKEND_TAGS), Symbol.(ARGS))
        return isempty(tags) || tag in tags
    end

    # The values of `pairs`, each `backend tag => value`, this job checks.
    job_backends(pairs::Pair{Symbol}...) =
        Tuple(last(p) for p in pairs if job_runs(first(p)))
end
