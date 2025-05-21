#!/bin/sh

sysrc ip6addrctl_policy="ipv4_prefer"

service ip6addrctl start

ping -c 10 google.com

ping -c 10 ipv6.google.com

# keep the container running
sleep 3600