
ENV["CARGO_TARGET_DIR"] = @__DIR__

const rustprojname = "RustDylib"
const rustlibname = "rustdylib"
const juliapackage = "JuliaPackageWithRustDep"

const libname = Sys.iswindows() ? rustlibname : "lib" * rustlibname
# Windows .dlls do not have the "lib" prefix

function build_dylib()
    clean()

    run(Cmd(`cargo build --release`, dir=joinpath(@__DIR__, rustprojname)))

    release_dir = joinpath(@__DIR__, "release")
    dylib = dylib_filename()

    release_dylib_filepath = joinpath(release_dir, dylib)
    @assert isfile(release_dylib_filepath) "$release_dylib_filepath not found. Build may have failed."
    mv(release_dylib_filepath, joinpath(@__DIR__, dylib))
    rm(release_dir, recursive=true)

    write_deps_file(libname, dylib, juliapackage)
end

function dylib_filename()
    @static if Sys.isapple()
        "$libname.dylib"
    elseif Sys.islinux()
        "$libname.so"
    elseif Sys.iswindows()
        "$libname.dll"
    else
        error("Not supported: $(Sys.KERNEL)")
    end
end

function write_deps_file(libname, libfile, juliapackage)
    script = """
import Libdl

const $libname = joinpath(@__DIR__, "$libfile")

function check_deps()
    global $libname
    if !isfile($libname)
        error("\$$libname does not exist, Please re-run Pkg.build(\\"$juliapackage\\"), and restart Julia.")
    end

    if Libdl.dlopen_e($libname) == C_NULL
        error("\$$libname cannot be opened, Please re-run Pkg.build(\\"$juliapackage\\"), and restart Julia.")
    end
end
"""

    open(joinpath(@__DIR__, "deps.jl"), "w") do f
        write(f, script)
    end
end

function clean()
    deps_file = joinpath(@__DIR__, "deps.jl")
    isfile(deps_file) && rm(deps_file)

    release_dir = joinpath(@__DIR__, "release")
    isdir(release_dir) && rm(release_dir, recursive=true)

    dylib_file = joinpath(@__DIR__, dylib_filename())
    isfile(dylib_file) && rm(dylib_file)
end

build_dylib()
