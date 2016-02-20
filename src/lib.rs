#![no_std]
#![allow(bad_style)]
pub type va_list = usize;

#[repr(u8)]
pub enum c_void {
    __var1,
    __var2,
}

#[cfg(target_pointer_width = "32")]
include!("raw32.rs");

#[cfg(target_pointer_width = "64")]
include!("raw64.rs");
