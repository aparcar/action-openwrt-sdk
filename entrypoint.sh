#!/bin/sh

set -e

FEEDNAME="${FEED_NAME:-action}"
IGNORE_ERRORS="${IGNORE_ERRORS:-n m}"
BIN_DIR="{BIN_DIR:-/github/workspace/bin/}"

cd /home/build/openwrt/

echo "src-link $FEEDNAME $GITHUB_WORKSPACE/" >> feeds.conf.default


./scripts/feeds update -a
./scripts/feeds install -d y -p "$FEEDNAME" -a -f

make defconfig
make \
	BIN_DIR="$BIN_DIR" \
	CONFIG_SIGNED_PACKAGES="$SIGNED_PACKAGES" \
	IGNORE_ERRORS="$IGNORE_ERRORS" \
	-j "$(nproc)"
