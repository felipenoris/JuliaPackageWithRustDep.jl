# Julia wrapper for header: deps/RustDylib/include/myheader.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function rustdylib_abs_f32(i::Cfloat)
    ccall((:rustdylib_abs_f32, librustdylib), Cfloat, (Cfloat,), i)
end

function rustdylib_abs_f64(i::Cdouble)
    ccall((:rustdylib_abs_f64, librustdylib), Cdouble, (Cdouble,), i)
end

function rustdylib_abs_i32(i::Int32)
    ccall((:rustdylib_abs_i32, librustdylib), Int32, (Int32,), i)
end

function rustdylib_abs_i64(i::Int64)
    ccall((:rustdylib_abs_i64, librustdylib), Int64, (Int64,), i)
end

function rustdylib_free_rust_owned_string(s)
    ccall((:rustdylib_free_rust_owned_string, librustdylib), Cvoid, (Cstring,), s)
end

function rustdylib_generate_rust_owned_string()
    ccall((:rustdylib_generate_rust_owned_string, librustdylib), Cstring, ())
end

function rustdylib_inspect_string(cstring)
    ccall((:rustdylib_inspect_string, librustdylib), Cvoid, (Cstring,), cstring)
end

function rustdylib_is_true_bool(b::Bool)
    ccall((:rustdylib_is_true_bool, librustdylib), Bool, (Bool,), b)
end

function rustdylib_printhello()
    ccall((:rustdylib_printhello, librustdylib), Cvoid, ())
end
