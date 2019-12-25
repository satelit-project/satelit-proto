#!/usr/bin/env fish

set WORK_DIR (dirname (realpath (status -f)))


# Prints help message
function print_usage
  echo "Install or update project dependencies

Usage: deps.fish <COMMAND>

COMMAND:
  install installs project dependencies
  update  updates project dependencies" >&2
end

# Prints warning message
function warn -a msg
  set_color yellow
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
    fatal "Warning: Go is not installed"
  end

  if ! type -q cargo
    fatal "Cargo is not installed"
  end

  if ! type -q curl
    fatal "Curl is not installed"
  end
end

# Installs project dependencies
# Args:
#   $forced - wherever to re-install/update dependencies
function install_deps -a forced
  install_protogen $forced
  install_gen_rust $forced

  set -x GO111MODULE on
  set -x GOBIN $WORK_DIR/bin
  install_gen_go $forced
end

# Installs protogen tool
# Args:
#   $forced - wherever to re-install/update protogen
function install_protogen -a forced
  if type -q protogen && test -z "$forced"
    return
  end

  echo "Installing protogen" >&2
  cargo install -q protogen \
      --git https://github.com/satelit-project/protogen \
      --tag (latest_tag satelit-project/protogen) \
      --force

  if ! type -q prototool
    warn "Cargo's bin directory is not in path. Symlinking to /usr/local/bin"
    if test ! -d /usr/local/bin
      fatal "/usr/local/bin does not exists"
    end

    if test ! -d $HOME/.cargo/bin
      fatal "Cargo's bin directory not found"
    end

    pushd /usr/local/bin
    rm -r protogen
    ln -s $HOME/.cargo/bin/protogen protogen
    popd
  end
end

# Installs rust protoc plugin
# Args:
#   $forced - wherever to re-install/update plugin
function install_gen_rust -a forced
  if test -f $WORK_DIR/bin/protoc-gen-rust -a -z "$forced"
    return
  end

  echo "Installing protoc-gen-rust" >&2
  cargo install -q protoc-rust \
      --git https://github.com/satelit-project/protoc-rust \
      --tag (latest_tag satelit-project/protoc-rust) \
      --root $WORK_DIR \
      --force

end

# Installs go protoc plugin
# Args:
#   $forced - wherever to re-install/update plugin
function install_gen_go -a forced
  if test -f $WORK_DIR/bin/protoc-gen-go -a -z "$forced"
    return
  end

  echo "Installing protoc-gen-go" >&2
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
  set cmd $argv[1]

  switch "$cmd"
    case install
      install_deps
    case update
      install_deps "forced"
    case --help -h
      print_usage
    case "*"
      fatal "Unknown command $cmd\nTry '--help' for help"
  end
end

main $argv
