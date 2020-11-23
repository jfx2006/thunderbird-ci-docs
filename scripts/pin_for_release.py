#!/usr/bin/env python3

import sys
import os
import re
import urllib.request
import json

MOZ_HG_URL = "https://hg.mozilla.org/releases/{repo}"
MOZ_HG_TAG_URL = "https://hg.mozilla.org/releases/{repo}/json-tags"
# Most recent tag that's a RELEASE or BUILD1
RELEASE_TAG_RE = re.compile(r"""^FIREFOX_[\dbesr_]+(RELEASE|BUILD1)$""")

LINES = {"GECKO_BASE_REPOSITORY": 1,
         "GECKO_HEAD_REPOSITORY": 2,
         "GECKO_HEAD_REF": 3,
         "GECKO_HEAD_REV": 4,}

def get_last_tag(repo):
    url = MOZ_HG_TAG_URL.format(repo=repo)
    res = urllib.request.urlopen(url)
    res_body = res.read()

    j = json.loads(res_body.decode("utf-8"))

    for i in range(0, 10):
        tag = j['tags'][i]
        if RELEASE_TAG_RE.match(tag['tag']):
            # TODO: Grab a version and verify it's sane
            return {'tag': tag['tag'],
                    'node': tag['node']}

    raise Exception("No release tag found in first 10 tags downloaded.")


def update_gecko_yml(repo, tagdata):
    if not os.path.isfile('.gecko_rev.yml'):
        raise Exception("No .gecko_rev.yml found in current directory. Not in a comm checkout?")

    with open('.gecko_rev.yml') as fp:
        data = fp.readlines()

    # Line 0 "---"
    # Line 1 GECKO_BASE_REPOSITORY
    # Line 2 GECKO_HEAD_REPOSITORY
    # Line 3 GECKO_HEAD_REF
    # Line 4 GECKO_HEAD_REV (maybe)
    def parse_line(lineno):
        line = data[lineno]
        line.strip()
        return line.split(':')

    def set_line(key, value):
        lineno = LINES[key]
        data[lineno] = "{}: {}\n".format(key, value)

    set_line('GECKO_HEAD_REPOSITORY', MOZ_HG_URL.format(repo=repo))
    set_line('GECKO_HEAD_REF', tagdata['tag'])

    rev_line = parse_line(LINES['GECKO_HEAD_REV'])
    if len(rev_line) != 2:
        data.insert(LINES['GECKO_HEAD_REV'], '')
    set_line('GECKO_HEAD_REV', tagdata['node'])

    with open('.gecko_rev.yml', 'w') as fp:
        fp.writelines(data)

    print("Success!")
    print("hg commit .gecko_rev.yml -m 'No bug - Pin {repo} ({tag}/{shortnode}). r=release a=rjl'"
          .format(repo=repo, tag=tagdata['tag'], shortnode=tagdata['node'][:11]))


def main(repo):
    tagdata = get_last_tag(repo)
    update_gecko_yml(repo, tagdata)


if  __name__ == "__main__":
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        raise Exception("Mozilla repo name not provided.")
