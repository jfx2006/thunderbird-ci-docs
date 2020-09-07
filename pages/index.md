title: Thunderbird Release HOWTO
slug: index
date: 2020-09-05 14:18:25 UTC
type: text

Thunderbird Project version numbers generally match up to Mozilla Firefox ESR
and beta versions. (Unlike Firefox, Thunderbird releases versions between ESRs
only as betas, for example 69-77 are betas only.) Future ESR releases of
Thunderbird upcoming are (probably) 90, 102, etc. 

Thunderbird does not release on a specific scheduled date, though we roughly
track the ESR release schedule of Firefox. This means that roughly every 12
months in the summer a new major release of Thunderbird is ready, and every
4 weeks a new beta version.

# Release Drivers

The active team that is primarily responsible for Thunderbird releases is:

* Wayne Mery (:wsmwk, Release Manager)
* Rob Lemley (:rjl, Release Engineer)

The Thunderbird drivers list (thunderbird-drivers@mozilla.org) consists of the
active team as well as those involved in producing Thunderbird releases, and
appropriate advisers. At the team's discretion, it also contains third parties
who are responsible for producing distributed builds of Thunderbird, primarily
Linux distributions, so that they are advised as to build and release progress,
timing and issues. 

# Managing Releases

## Target Milestones

A bug is typically marked as fixed when it lands on trunk (i.e. comm-central).
The only exception to this is when it does not actually apply to trunk,
but only to a stable branch.

Thunderbird Drivers request that when a bug is marked as fixed, its milestone
is updated to be the match the next trunk release milestone. 

## Triage

One or more of the Thunderbird drivers will regularly triage nominations and
other status flags, consulting with other drivers and relevant parties as
necessary.

To check the current blocking and wanted bugs for a release, we have a bug
tracking page here (NOT YET).

## Merge Repositories

Merge Day happens every four weeks on a Monday and is the first step in a new
beta version. See
[Merge Repositories](https://wiki.mozilla.org/Thunderbird/Release_Driving/Rapid_Release_Activities/Merge_Repositories)
for all of the details.

## Uplifts

Bugs are fixed in comm-central. When a bug is present in a beta or release
version, the procedure for copying that fix to comm-beta or comm-esrXX is called
uplifting.

Uplifts are requested in the *Details* page of a bug attachment (patch).
They can be requested by the developer submitting the patch or a release driver.
They may be either regular bugzilla attachments or Phabricator review attachments.

When an uplift is requested, it should show up in one of these lists:

* [Beta Uplifts Requested](buglist/?channel=beta&query=uplifts-requested)
* [Release Uplifts Requested](buglist/?channel=release&query=uplifts-requested)

The release manager will review and approve uplifts on a regular basis.

Once an uplift is approved for the next release, it should show up in one of
these lists:

* [Beta Uplifts Approved](buglist/?channel=beta&query=uplifts-approved)
* [Release Uplifts Approved](buglist/?channel=release&query=uplifts-approved)

**If you have requested an uplift and it does not show up in the *Requested* or
*Approved* bug lists, then you should contact one of the release drivers via
Matrix or via NeedInfo in Bugzilla to make sure it gets considered for inclusion.**




