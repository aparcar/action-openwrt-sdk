#!/bin/sh

set -ex

FEEDNAME="${FEEDNAME:-action}"
FEEDPATH="${FEEDPATH:-.}"
IGNORE_ERRORS="${IGNORE_ERRORS:-n m}"

cd /home/build/openwrt/

FEEDNAME_SANI="$(echo $FEEDNAME | tr '-' '_')"
mv feeds.conf.default feeds.conf
echo "src-link $FEEDNAME_SANI $GITHUB_WORKSPACE/$FEEDPATH" >> feeds.conf

echo -e "\n---- feeds.conf --- \n"
cat feeds.conf
echo -e "\n---- feeds.conf --- \n"

./scripts/feeds update -a
./scripts/feeds install -d y -p "$FEEDNAME" -a -f

make defconfig

PACKAGES_FEED="$(./scripts/feeds list -r $FEEDNAME | awk '{ print $1 }')"
PACKAGES="${PACKAGES:-$PACKAGES_FEED}"

echo "Building $PACKAGES"

for PACKAGE in $PACKAGES; do
	echo "Building $PACKAGE"
        make "package/$PACKAGE/compile" \
                CONFIG_SIGNED_PACKAGES="$SIGNED_PACKAGES" \
                IGNORE_ERRORS="$IGNORE_ERRORS" \
                -j "$(nproc)"
done
