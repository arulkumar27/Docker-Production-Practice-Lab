# 11 — Docker Troubleshooting

This section provides a structured approach for diagnosing Docker image, container, network, storage, permission and application failures.

## Learning Objectives

After completing this section, I will be able to:

- Diagnose containers that exit immediately
- Interpret container exit codes
- Check container logs and configuration
- Resolve Docker daemon permission errors
- Troubleshoot published-port problems
- Diagnose container DNS failures
- Investigate volume and bind-mount errors
- Identify CPU and memory problems
- Use a repeatable troubleshooting workflow
- Document root cause, resolution and validation

## Troubleshooting Flow

```text
Confirm the symptom
        ↓
Check container status
        ↓
Read container logs
        ↓
Inspect exit code and configuration
        ↓
Check resources, network and storage
        ↓
Reproduce the failure
        ↓
Apply the smallest safe correction
        ↓
Validate the application
        ↓
Document root cause and resolution
```

## Essential Commands

```bash
docker version
docker info
docker system df
docker ps
docker ps -a
docker logs CONTAINER_NAME
docker inspect CONTAINER_NAME
docker top CONTAINER_NAME
docker stats --no-stream CONTAINER_NAME
docker port CONTAINER_NAME
docker network inspect NETWORK_NAME
docker volume inspect VOLUME_NAME
```

## First Five Checks

### 1. Is the Docker daemon running?

```bash
sudo systemctl status docker
```

### 2. Does the container exist?

```bash
docker ps -a
```

### 3. What do the logs show?

```bash
docker logs \
  --tail 100 \
  CONTAINER_NAME
```

### 4. What was the exit code?

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  CONTAINER_NAME
```

### 5. Was it killed because of memory usage?

```bash
docker inspect \
  --format '{{.State.OOMKilled}}' \
  CONTAINER_NAME
```

## Common Failure Categories

| Symptom | Possible Cause |
|---|---|
| Container exits immediately | Main process completed or failed |
| Permission denied | Docker socket, filesystem or user permissions |
| Port already allocated | Host port is already in use |
| Website does not open | Port, firewall, application or security-group issue |
| Containers cannot communicate | Different networks, incorrect name or wrong port |
| Hostname cannot resolve | DNS or network-membership issue |
| Volume data missing | Wrong volume, path or container recreated without mount |
| Bind mount fails | Incorrect or missing host path |
| Container restarts continuously | Application crash or failed configuration |
| Exit code 137 | Often forced termination or memory exhaustion |
| Unhealthy status | Health-check command is failing |
| Image pull fails | Registry, tag, authentication or network issue |

## Troubleshooting Principles

- Read the exact error before changing configuration
- Change one thing at a time
- Do not delete containers or volumes before collecting evidence
- Do not immediately use destructive cleanup commands
- Test from both host and container when troubleshooting networks
- Confirm service names and ports
- Inspect actual runtime configuration
- Preserve important logs
- Validate the correction
- Document the root cause

## Files in This Folder

| File | Purpose |
|---|---|
| `exited-containers.md` | Container exit and restart troubleshooting |
| `permission-errors.md` | Docker daemon and file-permission errors |
| `networking-errors.md` | Port, DNS and connectivity problems |
| `volume-errors.md` | Bind-mount and named-volume problems |
| `troubleshooting-checklist.md` | Reusable incident checklist |
