# Non-Root Container Practice

This image creates a dedicated `appuser` with UID `10001`.

## Build the Image

```bash
docker build \
  --build-arg APP_UID=10001 \
  --build-arg APP_GID=10001 \
  -t secure-non-root:1.0.0 \
  .
```

## Inspect the Configured User

```bash
docker image inspect \
  --format '{{.Config.User}}' \
  secure-non-root:1.0.0
```

Expected:

```text
appuser
```

## Run the Container

```bash
docker run -d \
  --name secure-non-root \
  -p 8080:8080 \
  --cap-drop=ALL \
  --security-opt=no-new-privileges:true \
  secure-non-root:1.0.0
```

## Test the Application

```bash
curl http://localhost:8080
```

## Confirm the Runtime Identity

```bash
docker exec secure-non-root whoami
docker exec secure-non-root id
```

Expected user:

```text
appuser
```

Expected UID:

```text
10001
```

## Verify Capability Restrictions

```bash
docker inspect \
  --format '{{json .HostConfig.CapDrop}}' \
  secure-non-root
```

## Why UID 10001 Is Used

A dedicated high-numbered UID helps avoid:

- Running the application as root
- Depending on a normal interactive host user
- Accidental privilege assumptions
- Common system-account UID conflicts

The container user still requires correct permissions for application files and writable directories.

## Cleanup

```bash
docker rm -f secure-non-root
docker image rm secure-non-root:1.0.0
```
