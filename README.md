
# JuliaPackageWithRustDep.jl

[![License][license-img]](LICENSE)
[![travis][travis-img]][travis-url]

[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square
[travis-img]: https://img.shields.io/travis/felipenoris/JuliaPackageWithRustDep.jl/master.svg?label=Linux+/+macOS&style=flat-square
[travis-url]: https://travis-ci.org/felipenoris/JuliaPackageWithRustDep.jl

This is a set of examples on how to embed a Rust library in a Julia package.
Interfacing between Julia and Rust library is done using Rust's FFI:
the Rust library is exposed as a C dynamic library, and Julia will call Rust functions using `ccall`.

The build script `deps/build.jl` uses cargo to build the Rust library `deps/RustDylib`.
Julia bindings to the Rust API are implemented in `src/api.jl` file.

If the Rust library build is successful during `Pkg.build`, the file `deps/deps.jl` is generated,
and the package `__init__` function will call `check_deps` to check if the Rust dynamic library
is callable. This follows the same convention used by **[BinaryProvider.jl](https://github.com/JuliaPackaging/BinaryProvider.jl)**.

## Requirements

* Julia v1.0

* Rust Stable

## Installation

```julia
julia> using Pkg

julia> pkg"add https://github.com/felipenoris/JuliaPackageWithRustDep.jl.git"

julia> Pkg.test("JuliaPackageWithRustDep")

```

## Primitive Type Correspondences

| Julia   | Rust |
| ------- | ---- |
| Int32   | i32  |
| Int64   | i64  |
| Int64   | i64  |
| Float32 | f32  |
| Float64 | f64  |
| Bool    | bool |

## Passing a Julia Owned String to Rust

A Julia `String` is converted to a `Cstring` and passed to Rust, which will receive it as a pointer to char.

```julia
function rustdylib_inspect_string(s::String)
    ccall((:rustdylib_inspect_string, librustdylib), Cvoid, (Cstring,), s)
end
```

In Rust, the pointer to thar `*const c_char` is converted to a `CStr`, which is a reference to a C String.
From a `CStr`, you can convert it to a regular `&str`.

```rust
use std::ffi::CStr;
use std::os::raw::c_char;

#[no_mangle]
pub extern fn rustdylib_inspect_string(cstring: *const c_char) {
    let cstr = unsafe { CStr::from_ptr(cstring) };

    match cstr.to_str() {
        Ok(s) => {
            // `s` is a regular `&str`
            println!("Rust read `{:?}`.", s);
        }
        Err(_) => {
            panic!("Couldn't convert foreign Cstring to &str.");
        }
    }
}
```

## Returning a Rust Owned String to Julia

In this example, the Rust generates a owned string with `rustdylib_generate_rust_owned_string`
and the ownership is transfered to the Julia process.

After being consumed, the Julia process must transfer the ownership back to Rust
by calling `rustdylib_free_rust_owned_string`, to let the memory be freed.

```rust
use std::ffi::CString;
use std::os::raw::c_char;

#[no_mangle]
pub extern fn rustdylib_generate_rust_owned_string() -> *mut c_char {
    let rust_string = String::from("The bomb: 💣");
    let cstring = CString::new(rust_string).unwrap();
    cstring.into_raw() // transfers ownership to the Julia process
}

#[no_mangle]
pub extern fn rustdylib_free_rust_owned_string(s: *mut c_char) {
    unsafe {
        if !s.is_null() {
            drop(CString::from_raw(s)) // retakes ownership of the CString and drop
        }
    };
}
```

In the Julia process, the pointer to string is copied to a new `String` instance using `unsafe_string` function.
Then, Julia asks Rust to free the string.

```julia
function rustdylib_free_rust_owned_string(s::Cstring)
    ccall((:rustdylib_free_rust_owned_string, librustdylib), Cvoid, (Cstring,), s)
end

function rustdylib_generate_rust_owned_string()
    ccall((:rustdylib_generate_rust_owned_string, librustdylib), Cstring, ())
end

function read_rust_owned_string() :: String
    cstring = rustdylib_generate_rust_owned_string()
    result = unsafe_string(cstring) # copies the contents of the string
    rustdylib_free_rust_owned_string(cstring) # ask Rust to free the memory
    return result
end
```

## Resources

* [Exposing a Rust Library to C](http://greyblake.com/blog/2017/08/10/exposing-rust-library-to-c/)

* [std::ffi docs](https://doc.rust-lang.org/std/ffi/index.html)

* [Rust FFI Guide](https://michael-f-bryan.github.io/rust-ffi-guide/)
