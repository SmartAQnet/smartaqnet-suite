# Frost-Server
## Frost-Server-GUI

A server implementation of SensorthingsAPI from FraunhoferIOSB.

## Frost-Server-Database

Postgres docker container with postgis plugin and wale for backup

This image serves as the database for [FROST-Server](https://github.com/BowenWang29/docker-SensorThingsServer). It initalizes a postgresql database container based on [docker-postgis](https://github.com/appropriate/docker-postgis) with [WAL-E](https://github.com/wal-e/wal-e) installed for WAL archiving.

__/scripts/initdb-postgis.sh__ installs the postgis plugin and __/scripts/setup-wale.sh__ initializes the WAL archiving service.

Environment variables must be pass to the container for WAL-E, or WAL-E is not configured.

This image backups at 9 am UTC and cleanups backups at 9:30 am UTC and retains up to 10 backups. These settings can be modified in __/scripts/setup-wale.sh__. The setup-wale also configures the archive_command for WAL and wal_level, where the archive_command pointed out that the archiving process uses the subfunction wal-push in WAL-E. Also, the base backup is taken with the backup-push offered by WAL-E. For more information please refer to https://github.com/wal-e/wal-e.


This image has three volumes:
- postgis_data_volume:/var/lib/postgresql/data

Data folder for postgresql. Accessable in container and host.
- postgis_backup_volume:/lib/postgresql/backup

Stores base backup and back up write ahead logs. Accessable in container and host.
- postgis_env_volume:/etc/wal-e.d/env

For storage of environment variables. Only accessable through container.
