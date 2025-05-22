#!/bin/sh

sysrc ip6addrctl_policy="ipv4_prefer"

service ip6addrctl start

ping -c 1 google.com

ping -c 1 ipv6.google.com

route get pkg.freebsd.org

# keep the container running
sleep 3600