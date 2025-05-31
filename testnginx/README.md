# Testnginx

This container loads `nginx` configured with defaults. The purpose is to test port forwarding in dualstack environments.

## Environment Variables

None.

## Requirements

### Setup a second podman network with ipv6 enabled

For testing port forwards on `ipv4` and `ipv6` setup a second podman network as follows:

```
podman network create ip-dual-stack --ipv6
```

The network will be created with a default `ipv4` range of `10.89.0.0/24` and `ipv6` range of `fd7a:8af5:d7e9:e4af::/64`

### Configure /etc/pf.conf for 

Update your `/etc/pf.conf`, replacing with correct interface name, and make sure to restart `pf`

```
v4egress_if = "vtnet0"
v6egress_if = "vtnet0"

table <cni-nat> persist { 10.89.0.0/24, fd00:66fc:9b4e:8e21::/64 }

nat on $v4egress_if inet from <cni-nat> to any -> ($v4egress_if)
nat on $v6egress_if inet6 from <cni-nat> to !ff00::/8 -> ($v6egress_if)

rdr-anchor "cni-rdr/*"
nat-anchor "cni-rdr/*"
```

## Usage

### Setup source container with official FreeBSD OCI image

Use podman to load the official FreeBSD OCI image as follows:
```
podman pull docker.io/freebsd/freebsd-runtime:14.3-beta4
```

You only need to do this once, it doesn't need to be repeated for every container build. 

### Build

Clone the repo, build the base image, then build the testingnginx image as follows:

```
git clone https://github.com/bretton/temporary-micropod
cd temporary-micropod/testnginx
```

Then depending on network setup:

#### Default Podman network

```
podman build -t testnginx -f Containerfile
```

#### Dualstack Podman network

```
podman build --network ip-dual-stack -t testnginx -f Containerfile
```

### ZFS Dataset for persistent data

Not included.

### Run

#### Default Podman network

Run the image with podman as follows:

```
podman run -dt \
  --publish=8080:80 \
  --ip=10.88.0.10 \
  --name=testnginx \
  --hostname=testnginx \
  testnginx:latest
```

#### Dualstack Podman network

Run the image with podman as follows. Note the change in IP to `10.89.0.0` range, set with a second podman network.

```
podman run -dt \
  --publish=8080:80 \
  --network=ip-dual-stack:ip=10.89.0.10 \
  --name=testnginx \
  --hostname=testnginx \
  testnginx:latest
```

### Container logs

To see logs, first `podman ps -a` and find the ID, then `podman logs <ID>`.

### Diagnostic Usage

This container is a simple `nginx` container, used for network testing in dualstack environments.

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
buildah rmi localhost/testnginx
```