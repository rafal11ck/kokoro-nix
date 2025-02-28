#!/usr/bin/env bash

set -xe

[[ -n "$1" ]] || exit

cd "$(dirname "$RENPY_TTS_COMMAND")"
notify-send "$1"
uv run ./kokoro-read.py "$1"
