#!/bin/bash

set -e

TMP="/tmp/graft_msg.txt"
BUGLOG="/tmp/bug_log.txt"

ORIG_REV="$1"
APPROVER="$2"


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
