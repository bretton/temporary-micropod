# Testnetwork

This will build a podman empty container for network testing. This can be used for `ipv4`, `ipv6` and dualstack environments.

The default setup of `podman-suite` on FreeBSD 14.2 on a dualstack host, fails to handle network activity inside a container during the build step.

Adding a second podman network with `ipv6` enabled should fix issues with network access on a dualstack host.

## Variables

None.

## Usage

### Prerequisites

Pull the latest development image

```
podman pull docker.io/freebsd/freebsd-runtime:14.3-beta4
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
cd temporary-micropod/testnetwork
```

Then depending on network setup:

#### Default Podman network

```
podman build -t testnetwork -f Containerfile
```

> This should fail on a dualstack host.

#### Dualstack Podman network

```
podman build --network ip-dual-stack -t testnetwork -f Containerfile
```

> This should work on a dualstack host with a second podman network created

### ZFS Dataset for persistent data

Not included.

### Run

#### Default Podman network

Run the image with podman as follows:

```
podman run -dt \
  --ip=10.88.0.10 \
  --name=testnetwork \
  --hostname=testnetwork \
  testnetwork:latest
```

> Things should not get this far on a dualstack network with default podman network settings


#### Dualstack Podman network

Run the image with podman as follows. Note the change in IP to `10.89.0.0` range, set with a second podman network.

```
podman run -dt \
  --network=ip-dual-stack:ip=10.89.0.10 \
  --name=testnetwork \
  --hostname=testnetwork \
  testnetwork:latest
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
buildah rmi localhost/testnetwork
```

