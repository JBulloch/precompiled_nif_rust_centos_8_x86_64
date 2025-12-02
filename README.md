# precompiled_nif_rust_centos_8_x86_64

A repository to hold pre-compiled NIFs (Native Implemented Functions) for [Explorer](https://github.com/elixir-nx/explorer) on CentOS 8 x86_64.

## Overview

This repository uses [rustler_precompiled](https://github.com/philss/rustler_precompiled) (v0.7.0) to precompile NIFs and host them as GitHub releases. This speeds up build times by avoiding the need to compile Rust code on every deployment.

Explorer uses [Polars](https://github.com/pola-rs/polars) - a fast DataFrame library written in Rust.

## GitHub Release Structure

### Release Tag

Release tags must match the Explorer version. For Explorer `~> 0.11.0`:

```
v0.11.0
```

### Release Assets

Each release contains tar.gz files named according to this pattern:

```
explorer-nif-{nif_version}-{target}.tar.gz
```

For CentOS 8 (x86_64):

```
explorer-nif-2.15-x86_64-unknown-linux-gnu.tar.gz
```

### Inside the tar.gz

The archive contains:

```
native/libexplorer.so
```

This is the compiled NIF library for CentOS 8.

## How RustlerPrecompiled Downloads

When building on CentOS 8, RustlerPrecompiled will:

1. Detect the target platform (`x86_64-unknown-linux-gnu`)
2. Detect the NIF version (e.g., `2.15`)
3. Construct the URL:
   ```
   https://github.com/JBulloch/precompiled_nif_rust_centos_8_x86_64/releases/download/v0.11.0/explorer-nif-2.15-x86_64-unknown-linux-gnu.tar.gz
   ```
4. Download and extract the precompiled `.so` file
5. Skip Rust compilation entirely

## Building Precompiled NIFs Manually

To create precompiled files on a CentOS 8 machine:

```bash
# 1. Clone Explorer and navigate to the native code
cd deps/explorer/native/explorer
cargo build --release

# 2. Package the library
mkdir -p native
cp target/release/libexplorer.so native/
tar -czf explorer-nif-2.15-x86_64-unknown-linux-gnu.tar.gz native/

# 3. Upload to GitHub release v0.11.0
```

## Automated Release Process

The GitHub Actions workflow automatically builds and releases NIFs when a tag is pushed:

```bash
git tag v0.11.0
git push origin v0.11.0
```

The workflow will:
1. Build the NIF for `x86_64-unknown-linux-gnu` (CentOS 8 compatible)
2. Package it as `explorer-nif-2.15-x86_64-unknown-linux-gnu.tar.gz`
3. Upload the compiled artifacts as release assets

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

## Usage in Your Elixir Project

Configure your project to use these precompiled NIFs:

```elixir
defmodule YourProject.Native do
  use RustlerPrecompiled,
    otp_app: :explorer,
    crate: "explorer",
    base_url: "https://github.com/JBulloch/precompiled_nif_rust_centos_8_x86_64/releases/download/v#{version}",
    force_build: System.get_env("EXPLORER_BUILD") in ["1", "true"],
    version: version
end
```

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
