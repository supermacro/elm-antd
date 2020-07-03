#!/usr/bin/env bash

set -e

cd ./showcase

npm run build

echo "/* /" > ./dist/_redirects


