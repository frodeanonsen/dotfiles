#!/usr/bin/env bash

# RustUp
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Rust
rustup update

# RustOwl
curl -L "https://github.com/cordx56/rustowl/releases/download/v0.1.1/install.sh" | sh
