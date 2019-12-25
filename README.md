# satelit-proto

Proto files for all **Satelit** projects and sources generator.

## Dependencies

- Rust stable
- Go 1.13
- Fish

### Plugins

Required protoc plugins and [`protogen`](https://github.com/satelit-project/protogen) can be installed by running [`tools/deps.fish`](tools/deps.fish).

## Usage

Clone [satelit-import](https://github.com/satelit-project/satelit-import), [satelit-scheduler](https://github.com/satelit-project/satelit-scheduler) and [satelit-scraper](https://github.com/satelit-project/satelit-scraper) to parent (`..`) directory and run `protogen`.
