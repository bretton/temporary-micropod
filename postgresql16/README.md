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

### Build

Clone the repo, build the base image, then build the postgresql image as follows:

```
git clone https://github.com/bretton/temporary-micropod
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
podman run -dt \
  --ip=10.88.0.[??] \
  --volume "/mnt/data/postgres:/var/db/postgres:rw" \
  --shm-size="1g" \
  -h postgresql16 \
  postgresql16-0.0.1:latest
```

### Container logs

To see logs, first `podman ps -a` and find the ID, then `podman logs <ID>`.

Currently this image is failing run with an error relating to shared memory:

```
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "C".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/db/postgres/data16 ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 20
selecting default shared_buffers ... 400kB
selecting default time zone ... UTC
creating configuration files ... ok
running bootstrap script ... 2025-05-08 14:08:05.113 UTC [73503] FATAL:  could not create shared memory segment: Function not implemented
2025-05-08 14:08:05.113 UTC [73503] DETAIL:  Failed system call was shmget(key=64, size=56, 03600).
child process exited with exit code 1
initdb: removing contents of data directory "/var/db/postgres/data16"
Could not start PostgreSQL, /var/db/postgres/data16/PG_VERSION does not exist
```

### Usage

Steps to be added for creating a user with database.

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
buildah rmi localhost/postgresql16-0.0.1
```