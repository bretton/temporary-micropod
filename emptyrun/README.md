# Emptyrun

This will build a podman empty container.

> If you want a shortcut to see the available commands, please see [this gist](https://gist.github.com/bretton/7ef755486bcd08894ae3d01ae2df92b2) for details. This may be out of date in future.

## Variables

None.

## Usage

### Prerequisites

None.

### Build

Clone the repo, build the base image, then build the emptyrun image as follows:

```
git clone https://github.com/bretton/temporary-micropod
cd temporary-micropod/emptyrun
buildah bud -t emptyrun .
```

### ZFS Dataset for persistent data

Not included.

### Run

Run the image with podman as follows:

```
podman run -dt \
  -h emptyrun \
  emptyrun:latest
```

### Container logs

To see logs, first `podman ps -a` and find the ID, then `podman logs <ID>`.

### Usage

This container is an empty container, used to get a list of commands included with the base OCI image.

To access the container shell you would run
```
podman exec -ti emptyrun /bin/sh
```

And then perform commands such as
```
ls -al /bin
ls -al /sbin
ls -al /usr/bin
ls -al /usr/sbin
ls -al /usr/local/bin
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
buildah rmi localhost/emptyrun
```

