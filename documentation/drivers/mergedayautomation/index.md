title: Merge Day Automation
slug: mergedayautomation
date: 2020-12-11 20:05:37 UTC
type: text

# Overview

Merge day happens at 4-week intervals (most of the time), and follows the
Firefox Rapid Release schedule. This document only covers merge activities,
not the related releases that happen on the same day.

On Merge day:

* Communication about the merges
* Merge comm-central to comm-beta
* Tag and bump comm-central versions
* Update ShipIt nightly version

# Communication

Send emails to the thunderbird-drivers list with information about the merge
and status updates. Templates are [here](../mergeday_email_templates)

# Steps

Make sure you are logged into Treeherder. You will need to have
"thunderbird-releng" permissions, which are set in
[Taskcluster](https://hg.mozilla.org/ci/ci-configuration/file/1d37a3cf95a4e272eeaa7a910193e58ff2028646/grants.yml#l2415).

Close the trees in [TreeStatus](https://treestatus.mozilla-releng.net/).

## comm-central -> comm-beta

1. In Treeherder, select the comm-central repository
1. Select the Decision task of the latest push
1. Click the down arrow in the top right corner and select "Custom push action..."
1. Choose "merge-automation"
1. Update the payload & trigger (note that with `force-dry-run` set to `true`, the value of
   `push` is ignored)
   
```yaml
behavior: comm-central-to-beta
force-dry-run: true
push: true
```

If the dry-run is successful, run it again, this time setting `force-dry-run` to
`false`.

### Update .gecko_rev.yml

The automation will pin to mozilla-beta@default. This will build. A specific
revision needs to be pinned manually before releasing beta 1.

### Suite version

The automation will change 2.XXa1 to 2.XXb1.

## Bump Daily version

1. Select comm-central repository in Treeherder and select the "merge-automation"
   custom action as above
1. Update the payload & trigger
   
```yaml
behavior: comm-bump-central
force-dry-run: true
push: true
```

If the dry-run is successful, run again without `force-dry-run`.

### Manual step: bump suite version

This requires a local clone of comm-central. Run this after the above pushes to
comm-central.

1. Edit suite/config/version.txt and version_display.txt Increment the minor
   number in each by 1. The files should be identical when complete.
1. Commit: "No bug - Bump suite versions. r=me a=merge CLOSED TREE DONTBUILD"
1. Push to comm-central.

<!-- ## Bump Release version

**DO NOT RUN THIS**

1. Select comm-esr78 repository and select the "merge-automation" custom action
1. Update the payload & trigger
   
```yaml
behavior: comm-bump-esr
force-dry-run: true
push: true
```

_Note_: This is currently set to bump comm-esr78. When there are two release
versions (such as 78.x and 91.x) this will need to run twice, overriding
`to-branch` and `to-repo` on one of the runs.

```yaml
behavior: comm-bump-esr
force-dry-run: true
push: true
to-branch: comm-esr78
to-repo: https://hg.mozilla.org/releases/comm-esr78
```
-->

# Update Ship-It

Mozilla's [Ship-It](https://github.com/mozilla-releng/shipit) tool must be
updated with the new Daily version number.

## Changes

* Modify `api/src/shipit_api/common/config.py` and update the
  `LATEST_THUNDERBIRD_NIGHTLY_VERSION` variable to be the new version of
  comm-central.
* Create a pull request with the changes. [Example](https://github.com/mozilla-releng/shipit/pull/1004)
  * In the pull request, @mention one of the Ship-It code owners to make sure
    the request is seen. You can also say something in #releaseduty on Matrix.

If you are not familiar with Github's Fork & Pull workflow model,
see [here](https://reflectoring.io/github-fork-and-pull/) for an introduction.

# Test runs with a real push

You can push to `try-comm-central` with to-repo/from-repo to test that pushing
actually works, though it really shouldn't break now that it's working.

# to-repo, from-repo, to-branch, from-branch?

It's kind of confusing...

* to-branch and from-branch are Firefoxtree "branch" names, and correspond
  to "branches" of code for release purposes
* **to-repo** in a merge context is the URL of the destination repository you
  want to merge into. So for comm-central-to-beta, that's the _full URL_ (https)
  of comm-beta on hg.m.o.
* **from-repo** then is the repo URL you are merging into to-repo. So, comm-central's
  URL.
* **VERY IMPORTANT** Merge day work will push to both `to-repo` and `from-repo`.
  So if you are testing push stuff, make sure to set both to `try-comm-central`'s
  URL.
