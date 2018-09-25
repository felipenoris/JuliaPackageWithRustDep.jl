
# JuliaPackageWithRustDep.jl

[![License][license-img]](LICENSE)
[![travis][travis-img]][travis-url]

[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat
[travis-img]: https://img.shields.io/travis/felipenoris/JuliaPackageWithRustDep.jl/master.svg?label=Linux+/+macOS
[travis-url]: https://travis-ci.org/felipenoris/JuliaPackageWithRustDep.jl

This is a set of examples on how to embed a Rust library in a Julia package.

The build script `deps/build.jl` uses cargo to build the Rust library `deps/RustDylib`.
Julia bindings to the Rust API are implemented in `src/api.jl` file.

If the Rust library build is successful during `Pkg.build`, the file `deps/deps.jl` is generated,
and the package `__init__` function will call `check_deps` to check if the Rust dynamic library
is callable. This follows the same convention used by **[BinaryProvider.jl](https://github.com/JuliaPackaging/BinaryProvider.jl)**.

## Requirements

* Julia v1.0

* Rust Nightly

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

In this example, the Rust Owned String created by `rustdylib_pass_rust_owned_string`
is kept in a global variable `ALLOCATED_STRINGS` to ensure that
the reference is still valid until the Julia process calls Rust's
`rustdylib_free_rust_owned_string` function to free the String.

```rust
// tracks strings created by rustdylib_pass_rust_owned_string
// until rustdylib_free_rust_owned_string is called.
static mut ALLOCATED_STRINGS: Vec<CString> = Vec::new();

//Passing a Rust-originating C string:
#[no_mangle]
pub extern fn rustdylib_pass_rust_owned_string() -> *const c_char {
    let s = CString::new("rust-originating string").unwrap();
    let ptr = s.as_ptr();
    unsafe{ ALLOCATED_STRINGS.push(s); } // moves s
    ptr
}

#[no_mangle]
pub extern fn rustdylib_free_rust_owned_string(ptr: *const c_char) {
    unsafe {
        println!("ALLOCATED_STRINGS len was: {:?}", ALLOCATED_STRINGS.len());
        for s in ALLOCATED_STRINGS.iter() {
            if s.as_ptr() == ptr {
                println!("Freeing string {:?}", s);
                ALLOCATED_STRINGS.remove_item(s);
                break;
            }
        }
        println!("ALLOCATED_STRINGS len after removing item: {:?}", ALLOCATED_STRINGS.len());
    }
}
```

In the Julia process, the pointer to string is copied to a new `String` instance using `unsafe_string` function.
Then, Julia asks Rust to free the string.

```julia
function rustdylib_pass_rust_owned_string() :: String
	cstring = ccall((:rustdylib_pass_rust_owned_string, librustdylib), Ptr{UInt8}, ())
	result = unsafe_string(cstring) # copies the contents of the string
	ccall((:rustdylib_free_rust_owned_string, librustdylib), Cvoid, (Ptr{UInt8},), cstring) # ask Rust to free the memory
	return result
end
```

## Resources

* [Exposing a Rust Library to C](http://greyblake.com/blog/2017/08/10/exposing-rust-library-to-c/)

* [std::ffi docs](https://doc.rust-lang.org/std/ffi/index.html)

* [Rust FFI Guide](https://michael-f-bryan.github.io/rust-ffi-guide/)
