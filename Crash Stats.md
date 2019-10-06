Crash Stats
===========

Taskcluster builds upload symbols to symbols.mozilla.org with the "Sym" job. This makes crash reports that Thunderbird sends automaticaly actually useful.

## API Key

Someone has to create an API key in the Symbols server that the job will use to upload the build symbols. This API key has to be associated with an LDAP account. The key that's currently in use is associated with Rob. You need to have some elevated privileges in Symbols(?) to be able to create an API key. See bug [1496236](http://bugzil.la/1496236).

There's actually two API keys: one for "level-1" builds (try-comm-central) and one for "level-3" (comm-central, comm-beta, comm-esrXX). This is per policy as noted in the Symbols UI. An API token cannot contain privileges for both regular and try builds.

Create the keys (or if it's October 2020 Rob can extend his again) and make sure to save what they are.

## Taskcluster Secrets

There are two secrets in Taskcluster to store these API keys. They are set up using the Secrets Manager on https://tools.taskcluster.net.

* project/comm/thunderbird/releng/build/level-1/gecko-symbol-upload
* project/comm/thunderbird/releng/build/level-3/gecko-symbol-upload

You need to have access to the `project:releng:ci-group:thunderbird-releng` role in Taskcluster to be able to modify the secrets. I believe that is associated with an LDAP group named `thunderbird-releng` but I could be wrong about that. At this time Rob is the primary member of that group.

The API keys need to be stored as YAML data.

```
token: XXXXXXXXX
```

In this case, there is one key, `token` and then the value is the API key.