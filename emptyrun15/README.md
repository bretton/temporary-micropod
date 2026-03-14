# Emptyrun

This will build a podman empty container.

> A list of commands available in FreeBSD 15.0 OCI images is provided at https://gist.github.com/bretton/6eb5c9cb767050e69a1b333f15002c60

## Variables

None.

## Usage

### Prerequisites

None.

### Build

Clone the repo, build the base image, then build the emptyrun image as follows:

```
git clone https://github.com/bretton/temporary-micropod
cd temporary-micropod/emptyrun15
podman build -t emptyrun15 -f Containerfile
```

### ZFS Dataset for persistent data

Not included.

### Run

Run the image with podman as follows:

```
podman run -dt \
  --name=emptyrun15 \
  --hostname=emptyrun15 \
  emptyrun:latest
```

### Container logs

To see logs, first `podman ps -a` and find the ID, then `podman logs <ID>`.

### Usage

This container is an empty container, used to get a list of commands included with the base OCI image.

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
podman image rm localhost/emptyrun15
```

