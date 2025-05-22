# Testnetworkbig

This will build a podman empty container for network testing using alternate approaches. This can be used for `ipv4`, `ipv6` and dualstack environments.

The default setup of `podman-suite` on FreeBSD 14.3 on a dualstack host, fails to handle network activity inside a container during the build step.

Adding a second podman network with `ipv6` enabled should fix issues with network access on a dualstack host.

## Variables

None.

## Usage

### Prerequisites

This test uses a custom image using `base.txz` to create a base container. This is a large file!

Setup a new image in localhost using

```
podman import --os freebsd \
  --arch amd64 \
  --message 'Import FreeBSD 14.3-BETA3 base.txz' \
  https://download.freebsd.org/ftp/releases/amd64/14.3-BETA3/base.txz
```

Get the image id with
```
podman image ls -a
```

Tag the image with
```
podman image tag <image-id> localhost/freebsd-base:14.3-beta3
```

#### Default Podman network

If testing the default podman installation, do not make any changes to the podman network.

#### Dualstack Podman network

If testing a dualstack, create a second podman network with `ipv6` enabled.

```
podman network create ip-dual-stack --ipv6
```

### Build

Clone the repo, build the base image, then build the testnetwork image as follows:

```
git clone https://github.com/bretton/temporary-micropod
cd temporary-micropod/testnetworkpreferv4
```

Then depending on network setup:

#### Default Podman network with Buildah

```
buildah bud -t testnetworkpreferv4 .
```

or with external DNS

```
buildah bud --dns=1.1.1.1 -t testnetworkpreferv4 .
```

#### Default Podman network with Podman build

```
podman build -t testnetwork -f Containerfile .
```

or with external DNS

```
podman build --dns=1.1.1.1 -t testnetwork -f Containerfile .
```

#### Dualstack Podman network with Buildah

```
buildah bud --network ip-dual-stack -t testnetworkpreferv4 .
```

or with external DNS

```
buildah bud --network ip-dual-stack --dns=1.1.1.1 -t testnetworkpreferv4 .
```

#### Dualstack Podman network with Podman build

```
podman build --network ip-dual-stack -t testnetwork -f Containerfile .
```

or with external DNS

```
podman build --network ip-dual-stack --dns=1.1.1.1 -t testnetwork -f Containerfile .
```

### ZFS Dataset for persistent data

Not included.

### Run

#### Default Podman network

Run the image with podman as follows:

```
podman run -dt \
  --name=testnetworkpreferv4 \
  --hostname=testnetworkpreferv4 \
  testnetworkpreferv4:latest
```

> Things should not get this far on a dualstack network with default podman network settings

#### Dualstack Podman network

Run the image with podman as follows. 

```
podman run -dt \
  --network=ip-dual-stack:ip=10.89.0.14 \
  --dns=1.1.1.1 \
  --name=testnetworkpreferv4 \
  --hostname=testnetworkpreferv4 \
  testnetworkpreferv4:latest
```

> Things should get this far on a dualstack network with a second podman network with IPv6 enabled. The image should run.

### Container logs

To see logs, first `podman ps -a` and find the ID, then `podman logs <ID>`.

### Usage

This container is an empty container, used for network testing in dualstack or `ipv6` environments.

To access the container shell you would find the image container-id or name with
```
podman ps -a
```

And then run the shell with
```
podman exec -ti <container-id> /bin/sh
```

And then perform commands such as
```
ping -c 10 google.com
ping6 -c 10 ipv6.google.com

host pkg.freebsd.org
pkg bootstrap -fy
```

### Cleanup

Stop containers with

```
podman stop --all
```

Remove containers with

```
podman rm --all
```

Remove built image with

```
buildah rmi localhost/testnetworkpreferv4
```

