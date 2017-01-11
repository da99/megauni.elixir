#!/usr/bin/env mksh
# -*- mksh -*-
#
set -u -e -o pipefail

IFS=$'\n'

for FILE in $(find Public/ -type f \( -name '*.js' -or -name "*.css" -or -name "*.gif" -or -name "*.jpg" -or -name "*.styl" \))
do
  echo "$FILE" "$(stat -c %Y "$f")"
done


