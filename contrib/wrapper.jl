
# script to generate api.jl
# depends on package Clang = "40e3b903-d033-50b4-a0cc-940c62c95e31"

using Clang

dir = splitdir(@__FILE__)[1]
context = wrap_c.init(output_file = joinpath(dir,"../src/api.jl"), clang_diagnostics=true, clang_includes=["/usr/lib/llvm-3.8/lib/clang/3.8.0/include/"],
    header_wrapped = (p,s)->begin
        s=="deps/RustDylib/include/myheader.h"
    end, common_file = joinpath(dir,"../src/api_common.jl"),
    header_library=x->"librustdylib")
context.options.wrap_structs=true
context.headers = ["deps/RustDylib/include/myheader.h"]
run(context)
