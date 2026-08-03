# Non-Root Container Practice

This exercise demonstrates how to run an application using a dedicated non-root user.

## Why Non-Root Containers Matter

A process running as root inside a container has unnecessary privileges.

If an attacker compromises the application, root access may increase the impact of the compromise.

Running as a non-root user follows the principle of least privilege.

## Build the Image

```bash
docker build \
  --build-arg APP_UID=10001 \
  --build-arg APP_GID=10001 \
  -t non-root-api:1.0.0 \
  .
```

## Run with Security Options

```bash
docker run -d \
  --name non-root-api \
  -p 3000:3000 \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --cap-drop=ALL \
  --security-opt=no-new-privileges:true \
  --memory="256m" \
  --cpus="0.50" \
  non-root-api:1.0.0
```

## Security Option Explanation

| Option | Purpose |
|---|---|
| `--read-only` | Makes the container filesystem read-only |
| `--tmpfs /tmp` | Provides temporary writable memory storage |
| `--cap-drop=ALL` | Removes Linux capabilities |
| `no-new-privileges` | Prevents privilege escalation |
| `--memory` | Restricts memory usage |
| `--cpus` | Restricts CPU usage |

## Test the Application

```bash
curl http://localhost:3000
curl http://localhost:3000/health
```

## Verify the Runtime User

```bash
docker exec non-root-api whoami
```

Expected:

```text
appuser
```

Check the user ID:

```bash
docker exec non-root-api id
```

Expected UID:

```text
10001
```

Inspect the configured user:

```bash
docker image inspect \
  --format '{{.Config.User}}' \
  non-root-api:1.0.0
```

## Test the Read-Only Filesystem

```bash
docker exec non-root-api touch /app/test-file
```

The command should fail because the filesystem is read-only.

Test temporary storage:

```bash
docker exec non-root-api touch /tmp/test-file
```

This should succeed because `/tmp` uses a writable `tmpfs` mount.

## Check Health

```bash
docker ps
```

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  non-root-api
```

## Cleanup

```bash
docker rm -f non-root-api
docker image rm non-root-api:1.0.0
```
