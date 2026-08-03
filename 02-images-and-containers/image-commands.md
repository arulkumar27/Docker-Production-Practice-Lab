# Docker Image Commands

## Search for an Image

Search Docker Hub from the terminal:

```bash
docker search nginx
```

Only official images:

```bash
docker search --filter=is-official=true nginx
```

## Pull an Image

```bash
docker pull nginx:alpine
```

Pull a specific version:

```bash
docker pull nginx:1.27-alpine
```

## List Images

```bash
docker image ls
```

Alternative command:

```bash
docker images
```

List image IDs only:

```bash
docker image ls -q
```

Filter by repository:

```bash
docker image ls nginx
```

## Understand Image Details

Example output:

```text
REPOSITORY   TAG      IMAGE ID       CREATED        SIZE
nginx        alpine   abc123456789   2 weeks ago    50MB
```

| Column | Meaning |
|---|---|
| Repository | Image name |
| Tag | Image version or variation |
| Image ID | Local image identifier |
| Created | Image creation time |
| Size | Local image size |

## Inspect an Image

```bash
docker image inspect nginx:alpine
```

Display image architecture:

```bash
docker image inspect \
  --format '{{.Architecture}}' \
  nginx:alpine
```

Display operating system:

```bash
docker image inspect \
  --format '{{.Os}}' \
  nginx:alpine
```

Display the configured working directory:

```bash
docker image inspect \
  --format '{{.Config.WorkingDir}}' \
  nginx:alpine
```

Display exposed ports:

```bash
docker image inspect \
  --format '{{json .Config.ExposedPorts}}' \
  nginx:alpine
```

## View Image History

```bash
docker image history nginx:alpine
```

Do not truncate the output:

```bash
docker image history --no-trunc nginx:alpine
```

Image history helps identify:

- Image layers
- Build instructions
- Layer sizes
- Commands used during image creation

## Tag an Image

Create an additional tag:

```bash
docker tag nginx:alpine local-nginx:v1
```

Verify:

```bash
docker image ls
```

Both names can point to the same image ID.

## Image Tagging Convention

Recommended format:

```text
APPLICATION:VERSION
```

Examples:

```text
web-frontend:1.0.0
payment-api:2.3.1
inventory-service:2026.08
```

Avoid using only:

```text
application:latest
```

Explicit versions make deployments and rollbacks easier to manage.

## Build an Image

Move into the directory containing the Dockerfile:

```bash
cd custom-image
```

Build:

```bash
docker build -t arul-custom-nginx:1.0.0 .
```

Explanation:

- `docker build`: builds an image
- `-t`: assigns a name and tag
- `arul-custom-nginx`: image repository name
- `1.0.0`: image tag
- `.`: sends the current directory as build context

## Add Multiple Tags

```bash
docker tag \
  arul-custom-nginx:1.0.0 \
  arul-custom-nginx:stable
```

```bash
docker tag \
  arul-custom-nginx:1.0.0 \
  username/arul-custom-nginx:1.0.0
```

## Save an Image

Export an image to a TAR archive:

```bash
docker image save \
  -o arul-custom-nginx-1.0.0.tar \
  arul-custom-nginx:1.0.0
```

This is useful for transferring an image to a system without registry access.

## Load an Image

```bash
docker image load \
  -i arul-custom-nginx-1.0.0.tar
```

## Remove an Image

```bash
docker image rm local-nginx:v1
```

Remove using the image ID:

```bash
docker image rm IMAGE_ID
```

Force removal:

```bash
docker image rm -f IMAGE_ID
```

Use force removal carefully because containers may reference the image.

## Dangling Images

List dangling images:

```bash
docker image ls --filter dangling=true
```

Remove dangling images:

```bash
docker image prune
```

## Remove Unused Images

```bash
docker image prune -a
```

This can remove any image not currently referenced by a container. Review the confirmation message before continuing.

## View Docker Disk Usage

```bash
docker system df
```

Detailed view:

```bash
docker system df -v
```

## Complete Image Practice

```bash
docker pull nginx:alpine
docker image ls
docker image inspect nginx:alpine
docker image history nginx:alpine
docker tag nginx:alpine local-nginx:v1
docker image ls local-nginx
docker image rm local-nginx:v1
docker system df
```
