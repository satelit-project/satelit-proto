#!/usr/bin/env bash

set -euo pipefail

RUST_PLUGIN_GIT="https://github.com/satelit-project/protoc-rust.git"
RUST_PLUGIN_TAG="0.1.2"
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

cargo install protoc-rust \
  --features "tower-hyper" \
  --git "${RUST_PLUGIN_GIT}" \
  --tag "${RUST_PLUGIN_TAG}" \
  --root "${WORKING_DIR}" \
  --force

cd "${TMP_DIR}" || exit
GO111MODULE=on GOBIN="${WORKING_DIR}/bin" go get github.com/golang/protobuf/protoc-gen-go
