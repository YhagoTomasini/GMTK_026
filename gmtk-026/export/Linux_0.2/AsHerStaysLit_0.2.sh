#!/bin/sh
printf '\033c\033]0;%s\a' GMTK_026
base_path="$(dirname "$(realpath "$0")")"
"$base_path/AsHerStaysLit_0.2.x86_64" "$@"
