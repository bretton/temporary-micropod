# Testnetwork

This will build a podman empty container for network testing. This can be used for `ipv4`, `ipv6` and dualstack environments.

The default setup of `podman-suite` on FreeBSD 14.2 on a dualstack host, fails to handle network activity inside a container during the build step.

## Variables

None.

## Usage

### Prerequisites

None specifically. `/usr/local/etc/containers/containers.conf` might need updating to allow `ipv6`.

### Build

Clone the repo, build the base image, then build the testnetwork image as follows:

```
git clone https://github.com/bretton/temporary-micropod
cd temporary-micropod/testnetwork
buildah bud -t testnetwork .
```

### ZFS Dataset for persistent data

Not included.

### Run

Run the image with podman as follows:

```
podman run -dt \
  --ip=10.88.0.10 \
  -h testnetwork \
  testnetwork:latest
```

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

