#!/usr/bin/env bash

tmpfile=$(mktemp)
exec 3>"$tmpfile"
rm "$tmpfile"

(<"$1" sed '/<!-- TOC -->/q'

(for fname in `find * -name "*.md"`; do
    echo \
"* "\
`git log --follow --format=%ai $fname | tail -n1 | cut -f1 -d" "`\
" "\
"["`<$fname grep -oP "^# \K(.*)"`"]"\
"(${fname/%.md/.html})"\
""
done) |sort -r

<"$1" sed -n 'H; /<!-- TOC -->/h; ${g;p;}')>$tmpfile

mv "$tmpfile" "$1"
