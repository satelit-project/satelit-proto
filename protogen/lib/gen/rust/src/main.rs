use clap::{crate_authors, crate_description, crate_version};
use clap::{App, Arg};
use prost_build::Config;

use std::error::Error;
use std::path::Path;

fn main() -> Result<(), String> {
    let matches = build_app().get_matches();
    let protos: Vec<&str> = matches.values_of("proto").unwrap().collect();
    let include = matches.value_of("include-path").unwrap();
    let with_serde: bool = matches.value_of("with-serde").unwrap().parse().unwrap();

    let mut config = Config::new();
    if with_serde == true {
        config.type_attribute(".", "#[derive(serde::Serialize)]");
        config.type_attribute(".", "#[derive(serde::Deserialize)]");
    }

    config.compile_protos(&protos, &[include]).map_err(|e| e.description().to_owned())
}

/// Builds configured Clap's `App` instance
fn build_app() -> App<'static, 'static> {
    App::new("protogen")
        .about(crate_description!())
        .author(crate_authors!())
        .version(crate_version!())
        .arg(
            Arg::with_name("proto")
                .long("proto")
                .help("A proto file to compile")
                .takes_value(true)
                .number_of_values(1)
                .multiple(true)
                .required(true)
                .validator(check_proto_file),
        )
        .arg(
            Arg::with_name("include-path")
                .long("include-path")
                .help("Reference path for proto inclusion")
                .takes_value(true)
                .number_of_values(1)
                .required(true)
                .validator(check_include_path),
        )
        .arg(
            Arg::with_name("with-serde")
                .long("with-serde")
                .help("Derives Serde's Serialize and Deserialize traits")
                .takes_value(true)
                .number_of_values(1)
                .default_value("false")
                .possible_value("true")
                .possible_value("false")
        )
}

/// Checks that provided path is a directory
fn check_include_path(path: String) -> Result<(), String> {
    let p = Path::new(&path);

    if !p.is_dir() {
        let msg = format!("Include path expected dir, found: {}", path);
        return Err(msg);
    }

    Ok(())
}

/// Checks that provided path is a file with '.proto' extension
fn check_proto_file(file: String) -> Result<(), String> {
    let f = Path::new(&file);
    let make_err = || format!("Expected proto file, found: {}", file);

    if !f.is_file() {
        return Err(make_err());
    }

    let utf8_ext = f.extension().and_then(|e| e.to_str());
    if !utf8_ext.eq(&Some("proto")) {
        return Err(make_err());
    }

    Ok(())
}
