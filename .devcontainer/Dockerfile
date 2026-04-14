## Dockerfile for devcontainer

FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04 AS base


ARG USER=vscode
ARG GROUP=vscode

ENV HOME="/home/${USER}"
ENV PATH="$HOME/.cargo/bin:$PATH"

# Install dependencies
RUN apt-get update \
    && apt-get -y install \
        build-essential \
        cmake \
        curl \
        gdb \
        git \
        gnupg \
        lsb-release \
        make \
        pkg-config \
        software-properties-common \
        sudo \
        wget \
        musl-tools \
        default-jdk


ARG LLVM_VERSION=18

# Install llvm
RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x ./llvm.sh         \
    && sudo ./llvm.sh ${LLVM_VERSION} clang clang-tools-extra      \
    && sudo ln -s /usr/lib/llvm-${LLVM_VERSION}/bin/ld.lld /usr/bin/ld.lld     \
    && sudo ln -s /usr/lib/llvm-${LLVM_VERSION}/bin/clang /usr/bin/clang

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

FROM base AS dev

# Make sure the devcontainer user has sudo access
RUN chown -R "${USER}:${GROUP}" /home/${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Persist bash history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R "${USER}" /commandhistory \
    && echo "$SNIPPET" >> "/home/${USER}/.bashrc"

USER $USER

ARG RUST_TOOLCHAIN=1.89

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rustup install --no-self-update 1.87 ${RUST_TOOLCHAIN} \
    && rustup default ${RUST_TOOLCHAIN} \
    && rustup target add x86_64-unknown-linux-gnu \
    && rustup target add x86_64-unknown-linux-musl \
    && rustup target add x86_64-unknown-none      \
    && rustup target add wasm32-wasip1             \
    && rustup toolchain add nightly-x86_64-unknown-linux-gnu \
    && rustup target add x86_64-unknown-none --toolchain 1.87.0 \
    && cargo install --locked just \
    && cargo install --locked cargo-component \
    && cargo install --locked cargo-hyperlight \
    && cargo install --locked wasm-tools \
    && cargo install hyperlight-wasm-aot --locked --version 0.12.0 \
    && cargo install wasmtime-cli --locked --version 37.0.0
