#!/bin/bash

set -xeu -o pipefail

DAT3_VERSION="v0.11.1"
DAT3_URL="https://github.com/BGforgeNet/dat3/releases/download/${DAT3_VERSION}/dat3"
# zlib level for every .dat: 6 packs in under half the time of 9, for archives about 1% larger.
DAT3_LEVEL=6
MOD_NAME="upu"

bin_dir="$(realpath extra/bin)"
dat3="$bin_dir/dat3"
trans_dir="$(realpath translations)"

mkdir -p "$bin_dir"

if [[ ! -f "$dat3" ]]; then
  # Through a temporary name, so an interrupted download is never taken for a complete one.
  wget -nv -O "$dat3.part" "$DAT3_URL"
  mv "$dat3.part" "$dat3"
  chmod +x "$dat3"
fi

for lang_dir in "$trans_dir"/*/; do
  lang="$(basename "$lang_dir")"
  dat="$trans_dir/${MOD_NAME}_${lang}_sound.dat"
  # dat3 adds to an existing archive, so start from none.
  rm -f "$dat"
  "$dat3" a -c "$DAT3_LEVEL" -C "$lang_dir" "$dat" '*'
done
