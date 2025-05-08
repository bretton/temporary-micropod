#!/bin/sh

# check if /var/db/postgres/data16 is empty and initialize the database if it is
if [ ! -f /var/db/postgres/data16/PG_VERSION ]; then
	# initialize the database
	# there is no su in container, sudo not work, using doas as installed in Containerfile
	/usr/bin/install -d -o postgres -g postgres -m 755 /var/db/postgres/data16
	# permissions problem setting more restrictive permissions, so allow group access
	/usr/local/bin/doas -u postgres -- /usr/local/bin/initdb --encoding=utf-8 --lc-collate=C --allow-group-access -D /var/db/postgres/data16/ -U postgres
fi

# make sure our custom files overwrite the default ones
# chown and su don't exist but install does
if [ -d /var/db/postgres/data16/ ]; then
	/usr/bin/install -o postgres -g postgres -m 644 /usr/local/etc/postgresql/pg_hba.conf /var/db/postgres/data16/pg_hba.conf
	/usr/bin/install -o postgres -g postgres -m 644 /usr/local/etc/postgresql/postgresql.conf /var/db/postgres/data16/postgresql.conf
else
	echo "/var/db/postgres/data16/ does not exist, not overwriting configuration files"
	exit 1
fi

# start the postgres server
if [ -f /var/db/postgres/data16/PG_VERSION ]; then
	/usr/local/bin/doas -u postgres -- /usr/local/bin/pg_ctl -D /var/db/postgres/data16/ -w -s -m fast
else
	echo "Could not start PostgreSQL, /var/db/postgres/data16/PG_VERSION does not exist"
	exit 1
fi
