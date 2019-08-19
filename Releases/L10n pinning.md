L10n pinning
============

## Status Quo

We haven't been pinning localizations, so everything since Thunderbird 64 has been getting whatever is on the head of the various repos. For 68 we are pinning. 

## Starting point

This should run sometime before releasing a new version, but after signoffs are done. All I had to work with really was an email from Tom P with a command and a link to some configuration files for that command.

This is the command Tom provided Jörg with.
```
mach python -- testing/mozharness/scripts/l10n_bumper.py --bump-changesets --no-push-loop --extra-config comm/mozharness --config-file l10n_bumper/comm-<tree>.py
```
And his config files can be found at https://phabricator.services.mozilla.com/D5891

[Thunderbird_l10n_bumper.eml](file://attachments/788213760.eml)

## ESR68

We missed the signoff window for ESR68, so if we pin to tb68, we will actually get the revisions for Thunderbird 64. 

The suggestion from Axel  H was to use the changesets from tb69, and then port changesets.json to 68.

[Thunderbird_68_L10n.eml](file://attachments/898635061.eml)

### Config files

Starting with Tom's config files, I made a config file for comm-esr68. The configs are not in the tree just yet because I don't think this process will work in automation like it's supposed to. So I'm just running it locally. Bug [1572316](http://bugzil.la/1572316) is where they are for now.

### Process

- Checked out mozilla-esr68 and comm-esr68 like usual.
- Applied the config file patch from bug [1572316](http://bugzil.la/1572316)

_The config file we have will automatically use the major version from comm/mail/config/version.txt

