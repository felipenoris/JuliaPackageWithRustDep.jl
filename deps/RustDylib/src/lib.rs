use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn rustdylib_printhello() {
    println!("Hello from Rust!");
}

#[no_mangle]
pub extern "C" fn rustdylib_abs_i32(i: i32) -> i32 {
    println!("Rust read i32 `{:?}`.", i);
    if i >= 0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern "C" fn rustdylib_abs_i64(i: i64) -> i64 {
    println!("Rust read i64 `{:?}`.", i);
    if i >= 0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern "C" fn rustdylib_abs_f32(i: f32) -> f32 {
    println!("Rust read f32 `{:?}`.", i);
    if i >= 0.0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern "C" fn rustdylib_abs_f64(i: f64) -> f64 {
    println!("Rust read f64 `{:?}`.", i);
    if i >= 0.0 {
        i
    } else {
        -i
    }
}

#[no_mangle]
pub extern "C" fn rustdylib_is_true_bool(b: bool) -> bool {
    println!("Rust read bool `{:?}`.", b);
    b
}

#[no_mangle]
pub unsafe extern "C" fn rustdylib_inspect_string(cstring: *const c_char) {
    let cstr = CStr::from_ptr(cstring);

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

#[no_mangle]
pub extern "C" fn rustdylib_generate_rust_owned_string() -> *mut c_char {
    let rust_string = String::from("The bomb: 💣");
    let cstring = CString::new(rust_string).unwrap();
    cstring.into_raw() // transfers ownership to the Julia process
}

#[no_mangle]
pub unsafe extern "C" fn rustdylib_free_rust_owned_string(s: *mut c_char) {
    if !s.is_null() {
        drop(CString::from_raw(s)); // retakes ownership of the CString and drops
    }
}
