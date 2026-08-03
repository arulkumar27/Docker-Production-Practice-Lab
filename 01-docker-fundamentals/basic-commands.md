# Basic Docker Commands

This file provides commonly used Docker commands for daily practice.

## Docker Information

```bash
docker --version
docker version
docker info
docker system df
```

## Image Commands

Search Docker Hub:

```bash
docker search nginx
```

Download an image:

```bash
docker pull nginx:alpine
```

List local images:

```bash
docker image ls
```

Inspect an image:

```bash
docker image inspect nginx:alpine
```

View image history:

```bash
docker image history nginx:alpine
```

Remove an image:

```bash
docker image rm nginx:alpine
```

## Run Containers

Run in the foreground:

```bash
docker run nginx:alpine
```

Stop it using:

```text
Ctrl+C
```

Run in detached mode:

```bash
docker run -d --name web-server nginx:alpine
```

Run and publish a port:

```bash
docker run -d \
  --name published-web \
  -p 8080:80 \
  nginx:alpine
```

Port mapping:

```text
HOST_PORT:CONTAINER_PORT
8080:80
```

Traffic arriving at port `8080` on the host is forwarded to port `80` inside the container.

## List Containers

Running containers:

```bash
docker ps
```

All containers:

```bash
docker ps -a
```

Only container IDs:

```bash
docker ps -q
```

View the latest created container:

```bash
docker ps -l
```

## Container Management

```bash
docker stop published-web
docker start published-web
docker restart published-web
docker pause published-web
docker unpause published-web
docker kill published-web
docker rm published-web
```

Force-remove a running container:

```bash
docker rm -f published-web
```

## Logs

View logs:

```bash
docker logs web-server
```

Follow logs continuously:

```bash
docker logs -f web-server
```

Display timestamps:

```bash
docker logs --timestamps web-server
```

Display the latest 50 lines:

```bash
docker logs --tail 50 web-server
```

Press `Ctrl+C` to stop following logs. The container will continue running.

## Execute Commands Inside a Container

Open a shell:

```bash
docker exec -it web-server /bin/sh
```

Use `/bin/bash` only when Bash is installed:

```bash
docker exec -it web-server /bin/bash
```

Run a single command:

```bash
docker exec web-server nginx -v
```

## Inspect Containers

```bash
docker inspect web-server
```

Display the container IP address:

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  web-server
```

Display port mappings:

```bash
docker port web-server
```

Display running processes:

```bash
docker top web-server
```

## Resource Monitoring

Monitor all running containers:

```bash
docker stats
```

Monitor one container:

```bash
docker stats web-server
```

Press `Ctrl+C` to return to the terminal.

View statistics once:

```bash
docker stats --no-stream
```

## Copy Files

Copy a local file into a container:

```bash
docker cp index.html web-server:/usr/share/nginx/html/index.html
```

Copy a file from a container:

```bash
docker cp web-server:/etc/nginx/nginx.conf ./nginx.conf
```

## Filter Containers

Running containers based on an image:

```bash
docker ps --filter ancestor=nginx:alpine
```

Exited containers:

```bash
docker ps -a --filter status=exited
```

Container based on its name:

```bash
docker ps -a --filter name=web-server
```

## Rename a Container

```bash
docker rename web-server nginx-web
```

## Clean Up Unused Resources

Remove stopped containers:

```bash
docker container prune
```

Remove unused images:

```bash
docker image prune
```

Remove unused networks:

```bash
docker network prune
```

Review disk usage before cleanup:

```bash
docker system df
```

Remove unused Docker resources:

```bash
docker system prune
```

Cleanup commands can delete reusable resources. Review the confirmation message carefully before continuing.

## Complete Practice Session

```bash
docker pull nginx:alpine

docker run -d \
  --name fundamentals-web \
  -p 8080:80 \
  nginx:alpine

docker ps
docker logs fundamentals-web
docker inspect fundamentals-web
docker stats --no-stream fundamentals-web
docker exec fundamentals-web nginx -v
docker stop fundamentals-web
docker start fundamentals-web
docker restart fundamentals-web
docker stop fundamentals-web
docker rm fundamentals-web
```

## Command Summary

| Requirement | Command |
|---|---|
| Download image | `docker pull IMAGE` |
| List images | `docker image ls` |
| Run container | `docker run IMAGE` |
| Run in background | `docker run -d IMAGE` |
| Publish port | `docker run -p HOST:CONTAINER IMAGE` |
| List running containers | `docker ps` |
| List all containers | `docker ps -a` |
| View logs | `docker logs CONTAINER` |
| Enter container | `docker exec -it CONTAINER /bin/sh` |
| Stop container | `docker stop CONTAINER` |
| Start container | `docker start CONTAINER` |
| Restart container | `docker restart CONTAINER` |
| Remove container | `docker rm CONTAINER` |
| Remove image | `docker image rm IMAGE` |
| Monitor resources | `docker stats` |
| Inspect container | `docker inspect CONTAINER` |
