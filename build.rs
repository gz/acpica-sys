/* Copyright (c) 2015 The Robigalia Project Developers
 * Licensed under the Apache License, Version 2.0
 * <LICENSE-APACHE or
 * http://www.apache.org/licenses/LICENSE-2.0> or the MIT
 * license <LICENSE-MIT or http://opensource.org/licenses/MIT>,
 * at your option. All files in the project carrying such
 * notice may not be copied, modified, or distributed except
 * according to those terms.
 */

use std::process::Command;
use std::env;
fn main() {
    if env::var("TARGET").unwrap() == "i686-sel4-unknown" {
        assert!(
            Command::new("/usr/bin/env")
            .arg("make")
            .arg("-f")
            .arg("_Makefile")
            .status().unwrap().success());

        println!("cargo:rustc-link-lib=static=acpica-{}", env::var("TARGET").unwrap());
        println!("cargo:rustc-link-search=native={}", env::var("OUT_DIR").unwrap());
    }
}
