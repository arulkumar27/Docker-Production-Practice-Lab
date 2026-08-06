# Docker Troubleshooting Checklist

Use this checklist when diagnosing a Docker problem.

## 1. Record the Problem

```text
Date and time:
Environment:
Docker host:
Application:
Affected container:
Reported symptom:
Recent changes:
Business or learning impact:
```

## 2. Verify Docker

```bash
docker version
docker info
```

On Linux:

```bash
sudo systemctl status docker
```

## 3. Check Container Status

```bash
docker ps
docker ps -a
```

Record:

```text
Container name:
Image:
Status:
Exit code:
Restart count:
Health status:
```

## 4. Collect Logs

```bash
docker logs \
  --timestamps \
  --tail 200 \
  CONTAINER_NAME
```

For Compose:

```bash
docker compose logs \
  --timestamps \
  --tail 200 \
  SERVICE_NAME
```

## 5. Inspect Runtime State

```bash
docker inspect CONTAINER_NAME
```

Summary:

```bash
docker inspect \
  --format 'Status={{.State.Status}} Exit={{.State.ExitCode}} OOM={{.State.OOMKilled}} Error={{.State.Error}} Restarts={{.RestartCount}}' \
  CONTAINER_NAME
```

## 6. Check Resources

```bash
docker stats --no-stream CONTAINER_NAME
docker top CONTAINER_NAME
docker system df
df -h
df -i
```

## 7. Check Image

```bash
docker image inspect IMAGE_NAME:TAG
docker image history IMAGE_NAME:TAG
```

Confirm:

- Correct image name
- Correct tag
- Correct architecture
- Correct entrypoint
- Correct command
- Correct environment

## 8. Check Network

```bash
docker port CONTAINER_NAME
docker network ls
docker network inspect NETWORK_NAME
```

Inside the container:

```bash
docker exec CONTAINER_NAME ip address
docker exec CONTAINER_NAME ip route
docker exec CONTAINER_NAME cat /etc/resolv.conf
```

Test:

```bash
curl -v http://127.0.0.1:HOST_PORT
```

From the same Docker network:

```bash
docker run --rm \
  --network NETWORK_NAME \
  nicolaka/netshoot \
  curl -v http://SERVICE_NAME:SERVICE_PORT
```

## 9. Check Storage

```bash
docker volume ls
docker volume inspect VOLUME_NAME
```

Container mounts:

```bash
docker inspect \
  --format '{{json .Mounts}}' \
  CONTAINER_NAME
```

Confirm:

- Correct source
- Correct destination
- Correct volume
- Correct permissions
- Correct read/write mode
- Sufficient disk space

## 10. Check Security Restrictions

Inspect:

```bash
docker inspect \
  --format 'User={{.Config.User}} ReadOnly={{.HostConfig.ReadonlyRootfs}} CapDrop={{json .HostConfig.CapDrop}} SecurityOptions={{json .HostConfig.SecurityOpt}}' \
  CONTAINER_NAME
```

Confirm the application has only the permissions it requires.

## 11. Check Compose Configuration

```bash
docker compose config
docker compose ps
docker compose logs
```

Confirm:

- Environment variables
- Service names
- Network names
- Volume names
- Health checks
- Dependencies
- Published ports

## 12. Validate the Correction

After applying the correction:

```bash
docker ps
docker logs CONTAINER_NAME
docker stats --no-stream CONTAINER_NAME
curl --fail http://127.0.0.1:HOST_PORT
```

Confirm:

- Container remains running
- Health status becomes healthy
- Application responds correctly
- Logs do not show recurring errors
- Data remains available
- Dependent services can connect
- Resource usage is acceptable

## 13. Document the Result

```text
Symptoms:
Affected components:
Evidence collected:
Root cause:
Correction applied:
Validation performed:
Rollback method:
Preventive action:
Current status:
```

## Interview Explanation

```text
I follow a layer-by-layer troubleshooting approach. First, I confirm the
container state using docker ps -a and review its logs. I then inspect the
exit code, health status, restart count and OOM status. Based on the evidence,
I check the image configuration, resource limits, network connectivity,
service discovery and mounted storage. I apply one controlled correction,
validate the application endpoint and health status, and document the root
cause and preventive action.
```

## Important Safety Rule

Do not use destructive commands until you identify the exact resources and preserve required data.

Commands requiring careful review include:

```bash
docker volume prune
docker image prune -a
docker system prune -a
docker system prune -a --volumes
docker compose down --volumes
```
