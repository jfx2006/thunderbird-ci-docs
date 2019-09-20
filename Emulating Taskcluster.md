Emulating Taskcluster
=====================

This document is experimental at best and mostly for personal reference.

## Podman vs Docker

mach has buiilt in support for downloading and importing Docker images that Taskcluster has buiit into your local Docker instance.
I'm using Podman lately on Ubuntu. With a rootless setup, you can (in theory) mount a source checkout on your host system in the container and not have messy privilege issues. I also plan to have hacked up copies of the source checkout tools (run-task) so that I don't have to download huge amounts of data a million times while testing something.

## Podman notes

[podman.io](https://podman.io) has docs and links to packages for mostly RedHat/Fedora derived distros. There is an Ubuntu PPA. I'm using those packages on Disco.

You need to get the crun runtime from https://github.com/containers/crun as at the time of this writing there is no Ubuntu package.

Next you need a Docker image. `mach` doesn't have functionality to download an image, only import it into Docker directly. That won't help us with Podman though, so find the image you want by using the Taskcluster Index Browser, or through Treeherder or any other way of getting an image.tar.zst file. In this case I'm using the toolchain image, but you can grab which ever is appropriate.

### Importing an image

Podman doesn't have Zst support, so you will have to decompress and pipe to stdin.

<pre><font color="#8AE234"><b>➜ </b></font><font color="#4E9A06">zstdcat</font> <font color="#75507B">image.tar.zst</font>| <font color="#4E9A06">podman</font> import <font color="#06989A">-</font> toolchain-20190920                                                                          <font color="#FCE94F"><b>2s</b></font><b> </b>
Getting image source signatures
Copying blob ebea6ff8f0a0 done
Copying config b1d7887d1c done
Writing manifest to image destination
Storing signatures
b1d7887d1ca132bd462a5bb747e07fe42329080eb918d3490a111dfc25231fe0

<font color="#8AE234"<b>➜ </b></font><font color="#4E9A06">podman</font> image ls
REPOSITORY                             TAG      IMAGE ID       CREATED         SIZE
docker.io/library/toolchain-20190920   latest   b1d7887d1ca1   2 minutes ago   476 MB
</pre>


### Run the image

First take a look at how it's built:

<pre><font color="#8AE234"><b>➜ </b></font><font color="#4E9A06">podman</font> inspect docker.io/library/toolchain-20190920
[
    {
        "Id": "b1d7887d1ca132bd462a5bb747e07fe42329080eb918d3490a111dfc25231fe0",
        "Digest": "sha256:c3538882195e99369dfab78249d34e16798f21f9eb26737b87b4d0f41aa5b3bd",
        "RepoTags": [
            "docker.io/library/toolchain-20190920:latest"
        ],
        "RepoDigests": [
            "docker.io/library/toolchain-20190920@sha256:c3538882195e99369dfab78249d34e16798f21f9eb26737b87b4d0f41aa5b3bd"
        ],
        "Parent": "",
        "Comment": "imported from tarball",
        "Created": "2019-09-20T05:22:16.557332263-04:00",
        "Config": {},
        "Version": "",
        "Author": "",
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 475982421,
        "VirtualSize": 475982421,
        "GraphDriver": {
            "Name": "vfs",
            "Data": null
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:ebea6ff8f0a06367268256b5601ad0678b70c979ec37f806fc28ff43618496d6"
            ]
        },
        "Labels": null,
        "Annotations": {},
        "ManifestType": "application/vnd.oci.image.manifest.v1+json",
        "User": "",
        "History": [
            {
                "created": "2019-09-20T05:22:16.557332263-04:00",
                "created_by": "/bin/sh -c #(nop) ADD file:ebea6ff8f0a06367268256b5601ad0678b70c979ec37f806fc28ff43618496d6 in /",
                "comment": "imported from tarball"
            }
        ]
    }
]
</pre>