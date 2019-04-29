#!/bin/sh
# jwalk: a streaming JSON parser for Unix
# https://jwalk.sh
#
# Copyright (c) 2019 Sam Stephenson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -e
[ -z "$JWALK_DEBUG" ] || set -x

realpath_dirname() {
  path="$1"
  while :; do
    case "$path" in
      */* ) cd -P "${path%/*}" ;;
    esac
    name="${path##*/}"
    if [ -L "$name" ]; then
      link="$(ls -l "$name")"
      path="${link##* $name -> }"
    else
      break
    fi
  done
  pwd
}

export JWALK_LIB="$(realpath_dirname "$0")"
export TMPDIR="${TMPDIR:-/tmp}"

if [ -z "$JWALK_CMD" ]; then
  JWALK_CMD=walk
fi

script="$JWALK_LIB/jwalk/${JWALK_CMD##*/}.sh"

if [ -r "$script" ]; then
  unset JWALK_CMD
  exec sh "$script" "$@"
else
  echo "jwalk: can't find script file: $script" >&2
  exit 127
fi
