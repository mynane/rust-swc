#![allow(unused)]

use anyhow::{Context, Result};
use clap::Parser;
use log::{info, warn};

#[derive(Parser)]
struct Cli {
    pattern: String,

    #[clap(parse(from_os_str))]
    path: std::path::PathBuf,
}

#[derive(Debug)]
struct CustomError(String);

fn find_matches(content: &str, pattern: &str, mut writer: impl std::io::Write) {
    for line in content.lines() {
        if line.contains(pattern) {
            writeln!(writer, "{}", line);
        }
    }
}

fn main() -> Result<()> {
    let args = Cli::parse();
    let content = std::fs::read_to_string(&args.path)
        .with_context(|| format!("counld not read file `{:?}`", &args.path))?;

    find_matches(&content, &args.pattern, &mut std::io::stdout());

    Ok(())
}
