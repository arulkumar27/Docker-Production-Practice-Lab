# Docker Resource Cleanup

Docker hosts can accumulate:

- Stopped containers
- Unused images
- Dangling layers
- Unused networks
- Unused volumes
- Build cache

Cleanup must be performed carefully, especially on shared or production Docker hosts.

## Review Disk Usage

```bash
docker system df
```

Detailed output:

```bash
docker system df -v
```

## Review Containers

Running containers:

```bash
docker ps
```

All containers:

```bash
docker ps -a
```

Exited containers:

```bash
docker ps -a \
  --filter status=exited
```

## Remove One Stopped Container

```bash
docker rm CONTAINER_NAME
```

## Remove All Stopped Containers

```bash
docker container prune
```

Review the confirmation prompt before continuing.

## Review Images

```bash
docker image ls
```

Show all image layers:

```bash
docker image ls -a
```

Show dangling images:

```bash
docker image ls \
  --filter dangling=true
```

## Remove One Image

```bash
docker image rm IMAGE_NAME:TAG
```

Example:

```bash
docker image rm application:1.0.0
```

## Remove Dangling Images

```bash
docker image prune
```

## Remove All Unused Images

```bash
docker image prune -a
```

This removes images not referenced by existing containers. It may delete images required for a future rollback or offline restart.

## Remove Images Older Than a Duration

Example:

```bash
docker image prune \
  --filter "until=168h"
```

`168h` represents seven days.

Review Docker's reported targets before confirming.

## Review Networks

```bash
docker network ls
```

Inspect a network:

```bash
docker network inspect NETWORK_NAME
```

## Remove an Unused Network

```bash
docker network rm NETWORK_NAME
```

## Remove All Unused Networks

```bash
docker network prune
```

## Review Volumes

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect VOLUME_NAME
```

## Remove One Volume

```bash
docker volume rm VOLUME_NAME
```

A volume may contain database or application data. Confirm and back it up before removal.

## Remove Unused Volumes

```bash
docker volume prune
```

This can permanently delete persistent data.

## Review Build Cache

```bash
docker builder du
```

## Remove Build Cache

```bash
docker builder prune
```

Remove all unused build cache:

```bash
docker builder prune -a
```

## General System Cleanup

```bash
docker system prune
```

This normally removes unused:

- Stopped containers
- Networks
- Dangling images
- Build cache

More aggressive cleanup:

```bash
docker system prune -a
```

Include unused volumes:

```bash
docker system prune -a --volumes
```

The final command is destructive and can delete persistent data and rollback images. Do not use it as a routine command without reviewing the host.

## Docker Compose Cleanup

Remove Compose containers and networks:

```bash
docker compose down
```

Also remove named volumes:

```bash
docker compose down --volumes
```

Also remove images built or used by the Compose project:

```bash
docker compose down \
  --rmi local \
  --volumes
```

## Safe Cleanup Workflow

1. Identify the Docker host and environment.
2. List running and stopped containers.
3. Review images and tags.
4. Confirm required rollback images.
5. Review networks.
6. Inspect all candidate volumes.
7. Create and verify backups.
8. Review Docker disk usage.
9. Remove only confirmed unused resources.
10. Verify application health after cleanup.

## Production Cleanup Checklist

- [ ] Correct server confirmed
- [ ] Running workloads identified
- [ ] Required images identified
- [ ] Rollback versions preserved
- [ ] Volumes mapped to applications
- [ ] Backups verified
- [ ] Maintenance approval obtained where required
- [ ] Cleanup targets reviewed
- [ ] Application health verified afterward
- [ ] Freed disk space recorded

## Commands That Require Extra Caution

```bash
docker container prune
docker image prune -a
docker volume prune
docker system prune -a
docker system prune -a --volumes
docker compose down --volumes
```

Never copy cleanup commands into a production server without first understanding exactly which resources will be removed.
