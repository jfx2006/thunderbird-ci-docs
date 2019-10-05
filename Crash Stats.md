Crash Stats
===========

Taskcluster builds upload symbols to symbols.mozilla.org with the "Sym" job. This makes crash reports that Thunderbird sends automaticaly actually useful.

## API Key

Someone has to create an API key in crash-stats that the job will use to upload the build symbols. This API key has to be associated with an LDAP account. The key that's currently in use is associated with Rob. You need to have some elevated privileges in crash-stats(?) to be able to create an API key. See bug [1496236](http://bugzil.la/1496236).

 