
function rustdylib_printhello()
    ccall((:rustdylib_printhello, librustdylib), Cvoid, ())
end

function rustdylib_abs_i32(n::Int32)
    ccall((:rustdylib_abs_i32, librustdylib), Int32, (Int32,), n)
end

function rustdylib_abs_i64(n::Int64)
    ccall((:rustdylib_abs_i64, librustdylib), Int64, (Int64,), n)
end

function rustdylib_abs_f32(n::Float32)
    ccall((:rustdylib_abs_f32, librustdylib), Float32, (Float32,), n)
end

function rustdylib_abs_f64(n::Float64)
    ccall((:rustdylib_abs_f64, librustdylib), Float64, (Float64,), n)
end

function rustdylib_is_true_bool(b::Bool)
    ccall((:rustdylib_is_true_bool, librustdylib), Bool, (Bool,), b)
end

function rustdylib_inspect_string(s::String)
    ccall((:rustdylib_inspect_string, librustdylib), Cvoid, (Cstring,), s)
end

function rustdylib_generate_rust_owned_string() :: String
    cstring = ccall((:rustdylib_generate_rust_owned_string, librustdylib), Ptr{UInt8}, ())
    result = unsafe_string(cstring)
    ccall((:rustdylib_free_rust_owned_string, librustdylib), Cvoid, (Ptr{UInt8},), cstring)
    return result
end
