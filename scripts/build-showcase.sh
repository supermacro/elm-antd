#!/usr/bin/env bash

set -e

cd ./showcase

npm run build

echo "/* /index.html 200" > ./dist/_redirects


