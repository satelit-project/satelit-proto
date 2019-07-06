#!/usr/bin/env bash

RUST_PLUGIN_GIT="https://github.com/satelit-project/protoc-rust.git"
RUST_PLUGIN_BRANCH="release"
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

cargo install \
  --git "${RUST_PLUGIN_GIT}" \
  --branch "${RUST_PLUGIN_BRANCH}" \
  --root "${WORKING_DIR}" \
  --force

cd "${TMP_DIR}" || exit
GO111MODULE=on GOBIN="${WORKING_DIR}/bin" go get github.com/golang/protobuf/protoc-gen-go
