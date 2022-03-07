#!/bin/sh
# Copyright 2019 the rust-swc authors. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.

set -e

if ! command -pVv tar >/dev/null; then
	echo "Error: tar is required to install rust-swc." 1>&2
	exit 1
fi

if [ "$OS" = "Windows_NT" ]; then
	target="windows"
else
	case $(uname -sm) in
	"Darwin x86_64") target="macos" ;;
	"Darwin arm64") target="macos" ;;
	*) target="linux" ;;
	esac
fi

if [ $# -eq 0 ]; then
	deno_uri="https://github.com/mynane/rust-swc/releases/latest/download/rust-swc-${target}.tar.gz"
else
	deno_uri="https://github.com/mynane/rust-swc/releases/download/${1}/rust-swc-${target}.tar.gz"
fi

echo $deno_uri

deno_install="${DENO_INSTALL:-$HOME/.rust-swc}"

bin_dir="$deno_install"
exe="$bin_dir/rust-swc"

if [ ! -d "$bin_dir" ]; then
	mkdir -p "$bin_dir"
fi
curl --fail --location --progress-bar --output "$exe.tar.gz" "$deno_uri"
tar -zxvf "$exe.tar.gz" -C "$bin_dir"
chmod +x "$exe"
rm "$exe.tar.gz"

echo "rust-swc was installed successfully to $exe"
if command -v rust-swc >/dev/null; then
	echo "Run 'rust-swc --help' to get started"
else
	case $SHELL in
	/bin/zsh) shell_profile=".zshrc" ;;
	*) shell_profile=".bash_profile" ;;
	esac
	echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
	echo "  export RUST_SWC_INSTALL=\"$deno_install\""
	echo "  export PATH=\"\$RUST_SWC_INSTALL:\$PATH\""
	echo "Run '$exe --help' to get started"
fi
