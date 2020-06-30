#!/usr/bin/env bash

set -e

curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz

gunzip elm.gz

chmod +x ./elm

mv elm /usr/local/bin/
