# satelit-proto

Proto files for all **Satelit** projects and sources generator.

## Dependencies

- Rust (latest _stable_)
- Go (_1.12+_)
- [`prototool`](https://github.com/uber/prototool)

## Usage

- Install Protobuf by running `prototool cache update`
- Install `protoc` plugins by running `./plugins/install`

See `prototool --help` for what you can do.

For example, if you want to regenerate protos, simply run `prototool generate`
