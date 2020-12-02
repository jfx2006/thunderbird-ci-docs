#!/bin/bash

set -e

SCRIPT=$(realpath "$0")
HERE=$(dirname "${SCRIPT}")

REPO="single-repo"
MC_URL="https://hg.mozilla.org/mozilla-central"

HG="hg -R ${REPO}"

cd "${HERE}"
# Update to default (m-c) branch
${HG} up default
# Pull latest m-c changes
${HG} pull -b default -u "${MC_URL}"
MC_REV=$(${HG} id)
# Switch to comm/default branch
${HG} up comm/default
# Merge and commit if successful
${HG} merge default && ${HG} commit -m "Merge mozilla-central@${MC_REV} to comm/default. a=merge"
