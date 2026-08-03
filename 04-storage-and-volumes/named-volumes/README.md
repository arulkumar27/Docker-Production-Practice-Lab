# Docker Named Volume Practice

Named volumes are created and managed by Docker.

They are commonly used for:

- Database files
- Uploaded application files
- Persistent application data
- Service configuration
- Data shared between containers

## Create a Named Volume

```bash
docker volume create application-data
```

## List Volumes

```bash
docker volume ls
```

## Inspect the Volume

```bash
docker volume inspect application-data
```

The output contains information such as:

- Volume name
- Volume driver
- Mount point
- Labels
- Scope
- Creation time

Docker manages the mount-point location. Applications should access the volume through the configured container path.

## Write Data into the Volume

```bash
docker run --rm \
  --mount type=volume,source=application-data,target=/data \
  alpine:latest \
  sh -c 'echo "Persistent Docker volume data" > /data/message.txt'
```

The temporary container is automatically removed because `--rm` was used.

The volume and its data remain.

## Read Data from Another Container

```bash
docker run --rm \
  --mount type=volume,source=application-data,target=/data,readonly \
  alpine:latest \
  cat /data/message.txt
```

Expected output:

```text
Persistent Docker volume data
```

This proves that the volume exists independently of the original container.

## Nginx Persistent Content Example

Create a volume:

```bash
docker volume create nginx-content
```

Add a website to it:

```bash
docker run --rm \
  --mount type=volume,source=nginx-content,target=/content \
  alpine:latest \
  sh -c 'cat > /content/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Named Volume</title>
</head>
<body>
  <h1>Persistent Nginx Content</h1>
  <p>This page is stored in a Docker named volume.</p>
</body>
</html>
EOF'
```

Run Nginx:

```bash
docker run -d \
  --name volume-nginx \
  -p 8080:80 \
  --mount type=volume,source=nginx-content,target=/usr/share/nginx/html,readonly \
  nginx:alpine
```

Test:

```bash
curl http://localhost:8080
```

## Replace the Container

Remove the first container:

```bash
docker rm -f volume-nginx
```

Create a replacement container using the same volume:

```bash
docker run -d \
  --name replacement-nginx \
  -p 8080:80 \
  --mount type=volume,source=nginx-content,target=/usr/share/nginx/html,readonly \
  nginx:alpine
```

Test again:

```bash
curl http://localhost:8080
```

The website remains available because its files are stored in the named volume.

## Share Data Between Containers

Start a writer container:

```bash
docker run -d \
  --name volume-writer \
  --mount type=volume,source=shared-data,target=/shared \
  alpine:latest \
  sh -c 'while true; do date >> /shared/activity.log; sleep 5; done'
```

Read the data using another temporary container:

```bash
docker run --rm \
  --mount type=volume,source=shared-data,target=/shared,readonly \
  alpine:latest \
  tail /shared/activity.log
```

Inspect the shared volume:

```bash
docker volume inspect shared-data
```

## Read-Only Volume

The following container can read but cannot modify the volume:

```bash
docker run --rm \
  --mount type=volume,source=shared-data,target=/shared,readonly \
  alpine:latest \
  cat /shared/activity.log
```

Try writing:

```bash
docker run --rm \
  --mount type=volume,source=shared-data,target=/shared,readonly \
  alpine:latest \
  touch /shared/test.txt
```

The write operation should fail.

## View Docker Storage Usage

```bash
docker system df
```

Detailed output:

```bash
docker system df -v
```

## Remove Containers

```bash
docker rm -f replacement-nginx volume-writer
```

## Remove Practice Volumes

```bash
docker volume rm application-data
docker volume rm nginx-content
docker volume rm shared-data
```

## Remove Unused Volumes

List volumes first:

```bash
docker volume ls
```

Then remove unused volumes:

```bash
docker volume prune
```

This command can permanently delete stored application data. Review the confirmation message carefully before proceeding.
