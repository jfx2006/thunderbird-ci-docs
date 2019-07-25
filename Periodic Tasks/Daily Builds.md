Daily Builds
============

These are defined by the "nightly-desktop" job *.cron.yml*.

## Disabling

To turn off Daily builds temporarily, update *.cron.yml* and change the "when" seciion of "nightly-desktop" to an empty list.

```
jobs:
    - name: nightly-desktop
      job:
          type: decision-task
          treeherder-symbol: Nd
          target-tasks-method: nightly_desktop
      run-on-projects:
          - comm-central
      when: []  # disabled by XXXXX for bug XXXXX
```

Then revert your commit to enable Dailies again.


