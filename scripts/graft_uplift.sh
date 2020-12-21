#!/bin/bash

set -e

TMP="/tmp/graft_msg.txt"
BUGLOG="/tmp/bug_log.txt"

echoerr() { printf "%s\n" "$*" >&2; }
PROG=`basename "$0"`
usage() {
    echoerr "Error: $@"
    echoerr "Usage: $PROG REVSPEC APPROVER"
    exit -1
}

ORIG_REV="$1"
APPROVER="$2"
missing_extensions=0

check_extension() {
    hg config "extensions.$1" 2>&1 >/dev/null || ext_missing=1
    if [ -n "$ext_missing" ]; then
        echoerr "Error: Missing prerequsite mercurial extension: $1"
        missing_extensions=1
        unset ext_missing
    fi
}
check_extension "histedit"
check_extension "evolve"
check_extension "firefoxtree"

if [ $missing_extensions -gt 0 ]; then
    exit -1
fi
if [ -z "$ORIG_REV" ]; then
    usage "Missing REVSPEC."
fi
if [ -z "$APPROVER" ]; then
    usage "Missing approver."
fi

check_reviewer() {
  head -n 1 $TMP | grep -q "r=$APPROVER"
  return $?
}

# Make new commit message
hg log -r "$ORIG_REV" --template "{desc}" > $TMP
# Strip off any existing approver
sed -i -E "1,1s/r\+a=/r=/" $TMP
sed -i -E "1,1s/a=[A-Za-z0-9]+//" $TMP

if check_reviewer; then
  sed -i -e "1,1s/r=$APPROVER/r+a=$APPROVER/" $TMP
else
  sed -i -e "1,1s/$/ a=$APPROVER/" $TMP
fi

sed -i -e "1,1s/ DONTBUILD//" $TMP


# Get bug
BUG=$(head -n 1 $TMP | sed -E 's/[Bb]ug ([0-9]+) .*$/\1/')

hg graft -n -r "$ORIG_REV"
hg graft -r "$ORIG_REV"
hg metaedit -l $TMP

NEW_REV=$(hg id)
echo "$BUG $NEW_REV" >> $BUGLOG
