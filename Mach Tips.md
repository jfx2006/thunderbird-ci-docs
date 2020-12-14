Mach Tips
=========

Run decision task  based on latest c-c build.

```
mach taskgraph full --root comm/taskcluster/ci -p https://index.taskcluster.net/v1/task/comm.v2.comm-central.latest.taskgraph.decision/artifacts/public/parameters.yml
```

Run decision task based on latest nightly c-c build.

```
mach taskgraph full --root comm/taskcluster/ci -p https://index.taskcluster.net/v1/task/comm.v2.comm-central.latest.taskgraph.decision-nightly-desktop/artifacts/public/parameters.yml
```

Easier way for all of the above:

```
mach taskgraph tasks --root comm/taskcluster/ci -p project=comm-central  
```


When hacking the taskgraph, first get a parameters file, then run `mach taskgraph tasks` and save to a JSON file to track what changes as your work progresses.

```
mach taskgraph tasks --root comm/taskcluster/ci -p project=comm-central -J > begin-tasks.json
```
