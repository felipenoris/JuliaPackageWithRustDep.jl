
module JuliaPackageWithRustDep

const deps_file = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if !isfile(deps_file)
    error("JuliaPackageWithRustDep.jl is not installed properly, run Pkg.build(\"JuliaPackageWithRustDep\") and restart Julia.")
end
include(deps_file)

function __init__()
    check_deps()
end

include("api.jl")

end # module
