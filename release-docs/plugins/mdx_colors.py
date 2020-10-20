# -*- coding: utf-8 -*-
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

"""
Extension to Python Markdown for simple text colors

Basic Example:

[green]This is green text[/green]

<span class="green">This is green</span>

Available colors are defined in assets/css/text.css
blue
purple
pink
red
orange
yellow
green
white
black
"""

from nikola.plugin_categories import MarkdownExtension

from markdown.util import etree
from markdown.inlinepatterns import Pattern
from markdown.extensions import Extension


COLORS = "blue|purple|pink|red|orange|yellow|green|white|black"

COLOR_RE = r'\[(?P<color>%s)\](?P<text>.+)\[/(?P=color)\]' % COLORS


class TextColorPattern(Pattern):
    """InlinePattern for footnote markers in a document's body text."""

    def __init__(self, pattern):
        """Initialize pattern."""
        Pattern.__init__(self, pattern)

    def handleMatch(self, m):
        """Handle pattern matches."""
        color = m.group('color')
        text = m.group('text')
        span_elem = etree.Element('span')
        span_elem.set('class', 'text-{}'.format(color))
        span_elem.text = text
        return span_elem


class TextColorExtension(MarkdownExtension, Extension):
    def extendMarkdown(self, md, md_globals=None):
        """Extend Markdown."""
        color_md_pattern = TextColorPattern(COLOR_RE)
        color_md_pattern.md = md
        md.inlinePatterns.register(color_md_pattern, 'textcolor', 175)
        md.registerExtension(self)


def makeExtension(configs=None):  # pragma: no cover
    """Make Markdown extension."""
    return TextColorExtension()
