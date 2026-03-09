TODO before making public:
- [ ] Probably re-create this repo as a public fork of the original project

# `hyperlight-wasm` http example: Kotlin

This is a minimal example of a
[hyperlight-wasm](https://github.com/Kotlin/hyperlight-wasm)
host application. It implements just enough of the `wasi:http` api
to run the [sample-wasi-http-kotlin server](https://github.com/Kotlin/sample-wasi-http-kotlin).

It's forked from https://github.com/hyperlight-dev/hyperlight-wasm-http-example, as the changes here are specific to a Kotlin guest component.

In general, this example is only a prototype, and relatively hacky and fragile, use at your own risk.

## Prerequisites

1. [Rust](https://www.rust-lang.org/tools/install), including the `x86_64-unknown-none` target (which may be installed via e.g. `rustup target add x86_64-unknown-none`)
    - Specifically, we need ***both*** Rust versions 1.87 and 1.89
2. `clang`
3. [`just`](https://github.com/casey/just)
4. All requirements of [sample-wasi-http-kotlin server](https://github.com/Kotlin/sample-wasi-http-kotlin), except for wasmtime.

## Setup

NOTE: The build system fetches multiple git repositories (sometimes recursively). That means that updating one of them might not correctly propagate "all the way up", so if in doubt, run `just clean`.

### Building

```sh
just build
```

### Running

```sh
just run
```

From another terminal, you can then test the server with the included [curlIt.sh](curlIt.sh) script:

```sh
./curlIt.sh
```

