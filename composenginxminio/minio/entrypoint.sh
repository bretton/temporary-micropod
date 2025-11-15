#!/bin/sh
MINIO_ROOT_USER="${MINIO_USER}" MINIO_ROOT_PASSWORD="${MINIO_PASS}" MINIO_PROMETHEUS_AUTH_TYPE=public /usr/local/bin/minio --quiet server --address=":9000" --console-address :9001 /var/db/minio
