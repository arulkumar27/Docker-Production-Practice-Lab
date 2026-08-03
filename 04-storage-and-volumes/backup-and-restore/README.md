# Docker Volume Backup and Restore

This exercise creates a compressed backup of a Docker named volume and restores it into another named volume.

## Important Production Note

Copying raw database files while a database is actively writing can produce an inconsistent backup.

Production databases should normally use database-aware tools such as:

- `pg_dump` for PostgreSQL
- `mysqldump` for MySQL
- `mongodump` for MongoDB
- Application-supported backup tools
- Coordinated storage snapshots

The scripts in this folder demonstrate general file-level Docker volume backup and restoration.

## Files

```text
backup-and-restore/
├── README.md
├── backup-volume.sh
├── restore-volume.sh
└── .gitignore
```

## Create Practice Data

Create the source volume:

```bash
docker volume create project-data
```

Write sample data:

```bash
docker run --rm \
  --mount type=volume,source=project-data,target=/data \
  alpine:latest \
  sh -c '
    mkdir -p /data/config /data/reports
    echo "environment=practice" > /data/config/application.conf
    echo "Docker storage report" > /data/reports/report.txt
    echo "Volume created successfully" > /data/status.txt
  '
```

## Verify Source Data

List files:

```bash
docker run --rm \
  --mount type=volume,source=project-data,target=/data,readonly \
  alpine:latest \
  find /data -maxdepth 3 -type f -print
```

Display their contents:

```bash
docker run --rm \
  --mount type=volume,source=project-data,target=/data,readonly \
  alpine:latest \
  sh -c '
    cat /data/config/application.conf
    cat /data/reports/report.txt
    cat /data/status.txt
  '
```

## Make Scripts Executable

Run from the `backup-and-restore` directory:

```bash
chmod +x backup-volume.sh restore-volume.sh
```

## Back Up the Volume

```bash
./backup-volume.sh project-data
```

The script creates:

```text
backups/project-data-backup.tar.gz
```

## Verify the Backup Archive

```bash
ls -lh backups
```

List files inside the archive:

```bash
tar -tzf backups/project-data-backup.tar.gz
```

## Create a Destination Volume

```bash
docker volume create restored-project-data
```

## Restore the Backup

```bash
./restore-volume.sh \
  restored-project-data \
  backups/project-data-backup.tar.gz
```

## Verify Restored Data

```bash
docker run --rm \
  --mount type=volume,source=restored-project-data,target=/data,readonly \
  alpine:latest \
  find /data -maxdepth 3 -type f -print
```

Read a restored file:

```bash
docker run --rm \
  --mount type=volume,source=restored-project-data,target=/data,readonly \
  alpine:latest \
  cat /data/config/application.conf
```

Expected:

```text
environment=practice
```

## Compare the Volumes

```bash
docker run --rm \
  --mount type=volume,source=project-data,target=/source,readonly \
  --mount type=volume,source=restored-project-data,target=/restored,readonly \
  alpine:latest \
  diff -r /source /restored
```

No output means the original and restored contents match.

## Backup Validation Checklist

- [ ] Backup command completed successfully
- [ ] Backup archive exists
- [ ] Backup archive is not empty
- [ ] Archive contents can be listed
- [ ] Backup restores into a separate volume
- [ ] Restored files are readable
- [ ] Source and restored data match
- [ ] Backup location is protected
- [ ] Retention requirements are documented

## Cleanup

After successfully verifying the restoration:

```bash
docker volume rm project-data
docker volume rm restored-project-data
```

The backup archive remains in the local `backups` directory.

Do not remove a real backup until its retention period has ended and another verified backup is available.
