# Docker Scenario Questions

## Scenario 1: Container Exits Immediately

I would check:

```bash
docker ps -a
docker logs CONTAINER_NAME
docker inspect CONTAINER_NAME
```

I would verify the main process, exit code, command and application configuration.

## Scenario 2: Website Is Not Opening

I would check:

```bash
docker ps
docker logs CONTAINER_NAME
docker port CONTAINER_NAME
curl http://localhost:HOST_PORT
```

I would verify port mapping, application port, host firewall and cloud security group.

## Scenario 3: Container Shows Permission Denied

I would check:

- Container runtime user
- File ownership
- Mount permissions
- Docker socket permissions
- Read-only filesystem configuration

## Scenario 4: Two Containers Cannot Communicate

I would verify that both containers are connected to the same custom Docker network.

```bash
docker network inspect NETWORK_NAME
```

I would use the service name and container port instead of `localhost` and the published host port.

## Scenario 5: Data Disappeared

I would inspect the container mounts:

```bash
docker inspect CONTAINER_NAME
docker volume ls
docker volume inspect VOLUME_NAME
```

The container may have been recreated without its original volume.

## Scenario 6: Port Is Already Allocated

I would identify which container or host process is using the port:

```bash
docker ps
sudo ss -lntp
```

Then I would stop the conflicting service or select another host port.

## Scenario 7: Image Size Is Too Large

I would:

- Use a smaller suitable base image
- Use a multi-stage build
- Add `.dockerignore`
- Remove unnecessary packages
- Clean package caches
- Copy only required files

## Scenario 8: Container Uses Too Much Memory

I would check:

```bash
docker stats
docker inspect CONTAINER_NAME
```

I would investigate application memory usage and configure suitable memory limits.

## Scenario 9: Docker Works with sudo Only

The user probably lacks access to the Docker socket.

```bash
sudo usermod -aG docker "$USER"
newgrp docker
```

Docker group membership provides powerful host access and should be limited to trusted users.

## Scenario 10: How Would You Secure a Container?

I would:

- Use a trusted minimal image
- Run as non-root
- Use a read-only filesystem
- Drop unnecessary capabilities
- Apply resource limits
- Protect secrets
- Scan the image
- Publish only required ports
