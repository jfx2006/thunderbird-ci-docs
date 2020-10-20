title: Release Tools
slug: index
date: 2020-09-18 04:59:25 UTC
type: text
author: :rjl

# Uplift Bug Queries

When an uplift is requested, it should show up in either the *Requested*
or *Approved* lists.

**If you have requested an uplift and you do not see it in the Requested
or Approved lists, contact one of the release drivers via Matrix or 
NeedInfo in Bugzilla to make sure it gets considered for inclusion.**

## Requested Uplifts

Bugs that have *approval-comm-beta?* or *approval-comm-esrXX?* flags set. These
bugs are under consideration for an upcoming beta or release.  

* [Beta Uplifts Requested](buglist/?channel=beta&query=uplifts-requested)
* [Release Uplifts Requested](buglist/?channel=release&query=uplifts-requested)

## Approved Uplifts

The release manager will review and approve uplift requests on a regular basis.
The *approval-comm-beta+* or *approval-comm-esrXX+* flag will be set and the
bug will be listed in one of these lists.

* [Beta Uplifts Approved](buglist/?channel=beta&query=uplifts-approved)
* [Release Uplifts Approved](buglist/?channel=release&query=uplifts-approved)

## Other useful queries

* [Beta 1 Fixed](buglist/?channel=beta&query=beta-1-fixed) lists a reduced set of
    bugs that were fixed during the last development milestone, but not uplifted.
    It's used as a starting point for writing the release notes for a beta 1
    release.
