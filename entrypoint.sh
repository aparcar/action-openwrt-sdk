#!/bin/sh

set -e

FEEDNAME="${FEED_NAME:-action}"
IGNORE_ERRORS="${IGNORE_ERRORS:-n m}"

cd /home/build/openwrt/

cp feeds.conf.default feeds.conf
echo "src-link $FEEDNAME $GITHUB_WORKSPACE/" >> feeds.conf

#shellcheck disable=SC2153
for EXTRA_FEED in $EXTRA_FEEDS; do
	echo "$EXTRA_FEED" | tr '|' ' ' >> feeds.conf
done

./scripts/feeds update -a
./scripts/feeds install -d y -p "$FEEDNAME" -a -f

make defconfig
make \
	CONFIG_SIGNED_PACKAGES="$SIGNED_PACKAGES" \
	IGNORE_ERRORS="$IGNORE_ERRORS" \
	-j "$(nproc)"

mv bin/ "$GITHUB_WORKSPACE/"
