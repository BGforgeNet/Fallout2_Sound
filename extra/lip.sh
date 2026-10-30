#!/bin/bash
# Regenerates every Russian lip-sync file from its sound and its line, with ipsdoc (on PATH). A line comes from
# extra/lip/russian.msg where the recording says other words than UPU's dialog shows, else from UPU's dialog.
# Usage: extra/lip.sh <UPU's data/text/russian/dialog>

set -xeu -o pipefail

dialog="$1"
speech=translations/russian/sound/speech

# The sounds that have lip files: the narrator's have none.
find "$speech" -iname '*.lip' | while read -r lip; do
  echo "${lip%.*}".[aA][cC][mM]
done | xargs ipsdoc lip --lang ru --msg extra/lip/russian.msg --msg "$dialog"
