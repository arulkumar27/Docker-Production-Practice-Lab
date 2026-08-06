# Troubleshooting Docker Permission Errors

Permission failures commonly occur when:

- The user cannot access the Docker socket
- A bind-mounted file has incorrect ownership
- The container runs as a non-root user
- A mounted directory is read-only
- A container lacks a required Linux capability
- A security policy blocks an operation

## Docker Socket Permission Denied

Example:

```text
permission denied while trying to connect to the Docker daemon socket
```

## Check Docker Service

```bash
sudo systemctl status docker
```

Start it if required:

```bash
sudo systemctl start docker
```

Enable it during boot:

```bash
sudo systemctl enable docker
```

## Check Current User

```bash
whoami
id
groups
```

## Check Docker Socket

```bash
ls -l /var/run/docker.sock
```

Typical ownership:

```text
root docker
```

## Test with sudo

```bash
sudo docker ps
```

If this works but `docker ps` fails, the problem is usually user access to the Docker socket.

## Add the Current User to the Docker Group

```bash
sudo usermod -aG docker "$USER"
```

Apply the group in the current terminal:

```bash
newgrp docker
```

Test:

```bash
docker ps
```

You may need to sign out and sign back in.

## Security Warning

Membership in the Docker group provides powerful host-level access.

Only trusted users should be added.

## Jenkins Docker Permission

Check the Jenkins identity:

```bash
id jenkins
```

Add Jenkins to the Docker group on an isolated, authorized agent:

```bash
sudo usermod -aG docker jenkins
```

Restart Jenkins:

```bash
sudo systemctl restart jenkins
```

Test:

```bash
sudo -u jenkins docker version
```

## Bind-Mount Permission Problem

Create a directory:

```bash
mkdir -p permission-practice/data
```

Check ownership:

```bash
ls -ld permission-practice/data
```

Run a non-root container:

```bash
docker run --rm \
  --user 10001:10001 \
  --mount type=bind,source="$(pwd)/permission-practice/data",target=/data \
  alpine:latest \
  touch /data/test.txt
```

If the host directory is not writable by UID `10001`, the command fails.

## Correct Ownership for a Practice Directory

Only run this against the exact practice directory:

```bash
sudo chown -R 10001:10001 \
  "$(pwd)/permission-practice/data"
```

Retry:

```bash
docker run --rm \
  --user 10001:10001 \
  --mount type=bind,source="$(pwd)/permission-practice/data",target=/data \
  alpine:latest \
  touch /data/test.txt
```

Avoid using broad recursive permission commands on system or repository roots.

## Read-Only Filesystem Error

Example:

```text
Read-only file system
```

Inspect:

```bash
docker inspect \
  --format '{{.HostConfig.ReadonlyRootfs}}' \
  CONTAINER_NAME
```

Inspect mounts:

```bash
docker inspect \
  --format '{{json .Mounts}}' \
  CONTAINER_NAME
```

If the application requires temporary writes, explicitly provide a writable path:

```bash
docker run \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  IMAGE_NAME:TAG
```

Persistent writes should use an appropriate named volume.

## Permission Denied Inside an Image

Open the container:

```bash
docker run --rm -it \
  --entrypoint /bin/sh \
  IMAGE_NAME:TAG
```

Check:

```sh
whoami
id
pwd
ls -la
```

Review Dockerfile ownership:

```dockerfile
COPY --chown=appuser:appgroup . /app
USER appuser
```

## Do Not Use 777 as the Default Fix

Avoid:

```bash
chmod -R 777 DIRECTORY
```

This grants excessive permissions and can hide the actual ownership problem.

Instead:

1. Identify the runtime UID and GID.
2. Identify which directory requires writes.
3. Assign appropriate ownership.
4. Grant only required permissions.
5. Retest the application.

## Cleanup

```bash
sudo chown -R "$USER":"$(id -gn)" \
  "$(pwd)/permission-practice"
```

Remove the practice directory only if it contains no required data.
