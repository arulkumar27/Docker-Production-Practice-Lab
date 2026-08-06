# Troubleshooting Docker Volume Errors

Storage failures commonly result from:

- Incorrect container paths
- Missing host paths
- Wrong volume names
- Read-only mounts
- File ownership differences
- Database initialization behaviour
- Accidental volume deletion
- Insufficient host disk space

## Inspect Container Mounts

```bash
docker inspect \
  --format '{{json .Mounts}}' \
  CONTAINER_NAME
```

Check:

- Mount type
- Host source
- Container destination
- Read-only setting
- Volume name

## List Volumes

```bash
docker volume ls
```

## Inspect a Volume

```bash
docker volume inspect VOLUME_NAME
```

## Scenario 1: Bind Source Does Not Exist

Command:

```bash
docker run \
  --mount type=bind,source="$(pwd)/missing-directory",target=/data \
  alpine:latest
```

With `--mount`, Docker normally reports that the bind source does not exist.

Verify:

```bash
pwd
ls -la
```

Create the exact directory if required:

```bash
mkdir -p missing-directory
```

Retry the container.

## Scenario 2: Wrong Container Path

Nginx serves files from:

```text
/usr/share/nginx/html
```

Incorrect mount:

```bash
docker run -d \
  --name wrong-path-nginx \
  -p 8080:80 \
  --mount type=bind,source="$(pwd)/html",target=/var/www/html \
  nginx:alpine
```

The mount succeeds, but Nginx does not use that directory.

Correct:

```bash
docker run -d \
  --name correct-path-nginx \
  -p 8081:80 \
  --mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html,readonly \
  nginx:alpine
```

Always confirm the correct application path from the image documentation or container configuration.

## Scenario 3: Read-Only Mount

Inspect:

```bash
docker inspect \
  --format '{{json .Mounts}}' \
  CONTAINER_NAME
```

Attempting to write into a mount configured as read-only produces an error.

If writes are genuinely required, recreate the container with an explicitly writable mount.

Do not remove read-only protection without confirming the application's requirement.

## Scenario 4: Permission Denied

Check the container user:

```bash
docker exec CONTAINER_NAME id
```

Check directory permissions:

```bash
docker exec CONTAINER_NAME \
  ls -ld /data
```

For a bind mount, also check the host:

```bash
ls -ld HOST_DIRECTORY
```

Align the directory ownership with the container runtime UID and GID.

## Scenario 5: Data Disappeared

Check whether the original container used a named volume:

```bash
docker inspect \
  --format '{{json .Mounts}}' \
  OLD_CONTAINER
```

List volumes:

```bash
docker volume ls
```

If a replacement container was started without the original volume, its expected data will not appear.

Attach the correct volume:

```bash
docker run \
  --mount type=volume,source=ORIGINAL_VOLUME,target=/data \
  IMAGE_NAME
```

## Anonymous Volumes

List volumes:

```bash
docker volume ls
```

Anonymous volumes normally have generated names.

Inspect candidate volumes:

```bash
docker volume inspect VOLUME_NAME
```

Avoid deleting unknown volumes before identifying their owners and contents.

## Scenario 6: PostgreSQL Initialization Script Did Not Run

PostgreSQL initialization scripts under:

```text
/docker-entrypoint-initdb.d
```

normally run only when the database data directory is empty.

If an existing volume already contains data, changing the SQL initialization file does not rerun it.

For disposable local practice only:

```bash
docker compose down --volumes
docker compose up -d
```

This deletes the existing practice database. Never do this to required data.

## Scenario 7: Volume Is In Use

Error:

```text
volume is in use
```

Find containers referencing it:

```bash
docker ps -a \
  --filter volume=VOLUME_NAME
```

Inspect those containers before stopping or removing anything.

## Scenario 8: Host Disk Is Full

Check Docker usage:

```bash
docker system df -v
```

Check host storage:

```bash
df -h
```

Check inode usage:

```bash
df -i
```

Review large Docker resources before cleanup.

Do not immediately use:

```bash
docker system prune -a --volumes
```

This can delete important images and persistent data.

## Verify Volume Contents Safely

```bash
docker run --rm \
  --mount type=volume,source=VOLUME_NAME,target=/data,readonly \
  alpine:latest \
  find /data -maxdepth 3 -type f -print
```

## Back Up Before Correction

```bash
mkdir -p backups
```

```bash
docker run --rm \
  --mount type=volume,source=VOLUME_NAME,target=/source,readonly \
  --mount type=bind,source="$(pwd)/backups",target=/backup \
  alpine:latest \
  tar -czf /backup/volume-backup.tar.gz -C /source .
```

## Storage Troubleshooting Checklist

- Confirm volume name
- Confirm mount type
- Confirm host source path
- Confirm container destination path
- Confirm read-only or writable mode
- Check container UID and GID
- Check filesystem permissions
- Check available disk space
- Check database initialization rules
- Back up data before deleting anything
