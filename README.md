# precompiled_nif_rust_centos_8_x86_64

A repository to hold pre-compiled NIFs (Native Implemented Functions) for Elixir projects using Rust, specifically built for CentOS 8 x86_64.

## Overview

This repository uses [rustler_precompiled](https://github.com/philss/rustler_precompiled) (v0.7.0) to precompile NIFs and host them as GitHub releases. This speeds up build times by avoiding the need to compile Rust code on every deployment.

This template is designed for building NIFs for projects like [Explorer](https://github.com/elixir-nx/explorer), which uses [Polars](https://github.com/pola-rs/polars) - a fast DataFrame library written in Rust.

## Project Structure

```
├── .github/
│   └── workflows/
│       └── release.yml    # GitHub Actions workflow for building NIFs
├── lib/
│   └── explorer.ex        # Elixir module using rustler_precompiled
├── native/
│   └── explorer/
│       ├── Cargo.toml     # Rust project configuration
│       └── src/
│           └── lib.rs     # Rust NIF implementations
├── mix.exs                # Elixir project configuration
└── README.md
```

## Usage

### In your Elixir project

Add this repository's releases to your `rustler_precompiled` configuration:

```elixir
defmodule YourProject.Native do
  use RustlerPrecompiled,
    otp_app: :your_app,
    crate: "explorer",
    base_url: "https://github.com/JBulloch/precompiled_nif_rust_centos_8_x86_64/releases/download/v#{version}",
    force_build: System.get_env("EXPLORER_BUILD") in ["1", "true"],
    version: version
end
```

### Building locally

If you need to build the NIF locally:

```bash
# Install Elixir dependencies
mix deps.get

# Build the native code
cd native/explorer
cargo build --release
```

### Adding Polars dependencies

To use Polars in your NIF, update `native/explorer/Cargo.toml` to include:

```toml
[dependencies.polars]
version = "0.49"
default-features = false
features = [
  "lazy",
  "csv",
  "parquet",
  # Add other features as needed
]
```

## Release Process

NIFs are automatically built and released when a new tag is pushed:

```bash
git tag v0.1.0
git push origin v0.1.0
```

The GitHub Actions workflow will:
1. Build the NIF for x86_64-unknown-linux-gnu (CentOS 8 compatible)
2. Upload the compiled artifacts as release assets

## Supported Targets

- `x86_64-unknown-linux-gnu` (CentOS 8 x86_64)
  - Default build with AVX/FMA optimizations
  - Legacy CPU variant for older processors

## Requirements

- Elixir ~> 1.14
- Rust (latest stable)
- rustler_precompiled ~> 0.7

## License

Apache-2.0
