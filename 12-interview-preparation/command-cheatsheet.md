# Docker Command Cheatsheet

## Docker Information

```bash
docker version
docker info
docker system df
```

## Images

```bash
docker pull nginx:alpine
docker image ls
docker image inspect nginx:alpine
docker image history nginx:alpine
docker image rm nginx:alpine
```

## Build an Image

```bash
docker build -t application:1.0.0 .
```

## Containers

```bash
docker run -d --name web -p 8080:80 nginx:alpine
docker ps
docker ps -a
docker logs web
docker inspect web
docker exec -it web /bin/sh
docker stop web
docker start web
docker restart web
docker rm web
```

## Monitoring

```bash
docker stats
docker stats --no-stream
docker top CONTAINER_NAME
```

## Volumes

```bash
docker volume create application-data
docker volume ls
docker volume inspect application-data
docker volume rm application-data
```

## Networks

```bash
docker network create application-network
docker network ls
docker network inspect application-network
docker network connect application-network CONTAINER_NAME
docker network disconnect application-network CONTAINER_NAME
docker network rm application-network
```

## Docker Compose

```bash
docker compose config
docker compose up -d
docker compose ps
docker compose logs -f
docker compose restart
docker compose down
docker compose down --volumes
```

## Registry

```bash
docker login
docker tag application:1.0.0 username/application:1.0.0
docker push username/application:1.0.0
docker pull username/application:1.0.0
docker logout
```

## Cleanup

```bash
docker container prune
docker image prune
docker network prune
docker volume prune
docker system prune
```

Review resources carefully before running cleanup commands.
