#!/usr/bin/env fish
#
# Downloads all required protoc plugins and installs them into ./bin directory.

set DIR (dirname (realpath (status --current-filename)))
set BIN_DIR "$DIR/bin"

set SWIFT_PLUGIN_VERSION "1.0.0-alpha.12"

# Prints info message
function info -a msg
  set_color green
  printf "$msg\n" >&2
  set_color normal
end

# Prints error message
function err -a msg
  set_color red
  printf "$msg\n" >&2
  set_color normal
end

# Prints error message and exits
function fatal -a msg
  err $msg
  exit 1
end

# Checks if current system has all required dependencies
function check_system
  if ! type -q swift
    fatal "swift is not installed"
  end

  if ! type -q tar
    fatal "tar is not installed"
  end

  if ! type -q curl
    fatal "curl is not installed"
  end

  if ! type -q make
    fatal "make is not installed"
  end
end

# Downloads and extracts a tar.gz archive.
#
# Args:
#   $url - URL of the archive to download.
#   $name - name of the archive.
function download_and_extract -a url -a name
  curl -o $name -L $url
  tar -xvf $name
end

# Downloads required plugins for Swift code generation.
function get_swift_plugins
  set -l tmp (mktemp -d)
  set -l archive "$SWIFT_PLUGIN_VERSION.tar.gz"
  set -l url "https://github.com/grpc/grpc-swift/archive/$archive"
  set -l extracted "grpc-swift-$SWIFT_PLUGIN_VERSION"

  pushd $tmp
  if download_and_extract $url $archive
    pushd $extracted
    if make plugins
      mv protoc-gen* $BIN_DIR
    else
      err "Failed to build plugins"
    end
    popd
  else
    err "Failed to download plugin sources"
  end
  popd

  rm -rf $tmp
end

function main
  check_system

  rm -rf $BIN_DIR
  mkdir -p $BIN_DIR

  info "Installing Swift protoc plugins"
  get_swift_plugins
end

main $argv
