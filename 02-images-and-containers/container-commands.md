# Docker Container Commands

## Create and Start a Container

```bash
docker run -d \
  --name practice-nginx \
  -p 8080:80 \
  nginx:alpine
```

Explanation:

- `docker run`: creates and starts a container
- `-d`: runs in detached mode
- `--name`: assigns a readable name
- `-p 8080:80`: maps host port `8080` to container port `80`
- `nginx:alpine`: image name and tag

## Create Without Starting

```bash
docker create \
  --name created-nginx \
  -p 8081:80 \
  nginx:alpine
```

Start it later:

```bash
docker start created-nginx
```

## List Containers

Running containers:

```bash
docker container ls
```

All containers:

```bash
docker container ls -a
```

Only container IDs:

```bash
docker container ls -q
```

## Run Multiple Containers from One Image

```bash
docker run -d --name web-one -p 8081:80 nginx:alpine
docker run -d --name web-two -p 8082:80 nginx:alpine
docker run -d --name web-three -p 8083:80 nginx:alpine
```

Verify:

```bash
docker ps
```

Test:

```bash
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
```

The host ports must be different because only one container can use a specific host IP and port combination at a time.

## Publish a Port to Localhost Only

```bash
docker run -d \
  --name local-nginx \
  -p 127.0.0.1:8084:80 \
  nginx:alpine
```

This prevents direct access through the server’s external network interfaces.

## View Logs

```bash
docker logs practice-nginx
```

Follow logs:

```bash
docker logs -f practice-nginx
```

Latest 20 lines:

```bash
docker logs --tail 20 practice-nginx
```

Logs with timestamps:

```bash
docker logs --timestamps practice-nginx
```

## Inspect a Container

```bash
docker inspect practice-nginx
```

Display container status:

```bash
docker inspect \
  --format '{{.State.Status}}' \
  practice-nginx
```

Display restart count:

```bash
docker inspect \
  --format '{{.RestartCount}}' \
  practice-nginx
```

Display container IP address:

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  practice-nginx
```

## Execute Commands Inside a Container

Open an Alpine shell:

```bash
docker exec -it practice-nginx /bin/sh
```

Inside the container:

```sh
hostname
whoami
pwd
ls -la
cat /etc/os-release
```

Exit:

```sh
exit
```

Run without opening a shell:

```bash
docker exec practice-nginx nginx -v
```

## Container Processes

```bash
docker top practice-nginx
```

Inside the container:

```bash
docker exec practice-nginx ps
```

## Resource Usage

```bash
docker stats practice-nginx
```

Single output:

```bash
docker stats --no-stream practice-nginx
```

## Environment Variables

Run a container with an environment variable:

```bash
docker run --rm \
  --name environment-practice \
  -e APP_ENV=development \
  alpine:latest \
  env
```

Pass multiple values:

```bash
docker run --rm \
  -e APP_ENV=production \
  -e APP_VERSION=1.0.0 \
  alpine:latest \
  env
```

Do not pass real passwords directly through commands committed to Git.

## Container Hostname

```bash
docker run --rm \
  --hostname application-server \
  alpine:latest \
  hostname
```

## Set Resource Limits

```bash
docker run -d \
  --name limited-nginx \
  --memory="256m" \
  --cpus="0.50" \
  nginx:alpine
```

Inspect the configured memory limit:

```bash
docker inspect \
  --format '{{.HostConfig.Memory}}' \
  limited-nginx
```

## Restart Policy

```bash
docker run -d \
  --name restart-nginx \
  --restart=unless-stopped \
  nginx:alpine
```

Inspect the policy:

```bash
docker inspect \
  --format '{{.HostConfig.RestartPolicy.Name}}' \
  restart-nginx
```

## Stop, Start and Restart

```bash
docker stop practice-nginx
docker start practice-nginx
docker restart practice-nginx
```

## Rename a Container

```bash
docker rename practice-nginx renamed-nginx
```

## Copy Files

Copy from the host to the container:

```bash
docker cp index.html \
  renamed-nginx:/usr/share/nginx/html/index.html
```

Copy from the container to the host:

```bash
docker cp \
  renamed-nginx:/etc/nginx/nginx.conf \
  ./nginx.conf
```

## Remove Containers

Remove a stopped container:

```bash
docker stop renamed-nginx
docker rm renamed-nginx
```

Automatically remove after execution:

```bash
docker run --rm alpine:latest echo "Temporary container"
```

Force-remove a running container:

```bash
docker rm -f limited-nginx
```

## Container Cleanup

List stopped containers:

```bash
docker ps -a --filter status=exited
```

Remove stopped containers:

```bash
docker container prune
```

## Practice Cleanup

```bash
docker rm -f \
  created-nginx \
  web-one \
  web-two \
  web-three \
  local-nginx \
  restart-nginx
```

If a named container does not exist, Docker may display an error for that name. The other valid containers will still be processed.
