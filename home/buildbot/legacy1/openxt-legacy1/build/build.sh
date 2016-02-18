#!/bin/bash -ex

BUILDID=$1
BRANCH=$2	# Unused for now

umask 0022
cd build
git clone file:///home/buildbot/legacy1/openxt-legacy1/build/git/openxt.git
cd openxt
git checkout $BRANCH
cp -r ../../certs .
#mkdir wintools
#rsync -r buildbot@192.168.0.10:/home/build/win/$BRANCH/ wintools/
#WINTOOLS="`pwd`/wintools"
#WINTOOLS_ID="`grep -o '[0-9]*' wintools/BUILD_ID`"
mv /tmp/git_heads_$BUILDID git_heads
cp example-config .config
cat <<EOF >> .config
BRANCH=$BRANCH
NAME_SITE="oxt"
OPENXT_MIRROR="http://mirror.openxt.org"
OE_TARBALL_MIRROR="http://mirror.openxt.org"
OPENXT_GIT_MIRROR="/home/buildbot/legacy1/openxt-legacy1/build/git"
OPENXT_GIT_PROTOCOL="file"
REPO_PROD_CACERT="/home/buildbot/legacy1/openxt-legacy1/build/certs/prod-cacert.pem"
REPO_DEV_CACERT="/home/buildbot/legacy1/openxt-legacy1/build/certs/dev-cacert.pem"
REPO_DEV_SIGNING_CERT="/home/buildbot/legacy1/openxt-legacy1/build/certs/dev-cacert.pem"
REPO_DEV_SIGNING_KEY="/home/buildbot/legacy1/openxt-legacy1/build/certs/dev-cakey.pem"
WIN_BUILD_OUTPUT="$WINTOOLS"
XC_TOOLS_BUILD=$WINTOOLS_ID
SYNC_CACHE_OE=192.168.0.10:/home/build/oe
BUILD_RSYNC_DESTINATION=192.168.0.10:/home/build/builds
NETBOOT_HTTP_URL=http://192.99.200.146/builds
EOF
#./do_build.sh -i $BUILDID -s setupoe,sync_cache
./do_build.sh -i $BUILDID | tee build.log
ret=${PIPESTATUS[0]}
cd -
cd -

exit $ret
