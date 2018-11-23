#!/bin/bash
echo "wal_level = archive" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_mode = on" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_command = 'envdir /etc/wal-e.d/env /usr/local/bin/wal-e wal-push %p'" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_timeout = 60" >> /var/lib/postgresql/data/postgresql.conf
echo $WALE_FILE_PREFIX > /etc/wal-e.d/env/WALE_FILE_PREFIX

crontab -e

crontab -l | { cat; echo \"0 9 * * * /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push /var/lib/postgresql/data\"; } | crontab -

crontab -l | { cat; echo \"30 9 * * * /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e delete --confirm retain 10\"; } | crontab -


#su - postgres -c "crontab -l | { cat; echo \"0 9 * * * /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push /var/lib/postgresql/data\"; } | crontab -"

#su - postgres -c "crontab -l | { cat; echo \"30 9 * * * /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e delete --confirm retain 10\"; } | crontab -"

