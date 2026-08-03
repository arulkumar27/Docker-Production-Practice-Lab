# Docker Resource Limits

Resource limits prevent one container from consuming unrestricted host resources.

This exercise applies:

- Memory limit
- Memory reservation
- CPU limit
- Process limit
- Open-file limit

## Start the Container

```bash
docker compose up -d
```

## Check Status

```bash
docker compose ps
```

## View Resource Usage

```bash
docker stats limited-service
```

Press `Ctrl+C` to exit.

Single output:

```bash
docker stats --no-stream limited-service
```

## Inspect Memory Limit

```bash
docker inspect \
  --format '{{.HostConfig.Memory}}' \
  limited-service
```

The value is displayed in bytes.

## Inspect CPU Limit

```bash
docker inspect \
  --format '{{.HostConfig.NanoCpus}}' \
  limited-service
```

## Inspect Process Limit

```bash
docker inspect \
  --format '{{.HostConfig.PidsLimit}}' \
  limited-service
```

Expected:

```text
100
```

## Inspect Open-File Limits

```bash
docker inspect \
  --format '{{json .HostConfig.Ulimits}}' \
  limited-service
```

## Configuration Explanation

| Setting | Purpose |
|---|---|
| `mem_limit: 256m` | Maximum container memory |
| `mem_reservation: 128m` | Soft memory reservation |
| `cpus: 0.50` | Maximum of half a CPU |
| `pids_limit: 100` | Maximum number of processes |
| `nofile` | Controls open-file descriptors |

## What Happens When Memory Is Exhausted?

If a process exceeds the allowed memory, it may be terminated.

Check:

```bash
docker inspect \
  --format '{{.State.OOMKilled}}' \
  limited-service
```

If killed by an out-of-memory condition:

```text
true
```

Check the exit code:

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  limited-service
```

## Why Resource Limits Matter

Without limits, a faulty or compromised container could:

- Consume excessive memory
- Consume excessive CPU
- Create too many processes
- Exhaust file descriptors
- Affect other services on the host

Limits should be selected using application testing and monitoring data.

## Cleanup

```bash
docker compose down
```
