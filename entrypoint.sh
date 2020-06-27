#!/bin/sh

set -e

echo "src-link action $PWD/" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -d y -p action -a
make defconfig
make -j "$(nproc)"
