TARGET_DIR := justfile_directory() + "/target"
BIN_DIR := TARGET_DIR + "/bin"
#GUEST_DIR := justfile_directory() + "/guest"
GUEST_DIR := justfile_directory() + "/sample-wasi-http-kotlin"
#KOTLIN_GUEST_COMPONENT_WASM := GUEST_DIR + "/sample-wasi-http-kotlin.wasm"
KOTLIN_GUEST_COMPONENT_WASM := GUEST_DIR + "/sample-wasi-http-kotlin-component.wasm"
HYPERLIGHT_COMPILED_BIN := TARGET_DIR + "/guest.bin"
WIT_SRC := GUEST_DIR + "/wit"
HYPERLIGHT_AOT := justfile_directory() + "/hyperlight-wasm/target/debug/hyperlight-wasm-aot"

default: run

clean:
    rm -rf sample-wasi-http-kotlin
    rm -f hyperlight-world.wasm
    rm -rf hyperlight-wasm
    cargo clean

build-guest-component:
    #!/usr/bin/env bash
    git clone https://github.com/Kotlin/sample-wasi-http-kotlin.git 2>&1 | grep --invert-match 'fatal:.*already exists.*not.*empty directory' || true
    RUSTUP_TOOLCHAIN=1.89 make -e -C sample-wasi-http-kotlin setup
    make -C sample-wasi-http-kotlin componentify-prod
    cp sample-wasi-http-kotlin/build/sample-wasi-http-kotlin-component.wasm {{ KOTLIN_GUEST_COMPONENT_WASM }}

# git submodule might be a bit nicer, but adds more complexity, and this is simple and understandable
build-hyperlight-itself:
    #!/usr/bin/env bash
    git clone https://github.com/Kotlin/hyperlight-wasm.git 2>&1 | grep --invert-match 'fatal:.*already exists.*not.*empty directory' || true
    cd hyperlight-wasm && just build


assert-component:
    #!/usr/bin/env sh
    test -f {{ KOTLIN_GUEST_COMPONENT_WASM }} || {
        echo "Error: Component not found at {{ KOTLIN_GUEST_COMPONENT_WASM }}. Please build the component first and place it at the right path."
        exit 1
    }

aot-component: build-guest-component
    # TODO once cargo stabilizes -C, this would be much nicer with cargo -C hyperlight-wasm run ...
    {{ HYPERLIGHT_AOT }} compile --component \
        {{ KOTLIN_GUEST_COMPONENT_WASM }} \
        {{ HYPERLIGHT_COMPILED_BIN }}

make-wit-world: build-guest-component
    test -f hyperlight-world.wasm || \
    wasm-tools component wit {{ WIT_SRC }} -w -o hyperlight-world.wasm

build: make-wit-world build-hyperlight-itself
    cargo build

run: build aot-component
    cargo run -- {{ HYPERLIGHT_COMPILED_BIN }}
