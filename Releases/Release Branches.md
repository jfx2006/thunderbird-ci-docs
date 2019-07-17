Release Branches
================

What was done to create the comm-esr68 branch, including the related changes in repositories not owned or maintained by Thunderbird.

The strategy used for creating comm-esr68 was to wait and see what Firefox did, and then adapt for Thunderbird.

Two bugs tracked the work, and the distribution of what went with which bug is a little weird. There should have been a third bug, see the next section.

* [1552389](http://bugzil.la/1552389) - Port bug 1551738 - Add in-tree support for comm-esr68
* [1561934](http://bugzil.la/1561934) - Please clone comm-beta to releases/comm-esr68

#### Thinking ahead a little

For Thunderbird 76, I suggest a meta bug that would cover all esr76 issues across Thunderbird. I don't believe there was one for Thunderbird 68.

For the build/CI pieces, I suggest three bugs:

* in-tree (C-C) changes
* one for the hg.m.o team as they have a number of components to touch
* one for the releng maintained repositories whether they are in Mercurial or Github

## Description of various changes

This will all be different by the time Thunderbird 76 rolls around, but this list should be helpful in finding the odds and ends that got missed for Thunderbird 68.

### hg.mozilla.org

comm-esr68 was cloned from comm-beta on 2019-07-02.

Bugzilla request to do the clone:

* [1561934](http://bugzil.la/1561934) - Please clone comm-beta to releases/comm-esr68

This followed what Mozilla was doing to create mozilla-esr68, but may have been a deviation from what was expected.

The work is done by the hg.m.o maintainers, we just need to open the bug and give them ample time to get it done.

### Taskcluster In-tree changes

The work for comm-esr68 was done in bug [1552389](http://bugzil.la/1552389). In most cases it was updating some regular expressions to match comm-esr68 in addition to comm-esr60.

### Taskcluster external: ci-configuration

The Taskcluster server needs to be configured to watch the repository. This is done by updating the "projects.yml" file in the "ci-configuration" repository. It's likely sufficient to copy the block from the previous esr repository and update a couple of fields. Changes should be submitted to Phabricator for review, and then Mozilla releng will deploy.

For comm-esr68, the change is at [D37316](https://phabricator.services.mozilla.com/D37316).

comm-* repositories also have configuration in "grants.yml" that is not mirrored by the configuration for the mozilla-* repositories.

That was an additional change found at [D37674](https://phabricator.services.mozilla.com/D37674).

### Taskcluster external: scriptworker

The new repository needs to be added to scriptworker/constants.py.
[Github Pull Request](https://github.com/mozilla-releng/scriptworker/pull/364)

### Treeherder

Treeherder needs to be updated so it knows about the new repository. [Github pull request 5134](https://github.com/mozilla/treeherder/pull/5134) holds the changes for comm-esr68. Note that the actual configuration had been added before that, and this pull request was just to activate those changes.
It may be easier to make this its own bug (so a fourth) since this team is sort of separate from the others involved.

### Release services: Treestatus

An entry needs to be made in the Treestatus database. For comm-esr68, @rail took care of this via an IRC request. There's probably a more formal way to do this. There was no code to update.

### Release services: Shipit

There's a line in one of the config files that needs to change so it knows to release off of comm-esr68 instead of comm-esr60. TODO: Update this with the pull request once it's done

### Balrog update rules

As there is overlap between the initial release of Thunderbird 68.0 and the release of Thunderbird 60.9, a new rule needs to be added to each of the release channels on Balrog and on Balrog Staging. (release-localtest, release-cdntest, release)

![Screen Shot 2019-07-17 at 19](file://media/1138082525.png)




