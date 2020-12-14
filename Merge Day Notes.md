Merge Day Notes
===============

https://wiki.mozilla.org/Thunderbird/Release_Driving/Rapid_Release_Activities/Merge_Repositories

# Update shipit & shipitv2 (release services) repos and send pull requests
-- notify~~~~ clokep on github
# Need to request  "assume:mozilla-group:vpn_treestatus" for treestatus


Close trees
- Planned closure, reason "merges", remember change - repos on wiki page

- Disable FirefoxTree -- some way to do from commandline?

```
# Fix this script
 ./resetreleaserepos.sh

# Rewrite this to use tee or something similar
./merge-beta-2-release.sh &> beta2release.log
less beta2release.log

# pushes

# Fix this script
./resetmainrepos.sh


# Rewrite to use tee
./merge-central-2-beta.sh &> central2beta.log
less central2beta.log

# pushes


```

Bugzilla changes
https://bugzilla.mozilla.org/show_bug.cgi?id=1523287


## Updating ship-it

Back to it's own repo now...

https://github.com/mozilla-releng/shipit

* create a branch
	* git checkout -b 'thunderbird_72'
* make changes
	* gvim api/src/shipit_api/config.py
	* Change "LATEST_THUNDERBIRD_NIGHTLY_VERSION"
* commit
	* git add api/src/shipit_api/config.py
	* git commit
* push to your fork
	* git push origin thunderbird_70
* log into github web site and make the pull request




## Updating release-services (old info!!)

* create a branch
	* git checkout -b 'thunderbird_70'
* make changes
	* gvim src/shipit/api/shipit_api/config.py
* commit
	* git add src/shipit/api/shipit_api/config.py
	* git commit
* push to your fork
	* git push origin thunderbird_70
* log into github web site and make the pull request