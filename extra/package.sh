#!/bin/bash

set -xeu -o pipefail

bin_dir="$(realpath extra/bin)"
dat2a="wine $bin_dir/dat2.exe a -1"
trans_dir="$(realpath translations)"
file_list="../file.list"
mod_name="upu_sound"
short_sha="$(git rev-parse --short HEAD)"
# defaults, local build or github non-tagged
version="git$short_sha"

if [[ ! -z "${GITHUB_REF-}" ]]; then # github build
  if echo "$GITHUB_REF" | grep "refs/tags"; then # tagged
    version="$(echo $GITHUB_REF | sed 's|refs\/tags\/v||')"
    version
  fi
fi

# data
dat="$mod_name.dat"

cd "$trans_dir"
rm -f file.list
for lang in $(ls); do
  cd "$lang"
  dat="${mod_name}_${lang}_${version}.dat"
  # I don't know how to pack recursively
  find . -type f | sed -e 's|^\.\/||' -e 's|\/|\\|g' | sort > "$file_list" # replace slashes with backslashes
  $dat2a "../$dat" @"$file_list" 2>&1 | grep -v "wine: Read access denied for device" # wine pollutes the log
  cd ..
done
