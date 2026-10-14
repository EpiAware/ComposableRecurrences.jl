using TestItemRunner
const PAT = ARGS[1]
@run_package_tests filter = ti -> occursin(Regex(PAT), ti.name) && !(:ad in ti.tags)
