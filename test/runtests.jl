
import JuliaPackageWithRustDep

# void
JuliaPackageWithRustDep.rustdylib_printhello()

# Int32
println( JuliaPackageWithRustDep.rustdylib_abs_i32(Int32(10)) )
println( JuliaPackageWithRustDep.rustdylib_abs_i32(Int32(-10)) )

# Int64
println( JuliaPackageWithRustDep.rustdylib_abs_i64(typemax(Int64)) )
println( JuliaPackageWithRustDep.rustdylib_abs_i64(typemin(Int64)) )
