#!/usr/bin/env bash

# Format shell script files

set -euo pipefail

# format
# usage: format list /pat/to/file.sh
# usage: format write /pat/to/file.sh
# usage: format diff /pat/to/file.sh

mode="${1:-list}" # accepted: list,write,diff
filename="$2"

mime_type="$(file --mime-type --brief "$filename")"

if test "$mime_type" = "text/x-shellscript"; then
    SHFMT_OPTIONS="--indent 4 --case-indent --binary-next-line"
    shfmt --${mode} $SHFMT_OPTIONS "$filename"
fi
