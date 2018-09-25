
// enables Vec::new() for static variables (rust nightly)
#![feature(const_vec_new)]

// enables vector.remove_item(item) (rust nightly)
#![feature(vec_remove_item)]

use std::ffi::{CString, CStr};
use std::os::raw::c_char;

#[no_mangle]
pub extern fn rustdylib_printhello() {
    println!("Hello from Rust!");
}

#[no_mangle]
pub extern fn rustdylib_abs_i32(i: i32) -> i32 {
    println!("Rust read i32 `{:?}`.", i);
    if i >= 0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern fn rustdylib_abs_i64(i: i64) -> i64 {
    println!("Rust read i64 `{:?}`.", i);
    if i >= 0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern fn rustdylib_abs_f32(i: f32) -> f32 {
    println!("Rust read f32 `{:?}`.", i);
    if i >= 0.0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern fn rustdylib_abs_f64(i: f64) -> f64 {
    println!("Rust read f64 `{:?}`.", i);
    if i >= 0.0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern fn rustdylib_is_true_bool(b: bool) -> bool {
    println!("Rust read bool `{:?}`.", b);
    b
}

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
