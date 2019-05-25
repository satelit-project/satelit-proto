use clap::{crate_authors, crate_description, crate_version};
use clap::{App, Arg};
use prost_build::compile_protos;

use std::error::Error;
use std::path::Path;

fn main() -> Result<(), String> {
    let matches = build_app().get_matches();
    let protos: Vec<&str> = matches.values_of("proto").unwrap().collect();
    let include = matches.value_of("include-path").unwrap();

    match compile_protos(&protos, &[include]) {
        Ok(_) => {
            eprintln!(
                "Compiled protos can be found at: {}",
                option_env!("OUT_DIR").unwrap()
            );
            Ok(())
        }
        Err(e) => Err(e.description().to_owned()),
    }
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
