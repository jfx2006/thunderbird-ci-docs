#!/bin/bash

# shellcheck source=libjfxbash
. libjfxbash   # for runit

rm -rf /tmp/browser /tmp/mail /tmp/browser_unified /tmp/mail_unified

mkdir /tmp/browser_unified /tmp/mail_unified


MOZCONFIG=mozconfig.empty MOZ_OBJDIR=/tmp/browser ./mach configure --enable-application=browser
MOZCONFIG=mozconfig.empty MOZ_OBJDIR=/tmp/mail ./mach configure --enable-application=comm/mail

find /tmp/browser -name \*Unified\* -exec cp '{}' /tmp/browser_unified/ \;
find /tmp/mail -name \*Unified\* -exec cp '{}' /tmp/mail_unified/ \;

runit meld /tmp/browser_unified /tmp/mail_unified

