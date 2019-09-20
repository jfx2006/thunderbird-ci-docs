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

Podman doesn't have Zst support, so you will have to decompress and pipe to stdin.

zs	