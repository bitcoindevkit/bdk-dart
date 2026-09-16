// Android 15+ devices with 16 KiB memory pages refuse to load shared libraries
// whose ELF segments are only 4 KiB aligned. NDK 27 (pinned in CI) still
// defaults to 4 KiB, so the alignment is requested explicitly here.
//
// Emitting the linker flags from the build script makes them intrinsic to the
// crate: every Android cdylib link picks them up, whether driven by the Dart
// Native Assets hook, CI, or a manual `cargo build --target <android-triple>`.
// Unlike `target.<cfg>.rustflags` in a Cargo config, these flags are additive
// and survive a consumer exporting RUSTFLAGS.
fn main() {
    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-env-changed=CARGO_CFG_TARGET_OS");

    if std::env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("android") {
        for arg in ["-z", "max-page-size=16384", "-z", "common-page-size=16384"] {
            println!("cargo:rustc-link-arg-cdylib={arg}");
        }
    }
}
