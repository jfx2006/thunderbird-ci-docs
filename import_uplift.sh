#!/bin/bash

set -e

PATCHFILE="$1"
APPROVER="$2"


check_reviewer() {
  grep -E '^[Bb]ug ' $PATCHFILE | grep -q "r=$APPROVER"
  return $?
}

# Strip off any existing approver
sed -i -E "1,7s/r\+a=/r=/" $PATCHFILE
sed -i -E "1,7s/a=[A-Za-z0-9]+//" $PATCHFILE

if check_reviewer; then
  sed -i -e "1,7s/r=$APPROVER/r+a=$APPROVER/" $PATCHFILE
else
  sed -i -e "1,7s/\(^[Bb]ug .*\)$/\1 a=$APPROVER/" $PATCHFILE
fi

sed -i -e "1,7s/ DONTBUILD//" $PATCHFILE

hg import --partial $PATCHFILE
