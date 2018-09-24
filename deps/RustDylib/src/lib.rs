
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
