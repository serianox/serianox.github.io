#!/usr/bin/env bash

echo "# Table of Contents"

(for fname in `find * -name "*.md"`; do
    echo \
"* "\
`git log --follow --format=%ai $fname | head -n1 | cut -f1 -d" "`\
" "\
"["`<$fname grep -oP "^# \K(.*)"`"]"\
"(${fname/%.md/.html})"\
""
done) |sort -r
