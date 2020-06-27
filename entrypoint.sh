#!/bin/sh

set -e

FEEDNAME="${FEED_NAME:-action}"
IGNORE_ERRORS="${IGNORE_ERRORS:-n m}"

cd /home/build/openwrt/

echo "src-link $FEEDNAME $GITHUB_WORKSPACE/" >> feeds.conf.default


./scripts/feeds update -a
./scripts/feeds install -d y -p "$FEEDNAME" -a -f

make defconfig
make \
	CONFIG_SIGNED_PACKAGES="$SIGNED_PACKAGES" \
	IGNORE_ERRORS="$IGNORE_ERRORS" \
	-j "$(nproc)"

mv bin/ "$GITHUB_WORKSPACE/"
