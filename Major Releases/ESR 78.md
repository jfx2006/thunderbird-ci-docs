ESR 78
========================

This document is to supplement what's in Bugzilla, not replace it. For Thunderbird 78, there is a meta bug for build-related tasks that should cover everything.

**Bug [1634965](http://bugzil.la/1634965) - [meta] Thunderbird 78 build tasks**


### hg.mozilla.org

[1646065](http://bugzil.la/1646065) - clone releases/comm-beta to releases/comm-esr78


### Taskcluster external: ci-configuration

[1646074](http://bugzil.la/1646074) - Add support for comm-esr78 repos


### Treeherder

[1646078](http://bugzil.la/1646078) - Activate comm-esr78 repository

### Treestatus

Looks like Callek covered this in bug [1645646](http://bugzil.la/1645646) - Support treestatus groups for esr78

### Download bouncer aliases

Even though the website does not use the download bouncer, there are places that use the "latest" link like the README.txt file on the FTP server. Why the hell you would need a link when you're already on the FTP server is beyond me, but...
Bouncer alias updates need to be disabled for the old esr once the new one is released. To do this change the release-bouncer-aliases job to an empty configuration or just remove the current so it falls back to default. See bug [1669147](http://bugzil.la/1669147).