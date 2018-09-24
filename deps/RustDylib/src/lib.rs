
#[no_mangle]
pub extern fn rustdylib_printhello() {
    println!("Hello from Rust!");
}

#[no_mangle]
pub extern fn rustdylib_abs_i32(i: i32) -> i32 {
	if i >= 0 {
		i
	} else {
		-i
	}
}

#[no_mangle]
pub extern fn rustdylib_abs_i64(i: i64) -> i64 {
	if i >= 0 {
		i
	} else {
		-i
	}
}
