TARGET_DIR := justfile_directory() + "/target"
BIN_DIR := TARGET_DIR + "/bin"
GUEST_DIR := justfile_directory() + "/guest"
KOTLIN_GUEST_COMPONENT_WASM := GUEST_DIR + "/sample-wasi-http-kotlin.wasm"
HYPERLIGHT_COMPILED_BIN := TARGET_DIR + "/wasm32-wasip1/release/guest.bin"
WIT_SRC := justfile_directory() + "/guest/wit"
HYPERLIGHT_AOT := justfile_directory() + "/../hyperlight-wasm/target/debug/hyperlight-wasm-aot"

default: run

#install-cargo-component:
#    test -f {{ BIN_DIR }}/cargo-component || \
#    cargo install cargo-component \
#        --root {{ TARGET_DIR }}

# For kotlin: assumes component is already available under guest/TODO
#build-component: install-cargo-component
#    test -f {{ TARGET_DIR }}/wasm32-wasip1/release/sample_wasi_http_rust.wasm || \
#    cargo-component build --release \
#        --manifest-path {{ GUEST_DIR }}/Cargo.toml \
#        --target-dir {{ TARGET_DIR }}

#install-hyperlight-wasm-aot:
#    test -f {{ BIN_DIR }}/hyperlight-wasm-aot || \
#    cargo install hyperlight-wasm-aot \
#        --root {{ TARGET_DIR }}

assert-component:
    #!/usr/bin/env sh
    test -f {{ KOTLIN_GUEST_COMPONENT_WASM }} || {
        echo "Error: Component not found at {{ KOTLIN_GUEST_COMPONENT_WASM }}. Please build the component first and place it at the right path."
        exit 1
    }

aot-component: assert-component
    {{ HYPERLIGHT_AOT }} compile --component \
        {{ KOTLIN_GUEST_COMPONENT_WASM }} \
        {{ HYPERLIGHT_COMPILED_BIN }}

make-wit-world:
    test -f hyperlight-world.wasm || \
    wasm-tools component wit {{ WIT_SRC }} -w -o hyperlight-world.wasm

build: make-wit-world
    cargo build

run: build aot-component
    cargo run -- {{ HYPERLIGHT_COMPILED_BIN }}
