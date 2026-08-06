# Troubleshooting Exited Containers

A container remains running only while its main process is active.

If the main process completes, crashes or is terminated, the container enters the `Exited` state.

## Reproduce a Normal Exit

```bash
docker run \
  --name normal-exit \
  alpine:latest \
  echo "Task completed"
```

Check:

```bash
docker ps -a
```

The container exited because the `echo` process completed successfully.

Check its exit code:

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  normal-exit
```

Expected:

```text
0
```

Exit code `0` normally means successful completion.

## Reproduce a Failed Exit

```bash
docker run \
  --name failed-exit \
  alpine:latest \
  sh -c 'echo "Application failed" >&2; exit 1'
```

Check logs:

```bash
docker logs failed-exit
```

Check the exit code:

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  failed-exit
```

Expected:

```text
1
```

## Diagnose an Exited Container

### Step 1: List All Containers

```bash
docker ps -a
```

### Step 2: Read Logs

```bash
docker logs \
  --timestamps \
  --tail 100 \
  CONTAINER_NAME
```

### Step 3: Inspect Status

```bash
docker inspect \
  --format 'Status={{.State.Status}} ExitCode={{.State.ExitCode}} Error={{.State.Error}} OOMKilled={{.State.OOMKilled}}' \
  CONTAINER_NAME
```

### Step 4: Check the Configured Command

```bash
docker inspect \
  --format 'Entrypoint={{json .Config.Entrypoint}} Cmd={{json .Config.Cmd}}' \
  CONTAINER_NAME
```

### Step 5: Check Restart Count

```bash
docker inspect \
  --format '{{.RestartCount}}' \
  CONTAINER_NAME
```

## Common Exit Codes

| Exit Code | Common Meaning |
|---:|---|
| `0` | Process completed successfully |
| `1` | General application error |
| `2` | Incorrect usage or application error |
| `126` | Command found but cannot execute |
| `127` | Command not found |
| `130` | Process interrupted, commonly with `Ctrl+C` |
| `137` | Process received `SIGKILL`; can indicate OOM termination |
| `139` | Segmentation fault |
| `143` | Process received `SIGTERM`, often from `docker stop` |

Exit codes provide clues but must be combined with logs and runtime evidence.

## Command Not Found

Reproduce:

```bash
docker run \
  --name missing-command \
  alpine:latest \
  /bin/bash
```

Alpine normally does not include Bash.

Check:

```bash
docker logs missing-command
```

Use:

```bash
docker run --rm -it \
  alpine:latest \
  /bin/sh
```

## Foreground Process Requirement

Incorrect pattern:

```bash
docker run \
  --name background-process \
  alpine:latest \
  sh -c 'sleep 300 &'
```

The shell starts `sleep` in the background and then exits. The container stops because its primary process ended.

Correct foreground process:

```bash
docker run -d \
  --name foreground-process \
  alpine:latest \
  sleep 300
```

## Restart Loop

Run an intentionally failing container:

```bash
docker run -d \
  --name restart-loop \
  --restart=always \
  alpine:latest \
  sh -c 'echo "Crashing now"; exit 1'
```

Check:

```bash
docker ps -a
docker logs restart-loop
```

Check restart count:

```bash
docker inspect \
  --format '{{.RestartCount}}' \
  restart-loop
```

Temporarily disable the restart policy:

```bash
docker update \
  --restart=no \
  restart-loop
```

Stop it:

```bash
docker stop restart-loop
```

Do not repeatedly restart a failing application without identifying the root cause.

## Exit Code 137

Check:

```bash
docker inspect \
  --format 'ExitCode={{.State.ExitCode}} OOMKilled={{.State.OOMKilled}}' \
  CONTAINER_NAME
```

If `OOMKilled=true`, investigate:

- Application memory leak
- Memory limit too low
- Unexpected workload
- Excessive cache usage
- Host memory pressure

Check limits:

```bash
docker inspect \
  --format 'Memory={{.HostConfig.Memory}} MemorySwap={{.HostConfig.MemorySwap}}' \
  CONTAINER_NAME
```

## Debug an Image Interactively

Override its normal command:

```bash
docker run --rm -it \
  --entrypoint /bin/sh \
  IMAGE_NAME:TAG
```

Inspect:

```sh
pwd
ls -la
env
cat /etc/os-release
```

## Cleanup

```bash
docker rm \
  normal-exit \
  failed-exit \
  missing-command
```

```bash
docker rm -f \
  foreground-process \
  restart-loop
```
