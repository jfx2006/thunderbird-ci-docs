# Thunderbird Release Documentation

This repo contains documentation related to the Thunderbird release process.

# Howto

Create your virtualenvironment. Python >= 3.5 is required.

    virtualenv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    
All `nikola` commands below run in release-docs directory

    cd release-docs

## Creating a new page

    nikola new_page

## Dev Server

This will start a dev server and open a browser to it.

    nikola serve -b

## Building

    nikola build
    
## Deploy

Set up this git repo as "origin" and `nikola github_deploy` will work hopefully.

# Bugzilla Queries

release-docs/themes/tbrelease has the Jinja2 template and corresponding
Javascript that builds the bug query tables. There is a package.json file,
but it's only needed for ESLint/Prettier. 

# Dashboard

This is a fork of Mozilla's delivery dashboard. The source is in
"release-dashboard"
