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


# Don't repeat yourself

For writing release notes for an ESR release, ideally any bug that is uplifted
and requiring a note will already have had a note in a previous beta.

The copy-paste manual labor can be done with `gather_notes.py` found in the
thunderbird-notes repo in the tools directory.

`gather_notes.py` requires a list of bug numbers to look for. `mach release buglist`
will help get that list.

In a full checkout of mozilla-central (or a branch repo):

```bash
./mach release buglist --version <new release ver> --product thunderbird \
    --repo https://hg.mozilla.org/releases/<repo branch> --revision <release rev>

./mach release buglist --version 78.2.2 --product thunderbird
    --repo https://hg.mozilla.org/releases/comm-esr78 --revision 85fc86689124
```

This gives you a URL to open the list of bugs in Bugzilla.

```
https://bugzilla.mozilla.org/buglist.cgi?bug_id=1651298%2C1642536%2C1661924%2C1371309%2C1660917%2C1624676%2C1658890%2C1662585%2C1663269%2C1644311%2C1653690%2C1662536%2C1657221%2C1661216%2C1655627%2C1641773%2C1659323%2C1658923%2C1659380%2C1662881%2C875059%2C1660923%2C1663037%2C1663219%2C1563411%2C1661229%2C1663157%2C1662481%2C1649123%2C1659946%2C1660702%2C1597180%2C1653647%2C1601749%2C1662492%2C1661546%2C1663013%2C1658797%2C1659318%2C1445778%2C1661913%2C492216%2C1663490%2C1662831%2C1659528%2C1660134
```

Then run `gather_notes.py` with the first esr version (eg. 78.0) and the
current beta version as parameters. Do not include the beta number.
 
```bash
./tools/gather_notes.py <first esr> <current_beta>
./tools/gather_notes.py 78.0 81.0
```

`gather_notes.py` will prompt for the URL that `mach release buglist` printed
out. 

TODO: Make `gather_notes.py` more verbose about what it does.

Then you should have a file `ver_notes.yml` that will give you a decent starting
point. Do not publish that as-is!
