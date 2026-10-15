#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y curl unzip

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

curl -fsSL https://dl.google.com/android/repository/platform-tools-latest-linux.zip \
  -o "$tmp_dir/platform-tools.zip"
unzip -q "$tmp_dir/platform-tools.zip" -d "$tmp_dir"

sudo install -d /usr/local/lib/android-sdk/platform-tools
sudo cp -a "$tmp_dir/platform-tools/." /usr/local/lib/android-sdk/platform-tools/
sudo ln -sf /usr/local/lib/android-sdk/platform-tools/adb /usr/local/bin/adb
sudo ln -sf /usr/local/lib/android-sdk/platform-tools/fastboot /usr/local/bin/fastboot
