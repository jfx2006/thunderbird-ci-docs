For writing release notes for an ESR release, ideally any bug that is uplifted
and requiring a note will already have had a note in a previous beta.

The copy-paste manual labor can be done with `gather_notes.py` found in the
thunderbird-notes repo in the tools directory.

`gather_notes.py` requires a list of bug numbers to look for. `mach release buglist`
will sort of help with that.

TODO: Make this nicer.

In a full checkout of mozilla-central (or a branch repo):

```
./mach release buglist --version <new release ver> --product thunderbird \
    --repo https://hg.mozilla.org/releases/<repo branch> --revision <release rev>
```

For example:

```
./mach release buglist --version 78.2.2 --product thunderbird
    --repo https://hg.mozilla.org/releases/comm-esr78 --revision 85fc86689124
```

This gives you a URL to open the list of bugs in Bugzilla.

```
https://bugzilla.mozilla.org/buglist.cgi?bug_id=1651298%2C1642536%2C1661924%2C1371309%2C1660917%2C1624676%2C1658890%2C1662585%2C1663269%2C1644311%2C1653690%2C1662536%2C1657221%2C1661216%2C1655627%2C1641773%2C1659323%2C1658923%2C1659380%2C1662881%2C875059%2C1660923%2C1663037%2C1663219%2C1563411%2C1661229%2C1663157%2C1662481%2C1649123%2C1659946%2C1660702%2C1597180%2C1653647%2C1601749%2C1662492%2C1661546%2C1663013%2C1658797%2C1659318%2C1445778%2C1661913%2C492216%2C1663490%2C1662831%2C1659528%2C1660134
```

Which is not very useful.

```
from urllib.parse import urlparse, parse_qs

u=urlparse('<the url from above>')
bugs=parse_qs(u.query)['bug_id'][0]
for bug in bugs.split(','):
    print(bug)
```

Run the above and put the output into a file named `bugs_fixed.txt`. Then run
`gather_notes.py`.

```
./tools/gather_notes.py <previous esr> <current_beta>
```

TODO: Make `gather_notes.py` more verbose about what it does.

Then you should have a file `ver_notes.yml` that will give you a decent starting
point. Do not publish that as-is!
