# -*- coding: utf-8 -*-
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

"""Compile Typescript assets."""

from __future__ import absolute_import, print_function, unicode_literals

from nikola.plugin_categories import Task


class TSCompile(Task):
    """Compile Typescript assets to Javascript."""

    name = "typescript_compile"

    def gen_tasks(self):
        """Create tasks to compile thje .ts files"""
