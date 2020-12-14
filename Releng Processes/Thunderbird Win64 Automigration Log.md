Thunderbird Win64 Automigration Log
===================================

# Setting up release-localtest

## Script
```
➜ ./win32Towin64_balrog.py Thunderbird-68.2.0-build1
Downloading release blob from: https://aus4-admin.mozilla.org/api/releases/Thunderbird-68.2.0-build1?pretty=1
Writing new release data to: Thunderbird-68.2.0-build1-win64-migration.json
```

## Create migration release

* Verify the sanity of the generated JSON. It needs to be uploaded to Balrog manually. Use the "Releases" section at the top. At the bottom right of the browser window there is a "+" to create a new release.
	* Click the "upload release" button and select the JSON file that was generated.
	* The release name should fill in automatically. The Product field will need to be set to Thunderbird manually.

Hopefully that passes the verification that Balrog does!


## Rules

Working off release-locatest here..


