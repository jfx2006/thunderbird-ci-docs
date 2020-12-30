title: Release Notes
slug: releasenotes
date: 2020-09-19 02:32:25 UTC
type: text

# Purpose

Release notes are a central source of information about changes in each
Thunderbird release. They're mainly aimed at advanced and technical users
who want to be informed about the changes in the latest update.

The release notes page lists notable new features, changes and unfixed critical
bugs for a specific release of Thunderbird. Their edition and content are under
the responsibility of the release drivers and are usually written by the
engineer in charge of a release.

# Writing Release Notes

Release notes are kept in the
[thunderbird-notes](https://github.com/thundernest/thunderbird-notes)
repository. You'll need to have push access to that repo.

See
[README.md](https://github.com/thundernest/thunderbird-notes/blob/master/README.md)
for how to use that repository.


# What goes into release notes

The changes that should be included in releases notes include:

* New features for end users
* Important changes for end users
* Important stability and security fixes
* Important system requirements changes (ex: end of support for an OS version)
* New locales
* New and changed MailExtension APIs

# Rules and guidelines for writing release notes

* New items first. The image from the template says "New" so don't repeat it.
* Changes second
* Fixed items
* Unresolved

Within each of those: Mail, Address book, Chat, Calendar, then Mail Extensions.

* Don't copy commit message or bug description. They are rarely fit for the
    release notes.
* For fixed and changed items, use past tense and state the thing that was
    broken or changed. Don't repeat the word "fixed".
* Don't link to bugs in the note.
* Notes are sentence fragments. Don't start them with 'The', 'A', etc. Don't
    use periods. Unless there is a good reason for the note to have more
    than one sentence.
* Keep notes as short as possible. If you find yourself wanting to start a
    new sentence, figure out a way to rephrase the note.
* Do not use abbreviations. For example, "pref" should be "preference".
* Group items that belong to a category together. For example, items with
    Address book can be grouped together.
* Add a note for security fixes pointing to the link is provided by the
    Security team.

# Bad vs Good examples

* [red]Changed: Move account manager to a tab[/red]
    * [green]Changed: Account Manager moved to a tab[/green]
* [red]Changed: Improve UI of search results tab[/red]
    * [green]Improved UI of global search results tab[/green]
* [red]Fixed: Do not collapse thread when opening news message in a new window[/red]
    * [green]Thread collapsed when opening news message in a new window[/green]
* [red]Fixed: Opening the properties of a folder may hang on Mac[/red]
    * [green]Opening the properties of a folder sometimes hung on Mac[/green]
* [red]Fixed: Unlock master password at startup time[/red]
    * [green]Multiple master password prompts. Fixed by prompting for master password at startup time.[/green]
* [red]Fixed: Restore building partial updates[/red]  
    * [green]Partial updates not working[/green]


# Generating a bug list

Once you have completed the uplifts and have pushed to Mercurial, there is a `nach`
command that will help generate a list of bugs that went into the release.

You need a recent checkout of `mozilla-central` for `mach`. It doesn't need
to be on the same revision or anything.

```commandline
mach release buglist --version <version of release> --product thunderbird --repo <url of release repo> --revision <revision you pushed>

mach release buglist --version 85.0b3 --product thunderbird --repo https://hg.mozilla.org/releases/comm-beta --revision 7066e91fbe5ae7e07bd47f283ae4d5921d977008
```

The output is a link you can open in your browser:

```text
Comparing Mercurial tag THUNDERBIRD_85_0b2_RELEASE to THUNDERBIRD_85_0b3_RELEASE:
* [Bugs since previous changeset](https://bugzilla.mozilla.org/buglist.cgi?bug_id=1682023%2C1682971%2C1679769%2C1683642%2C1682309%2C1622640%2C1682035%2C1658781%2C1680527%2C77806%2C1682808%2C1681575%2C1682407%2C1680468)
* [Full Mercurial changelog](https://hg.mozilla.org/releases/comm-beta/pushloghtml?fromchange=THUNDERBIRD_85_0b2_RELEASE&tochange=7066e91fbe5ae7e07bd47f283ae4d5921d977008&full=1)
```

# Don't repeat yourself

For writing release notes for an ESR release, ideally any bug that is uplifted
and requiring a note will already have had a note in a previous beta.

The copy-paste manual labor can be done with `gather_notes.py` found in the
thunderbird-notes repo in the tools directory.

`gather_notes.py` needs the most recent ESR release version and the current beta
version.
 
```bash
./tools/gather_notes.py <previous_esr> <current_beta>
./tools/gather_notes.py 78.4.3 84.0
```

`gather_notes.py` will print out the bugs it found and then pull release notes
for those bugs from the beta notes directory.

Then you should have a file `ver_notes.yml` that will give you a decent starting
point. Do not publish that as-is!
