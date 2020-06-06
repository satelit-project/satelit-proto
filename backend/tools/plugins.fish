#!/usr/bin/env fish

set WORK_DIR (dirname (realpath (status -f)))

# Prints info message
function info -a msg
  set_color green
  printf "$msg\n" >&2
  set_color normal
end

# Prints error message and exits
function fatal -a msg
  set_color red
  printf "$msg\n" >&2
  exit 1
end

# Checks if current system has all required dependencies
function check_system
  if ! type -q go
    fatal "Go is not installed"
  end

  if ! type -q cargo
    fatal "Cargo is not installed"
  end

  if ! type -q curl
    fatal "Curl is not installed"
  end
end

# Installs project dependencies
function install_deps
  info "Installing protoc-gen-rust"
  install_gen_rust

  info "Installing protoc-gen-go"
  set -x GO111MODULE on
  set -x GOBIN $WORK_DIR/bin
  install_gen_go
end

# Installs rust protoc plugin
function install_gen_rust
  cargo install -q protoc-rust \
      --git https://github.com/satelit-project/protoc-rust \
      --tag (latest_tag satelit-project/protoc-rust) \
      --root $WORK_DIR \
      --force
end

# Installs go protoc plugin
function install_gen_go
  go get github.com/golang/protobuf/protoc-gen-go
end

# Prints latest release tag of a GitHub repository
# Args:
#   $slug - repository slug
function latest_tag -a slug
  curl -s https://api.github.com/repos/$slug/releases/latest \
      | grep "tag_name" \
      | cut -d : -f 2,3 \
      | string trim -c ' ,"'
end

function main
  check_system

  info "Installing required plugins"
  install_deps
end

main $argv
