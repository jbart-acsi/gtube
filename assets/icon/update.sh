#!/usr/bin/env bash
# Makes the program's icons from gtube-icon.svg: gtube.ico, built into the Windows program, and
# gtube-icon.png with gtube-icon.h, the window icon on other systems.
set -euo pipefail
here=$(dirname "$0")
command -v magick >/dev/null || { echo "error: ImageMagick's magick is needed to make the icons" >&2; exit 1; }
magick -background none -density 384 "$here/gtube-icon.svg" -resize 256x256 \
  -define icon:auto-resize=256,128,64,48,32,24,16 -strip "$here/gtube.ico"
magick -background none -density 384 "$here/gtube-icon.svg" -resize 128x128 -strip "$here/gtube-icon.png"
# As a C array, since Zig's build cannot track a file that #embed reads.
{
  echo "// Made by assets/icon/update.sh from gtube-icon.png."
  echo "static const unsigned char icon_png[] = {"
  od -An -v -tu1 "$here/gtube-icon.png" | awk '{ s = ""; for (i = 1; i <= NF; i++) s = s $i ","; print "    " s }'
  echo "};"
} > "$here/gtube-icon.h"
