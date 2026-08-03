# Docker Container Lifecycle

A container passes through different states from creation to removal.

## Main Container States

| State | Meaning |
|---|---|
| Created | Container exists but has not started |
| Running | Main container process is executing |
| Paused | Processes are temporarily suspended |
| Restarting | Docker is attempting to restart it |
| Exited | Main process has stopped |
| Dead | Container could not be stopped or removed normally |
| Removed | Container metadata and writable layer are deleted |

## Create a Container

Create without starting:

```bash
docker create --name lifecycle-nginx -p 8080:80 nginx:alpine
```

Verify:

```bash
docker ps -a
```

## Start a Container

```bash
docker start lifecycle-nginx
```

## Stop a Container Gracefully

```bash
docker stop lifecycle-nginx
```

Docker first sends a termination signal and waits before forcefully stopping the process.

## Restart a Container

```bash
docker restart lifecycle-nginx
```

## Pause and Unpause

```bash
docker pause lifecycle-nginx
docker unpause lifecycle-nginx
```

## Kill a Container

Forcefully terminate the container:

```bash
docker kill lifecycle-nginx
```

Use `docker stop` for normal operations. Use `docker kill` when the container does not stop gracefully.

## Remove a Container

The container must normally be stopped first:

```bash
docker stop lifecycle-nginx
docker rm lifecycle-nginx
```

Force removal:

```bash
docker rm -f lifecycle-nginx
```

## Why Containers Exit Automatically

A container remains running only while its main process is running.

This command exits after printing its output:

```bash
docker run alpine:latest echo "Practice completed"
```

The `echo` process finishes immediately, so the container enters the `Exited` state.

This container keeps running because Nginx stays in the foreground:

```bash
docker run -d --name running-nginx nginx:alpine
```

## Interactive Container

Start an interactive Alpine shell:

```bash
docker run --rm -it alpine:latest /bin/sh
```

Exit the container:

```bash
exit
```

The container stops because the shell was its main process. The `--rm` option then removes it automatically.

## Detached Container

```bash
docker run -d --name detached-nginx nginx:alpine
```

- `-d` runs the container in the background
- `--name` gives it a readable name

## Execute a Command Inside a Container

```bash
docker exec -it detached-nginx /bin/sh
```

Exit without stopping Nginx:

```bash
exit
```

`docker exec` starts an additional process. Exiting that shell does not stop the original Nginx process.

## Restart Policies

### No Automatic Restart

```bash
docker run -d \
  --name no-restart \
  --restart=no \
  nginx:alpine
```

### Restart When the Container Fails

```bash
docker run -d \
  --name failure-restart \
  --restart=on-failure:3 \
  nginx:alpine
```

### Restart Unless Manually Stopped

```bash
docker run -d \
  --name resilient-nginx \
  --restart=unless-stopped \
  nginx:alpine
```

### Always Restart

```bash
docker run -d \
  --name always-nginx \
  --restart=always \
  nginx:alpine
```

## Inspect Container State

```bash
docker inspect detached-nginx
```

Display only the current status:

```bash
docker inspect \
  --format '{{.State.Status}}' \
  detached-nginx
```

Display the exit code:

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  detached-nginx
```

## View Exited Containers

```bash
docker ps -a --filter status=exited
```

## Lifecycle Practice

```bash
docker create --name lifecycle-practice nginx:alpine
docker ps -a
docker start lifecycle-practice
docker ps
docker pause lifecycle-practice
docker unpause lifecycle-practice
docker restart lifecycle-practice
docker stop lifecycle-practice
docker ps -a
docker rm lifecycle-practice
```
