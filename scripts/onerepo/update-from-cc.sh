#!/bin/bash

set -e

SCRIPT=$(realpath "$0")
HERE=$(dirname "${SCRIPT}")

REPO="single-repo"
CC_REPO="COMM-CENTRAL"
CC_URL="https://hg.mozilla.org/comm-central"

HG="/usr/bin/chg"

cd "${HERE}"
# Script will exit here if either $REPO or $CC_REPO are not present
ls "${REPO}" "${CC_REPO}" > /dev/null

# Pull latest changes from comm-central - but do not update to tip
${HG} -R "${CC_REPO}" up default
${HG} -R "${CC_REPO}" pull "${CC_URL}"
# Get first new revision
FIRST_REV=$(${HG} -R "${CC_REPO}" log -r 'children(.)' --template '{node}\n')
echo "First rev: ${FIRST_REV}"

# Convert setup
${HG} -R "${REPO}" up comm/default
CUR_REV=$(${HG} -R "${REPO}" id -i -r . --debug)
echo "Splice map:"
echo "${FIRST_REV}" "${CUR_REV}" | tee splicemap.txt
echo "Branch map:"
echo "default comm/default" | tee branchmap.txt
echo "File map:"
echo "rename . comm" | tee filemap.txt

# Convert latest changes
${HG} convert --config convert.hg.saverev=True \
	--filemap=filemap.txt \
	--splicemap=splicemap.txt \
	--branchmap=branchmap.txt \
	--config convert.hg.startrev="${FIRST_REV}" \
	"${CC_REPO}" "${REPO}"

# Update to tip of comm/default
${HG} -R "${REPO}" up comm/default

