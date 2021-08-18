# acpica-sys

Builds acpica, and has bindings to it. To actually use most of it, various
symbols will need to be provided, described in section 9 of the ACPICA
reference manual.

This is a fork of the existing acpica-sys crate with minor modifications:

* Use GCC
* Modified build
* More recent acpica sources

Check https://crates.io/crates/libacpica for more details.

## Updating ACPICA sources

Some steps that might be useful to follow:

* Download new sources from https://acpica.org/downloads
* Rename acpica to acpica-old
* Unpack new acpica sources, rename folder to acpica
* `cp acpica-old/source/include/platform/acnrk.h acpica/source/include/platform/acnrk.h`
* `mv src/raw64.rs src/raw64.bak.rs`
* `bash update-bindings.sh` (Make sure rust-bindgen is installed for this step)
* Inspect `raw64.rs` see if it approximately represents `src/raw64.bak.rs` file.
* Switch whatever project uses this to new version of the crate and see if it compiles
* `rm src/raw64.bak.rs`
* `rm -rf acpica-old`

Some issues that can be expected and what to do about them:

* Compilation error due to __va_list_tag, AcpiOsVprintf etc. -> Just remove those definitons.
* Compilation error `error[E0433]: failed to resolve: maybe a missing crate std?` -> Replace with core, or remove those definiton if unwanted.
* `error[E0308]: mismatched types expected i32, found u32`: Make sure UINT8, UINT32, UINT64 map to u8, u32, u64 respectively (and not i8, i32, i64).
* Linker throws multiple definition of a symbol errors:
```log
|   = note: ld: ./target/x86_64-nrk/debug/deps/liblibacpica-e827d49529440c52.rlib(utglobal.o):(.data+0x0): multiple definition of `AcpiGbl_FixedEventInfo'; ./target/x86_64-nrk/debug/deps/liblibacpica-70ca8cf5bc7406ee.rlib(utglobal.o):(.data+0x0): first defined here
```

Some older version of libacpica creeped in through a transitive dependency?
Use `patch` section to override everything to the new version for testing.
```
[patch.crates-io]
libacpica = { path = "../lib/acpica-sys" }
```

And don't forget to run `cargo update -p libacpica:$OLDVER --precise $NEWVER`.
