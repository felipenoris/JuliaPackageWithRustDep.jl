
# This file was generated automatically by contrib/generator.jl script

using CEnum

function rustdylib_printhello()
    ccall((:rustdylib_printhello, librustdylib), Cvoid, ())
end

function rustdylib_abs_i32(i)
    ccall((:rustdylib_abs_i32, librustdylib), Int32, (Int32,), i)
end

function rustdylib_abs_i64(i)
    ccall((:rustdylib_abs_i64, librustdylib), Int64, (Int64,), i)
end

function rustdylib_abs_f32(i)
    ccall((:rustdylib_abs_f32, librustdylib), Cfloat, (Cfloat,), i)
end

function rustdylib_abs_f64(i)
    ccall((:rustdylib_abs_f64, librustdylib), Cdouble, (Cdouble,), i)
end

function rustdylib_is_true_bool(b)
    ccall((:rustdylib_is_true_bool, librustdylib), Bool, (Bool,), b)
end

function rustdylib_inspect_string(cstring)
    ccall((:rustdylib_inspect_string, librustdylib), Cvoid, (Ptr{Cchar},), cstring)
end

function rustdylib_generate_rust_owned_string()
    ccall((:rustdylib_generate_rust_owned_string, librustdylib), Ptr{Cchar}, ())
end

function rustdylib_free_rust_owned_string(s)
    ccall((:rustdylib_free_rust_owned_string, librustdylib), Cvoid, (Ptr{Cchar},), s)
end
