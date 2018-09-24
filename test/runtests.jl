
import JuliaPackageWithRustDep
using Test

# void
JuliaPackageWithRustDep.rustdylib_printhello()

# Int32
@test JuliaPackageWithRustDep.rustdylib_abs_i32(Int32(10)) == 10
@test JuliaPackageWithRustDep.rustdylib_abs_i32(Int32(-10)) == 10

# Int64
@test JuliaPackageWithRustDep.rustdylib_abs_i64(typemax(Int64)) == typemax(Int64)
@test JuliaPackageWithRustDep.rustdylib_abs_i64(typemin(Int64)) == typemax(Int64)

# Float32
@test JuliaPackageWithRustDep.rustdylib_abs_f32(Float32(1.0)) == 1.0
@test JuliaPackageWithRustDep.rustdylib_abs_f32(Float32(-1.0)) == 1.0

# Float64
@test JuliaPackageWithRustDep.rustdylib_abs_f64(Float64(1.0)) == 1.0
@test JuliaPackageWithRustDep.rustdylib_abs_f64(Float64(-1.0)) == 1.0

# Bool
@test JuliaPackageWithRustDep.rustdylib_is_true_bool(true) == true
@test JuliaPackageWithRustDep.rustdylib_is_true_bool(false) == false

JuliaPackageWithRustDep.rustdylib_inspect_string("hey you")
JuliaPackageWithRustDep.rustdylib_inspect_string("é∈δ")
