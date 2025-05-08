# Postgresql

This will build a podman postgresql container.

## Variables

TBA. None set currently.

## Usage

### Prerequisites

Shared memory must be enabled in `/usr/local/etc/containers/containers.conf` and podman_service restarted.

```
ipcns = "private"
```

Caveat: shared memory is not actually working yet!!

### Setup source container with official FreeBSD OCI image

Use podman to load the official FreeBSD OCI image as follows:

```
podman pull docker.io/freebsd/freebsd-runtime:14.2
```

You only need to do this once, it doesn't need to be repeated for every container build. 

### Build

Clone the repo, build the base image, then build the postgresql image as follows:

```
git clone <repo link>
cd temporary-micropod/postgresql16
buildah bud -t postgresql16-0.0.1 .
```

### ZFS Dataset for persistent data

Create a dataset to use for the container volume, for example if you have a `data` pool:

```
zfs create -o mountpoint=/mnt/data/postgres data/postgres
```

### Run

Run the image with podman as follows:

```
podman run -dt\
        --ip=10.88.0.[??] \
        --volume "/mnt/data/postsgres:/var/db/postgres:rw" \
        --shm-size="1g" \
        -h postgresql16 \
        postgresql16-0.0.1:latest
```

### Container logs

To see logs, first `podman ps -a` and find the ID, then `podman logs <ID>`.

Currently this image is failing run with the error:

```
running bootstrap script ... 2025-05-06 18:10:42.012 UTC [33230] FATAL: could not create shared memory segment: Function not implemented
2025-05-06 18:10:42.012 UTC [33230] DETAIL:  Failed system call was shmget(key=2, size=56, 03600). 
```

### Usage

Steps to be added for creating a user with database.
