TB_win32Towin64
===============

These steps are meant to be specifically for Thunderbird XX ??

# High-level steps

1. Create a new release in balrog for the migration 
2. Create a new balrog rule on the cdntest channels to point to to the release blob 

# Detailed descriptions

After we have release blobs available in balrog we need to create a new release in balrog for win64 migration.  We also need to create a new watershed to map to this newly release in balrog so win32 users with certain criteria will be updated to win64 Thunderbird. See bug XXXXXX for more details.

Download the script here to munge the release blobs called win32Towin64_balrog.py

Login to [balrog admin](https://aus4-admin.mozilla.org)

## Thunderbird beta

### Creating a new release  in balrog
1. Go to the [Firefox release for 56.0b9](https://aus4-admin.mozilla.org/releases#Firefox-56.0b9)
2. Select download to download the release blob
3. `python munge.py Thunderbird-XX.0by-buildZ.json`
which creates Thunderbird-XX.0by-buildZ-win64-migration.json
4. In balrog add a new release where name is Thunderbird-XX.0by-buildZ-win64-migration and product is "Thunderbird"

### Adding the migration rule

1. Add a rule to Thunderbird,beta-cdntest that points to that new rule.  It should look like rule [in this screenshot](https://bug1556748.bmoattachments.org/attachment.cgi?id=9069662)
except it should be a Thunderbird rule.  The mapping should be to the win64 migration release you just added. 

### Adding the watershed

Before the builds are pushed to the beta channel, a new watershed need to be added.    You need to create rules on the beta  channel that looks like this [in this screenshot](https://bug1556748.bmoattachments.org/attachment.cgi?id=9069660), 

