Releng Github Repos
===================

Notes on making pull requests in a way that you can keep doing it.

* Fork the repository in Github
* Clone the fork locally
* Create a branch for your work, name doesn't matter a whole lot
* Commit the change
* Push to your repo
* Create pull request against upstream master

Updating

add the original repository as remote repository called "upstream"

* `git remote add upstream https://github.com/OWNER/REPOSITORY.git`

fetch all changes from the upstream repository

* `git fetch upstream`

switch to the master branch of your fork

* `git checkout master`

merge changes from the upstream repository into your fork

* `git merge upstream/master`
