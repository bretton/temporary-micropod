# Sample Podman Compose with single container

This is a sample podman compose file with a single container.

## Usage

Copy `sample.env` to `.env` and edit for your IP addressing.

```
# set local IP addresses
IP4_ADDRESS=""
# make sure to have square backets around IPv6 address
IP6_ADDRESS="[]"
```

Then run 

```
podman compose up -d
```

## Restart testing

Assuming `podman_service` is enabled, restart host with `shutdown -r now` and see if containers are restarted on reboot.