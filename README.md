# temporary-micropod

This is a temporary micropod repository used for sharing broken builds and test images with chat.

## Emptyrun

This is just an empty container

## Postgresql

Please see README.md in the postgresql16 directory

## Testnetwork

This will build a podman empty container for network testing using the tiny FreeBSD 14.2 runtime image

## Testnetworkbig

This will build a podman empty container using FreeBSD 14.3-beta `base.txz` and make a large container image with all programs.

## Testnetworkpreferv4

This will build a podman empty container using FreeBSD 14.3-beta `base.txz` and make a large container image with all programs, and configure to prefer `ipv4` inside image.