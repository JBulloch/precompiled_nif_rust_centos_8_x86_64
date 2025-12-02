//! Pre-compiled NIF example for Explorer on CentOS 8 x86_64
//!
//! This is a minimal example that demonstrates the rustler_precompiled pattern.
//! Replace or extend this with the actual NIF implementations as needed.

// MiMalloc won't compile on Windows with the GCC compiler.
// On Linux with Musl it won't load correctly.
#[cfg(not(any(
    all(windows, target_env = "gnu"),
    all(target_os = "linux", target_env = "musl")
)))]
use mimalloc::MiMalloc;

#[cfg(not(any(
    all(windows, target_env = "gnu"),
    all(target_os = "linux", target_env = "musl")
)))]
#[global_allocator]
static GLOBAL: MiMalloc = MiMalloc;

/// Example NIF function that adds two integers.
#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

/// Example NIF function that returns a greeting.
#[rustler::nif]
fn hello() -> &'static str {
    "Hello from Explorer NIF!"
}

rustler::init!("Elixir.Explorer.Native");

