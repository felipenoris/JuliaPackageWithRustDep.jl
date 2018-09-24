
function rustdylib_printhello()
    ccall((:rustdylib_printhello, librustdylib), Cvoid, ())
end

function rustdylib_abs_i32(n::Int32)
    ccall((:rustdylib_abs_i32, librustdylib), Int32, (Int32,), n)
end

function rustdylib_abs_i64(n::Int64)
    ccall((:rustdylib_abs_i64, librustdylib), Int64, (Int64,), n)
end
