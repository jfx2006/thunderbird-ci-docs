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

## Thunderbird Beta

* [Uplifts Requested](buglist/?channel=beta&query=uplifts-requested)
    - Bugs under consideration for an upcoming beta.
* [Uplifts Approved](buglist/?channel=beta&query=uplifts-approved)
    - Bugs approved for the next beta.
* [Beta 1 Fixed](buglist/?channel=beta&query=beta-1-fixed)
    - Lists a reduced set of bugs that were fixed during the last development
      milestone, but not uplifted. It's used as a starting point for writing
      the release notes for a beta 1 release.
* [Next Beta 1 Fixed](buglist/?channel=beta&query=beta-1-next)
    - Same list as above, but for the next beta 1. This one works prior to
      merging on merge day to facilitate writing release notes before the merges
      happen.
* [Affected](buglist/?channel=beta&query=affected)
    - Bugs affecting Beta that are fixed in Nightly.
* [Missed Uplifts](buglist/?channel=beta&query=missed)
    - Bugs approved for Beta uplift that were missed

<!--
## Thunderbird 102.x

* [Uplifts Requested](buglist/?channel=release102&query=uplifts-requested)
* [Uplifts Approved](buglist/?channel=release102&query=uplifts-approved)
* [Affected](buglist/?channel=release102&query=affected)
* [Missed Uplifts](buglist/?channel=release102&query=missed)
-->

## Thunderbird 91.x

* [Uplifts Requested](buglist/?channel=release91&query=uplifts-requested)
* [Uplifts Approved](buglist/?channel=release91&query=uplifts-approved)
* [Affected](buglist/?channel=release91&query=affected)
* [Missed Uplifts](buglist/?channel=release91&query=missed)

## Bugherder

* [Bugherder](https://bugherder.mozilla.org)
