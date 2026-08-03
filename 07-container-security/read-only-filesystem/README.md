# Read-Only Filesystem Practice

A read-only root filesystem prevents the application from modifying its container filesystem.

Only explicitly configured locations remain writable.

## Initialize the Content

```bash
docker compose run --rm content-initializer
```

## Start the Application

```bash
docker compose up -d application
```

## Test the Website

```bash
curl http://localhost:8080
```

## Test Root-Filesystem Protection

```bash
docker compose exec application \
  touch /unauthorized-file
```

Expected result:

```text
Read-only file system
```

## Test Application Directory Protection

```bash
docker compose exec application \
  touch /app/unauthorized-file
```

This should fail because the application-content volume is mounted as read-only.

## Test Temporary Storage

```bash
docker compose exec application \
  touch /tmp/allowed-temporary-file
```

Verify:

```bash
docker compose exec application \
  ls -la /tmp
```

The operation succeeds because `/tmp` is an explicitly configured tmpfs mount.

## Inspect the Configuration

```bash
docker inspect \
  --format '{{.HostConfig.ReadonlyRootfs}}' \
  read-only-application
```

Expected:

```text
true
```

Inspect tmpfs:

```bash
docker inspect \
  --format '{{json .HostConfig.Tmpfs}}' \
  read-only-application
```

## Why This Improves Security

A read-only filesystem can reduce an attacker's ability to:

- Replace application files
- Modify executable files
- Persist malicious files
- Change container configuration
- Write into unexpected locations

It does not protect against every attack. Applications, dependencies, the Docker host and network access must also be secured.

## Cleanup

```bash
docker compose down --volumes
```

The `--volumes` option removes the practice content volume.
