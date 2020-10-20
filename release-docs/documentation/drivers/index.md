title: Managing Releases
slug: index
date: 2020-09-18 03:48:25 UTC
type: text

# Target Milestones

A bug is typically marked as fixed when it lands on trunk (i.e. comm-central).
The only exception to this is when it does not actually apply to trunk,
but only to a stable branch.

Thunderbird Drivers request that when a bug is marked as fixed, its milestone
is updated to be the match the next trunk release milestone. 

# Triage

One or more of the Thunderbird drivers will regularly triage nominations and
other status flags, consulting with other drivers and relevant parties as
necessary.

To check the current blocking and wanted bugs for a release, we have a bug
tracking page here (NOT YET).

# Merge Repositories

Merge Day happens every four weeks on a Monday and is the first step in a new
beta version. See
[Merge Repositories](https://wiki.mozilla.org/Thunderbird/Release_Driving/Rapid_Release_Activities/Merge_Repositories)
for all of the details.

# Uplifts

Bugs are fixed in comm-central. When a bug is present in a beta or release
version, the procedure for copying that fix to comm-beta or comm-esrXX is called
uplifting.

Uplifts are requested in the *Details* page of a bug attachment (patch).
They can be requested by the developer submitting the patch or a release driver.
They may be either regular bugzilla attachments or Phabricator review attachments.

See [Release Tools](/tools) for the Bugzilla uplift queries.

# Release Notes


