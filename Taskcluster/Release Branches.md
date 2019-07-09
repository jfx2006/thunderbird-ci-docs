Release Branches
================

What was done to create the comm-esr68 branch, including the related changes in repositories not owned or maintained by Thunderbird.

The strategy used for creating comm-esr68 was to wait and see what Firefox did, and then adapt for Thunderbird.

## hg.mozilla.org

comm-esr68 was cloned from comm-beta on 2019-07-02.

Bugzilla request to do the clone:

* [1561934](http://bugzil.la/1561934) - Please clone comm-beta to releases/comm-esr68

This followed what Mozilla was doing to create mozilla-esr68, but may have been a deviation from what was expected.

The work is done by the hg.m.o maintainers, we just need to open the bug and give them ample time to get it done.

## Taskcluster

### In-tree changes

The work for comm-esr68 was done in bug [1552389](http://bugzil.la/1552389). In most cases it was updating some regular expressions to match comm-esr68 in addition to comm-esr60.

### ci-configuration

The Taskcluster server needs to be configured to watch the repository. This is done by updating the "projects.yml" file in the "ci-configuration" repository. It's likely sufficient to copy the block from the previous esr repository and update a couple of fields. Changes should be submitted to Phabricator for review, and then Mozilla releng will deploy.

For comm-esr68, the change is at [D37316](https://phabricator.services.mozilla.com/D37316).

## Treeherder

Treeherder needs to be updated so it knows about the new repository. [Github pull request 5134](https://github.com/mozilla/treeherder/pull/5134) holds the changes for comm-esr68. Note that the actual configuration had been added before that, and this pull request was just to activate those changes.

## Treestatus

An entry needs to be made in the Treestatus database. For comm-esr68, @rail took care of this via an IRC request. There's probably a more formal way to do this.

## Scriptworker

The new repository needs to be added to scriptworker/constants.py.
[Github Pull Request](https://github.com/mozilla-releng/scriptworker/pull/364)

