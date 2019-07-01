# satelit-proto

Proto files for all **Satelit** projects and sources generator.

## Dependencies

- Protobuf (see [prototool.yaml](prototool.yaml) for version)
- Ruby (see [.ruby-version](.ruby-version) for version)
- Rust (latest `stable` and `nightly`)

Don't forget to `bundle install`

You may optionally install Uber's [`prototool`](https://github.com/uber/prototool) tool to compile and lint proto files locally.

## Generators

To generate sources for a specific project run `protogen.rb`:

`protogen/protogen.rb --help`

## TODO

- Enforce `protoc` version
- Compile and lint on CI
- Enforce lints on CI to ensure all project uses latest protos 
