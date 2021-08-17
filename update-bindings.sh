#!/usr/bin/env bash

if [ ! -e "$BINDGEN" ]; then
    echo "BINDGEN not executable or not defined, set it to path to rust-bindgen"
fi

if [ ! -f acpica/source/include/platform/acrobigalia.h ]; then
    patch -N -d acpica -p1 < patches/add-robigalia.patch
fi

$BINDGEN -match acpica -o src/raw32.rs -D NRK -I /usr/lib/clang/*/include/ acpica/source/include/acpi.h
$BINDGEN -match acpica -o src/raw64.rs -D NRK -I /usr/lib/clang/*/include/ acpica/source/include/acpi.h

function replacements() {
    sed $1 -i -e 's/::std::os::raw::c_char/i8/'
    sed $1 -i -e 's/::std::os::raw::c_uchar/i8/'
    sed $1 -i -e 's/::std::os::raw::c_void/c_void/'
    sed $1 -i -e 's/::std::os::raw::c_int/i32/'
    sed $1 -i -e 's/::std::os::raw::c_long/i32/'
    sed $1 -i -e 's/BOOLEAN = .*;/BOOLEAN = bool;/'
    sed $1 -i -e 's/UINT8 = .*;/UINT8 = u8;/'
    sed $1 -i -e 's/UINT16 = .*;/UINT16 = u16;/'
    sed $1 -i -e 's/UINT32 = .*;/UINT32 = u32;/'
    sed $1 -i -e 's/UINT64 = .*;/UINT64 = u64;/'
    sed $1 -i -e 's/INT16 = .*;/INT16 = i16;/'
    sed $1 -i -e 's/INT32 = .*;/INT32 = i32;/'
    sed $1 -i -e 's/INT64 = .*;/INT64 = i64;/'
    sed $1 -i -e 's/::std::option/::core::option/'
    sed $1 -i -e 's/::std::mem/::core::mem/'
    sed $1 -i -e 's/::std::clone/::core::clone/'
    sed $1 -i -e 's/::std::default/::core::default/'
    sed $1 -i -e 's/ = 1, }/ = 1, _UNUSED_VARIANT = 2, }/'
}

replacements src/raw32.rs
replacements src/raw64.rs
