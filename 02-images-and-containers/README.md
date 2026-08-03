# 02 — Docker Images and Containers

This section provides hands-on practice for managing Docker images and containers.

## Learning Objectives

After completing this section, I will be able to:

- Pull images from a container registry
- Understand image names and tags
- Inspect image metadata and layers
- Create multiple containers from one image
- Publish container ports
- Pass environment variables
- Inspect and troubleshoot containers
- Build and tag a basic custom image
- Export and import images
- Clean up unused Docker resources

## Docker Image

A Docker image is a read-only application package containing:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration defaults
- Filesystem layers

Example:

```bash
docker pull nginx:alpine
```

## Docker Container

A container is a running or stopped instance of an image.

```bash
docker run -d --name web-server nginx:alpine
```

Multiple independent containers can be created from the same image:

```bash
docker run -d --name web-one -p 8081:80 nginx:alpine
docker run -d --name web-two -p 8082:80 nginx:alpine
```

Both containers use the same image but have separate:

- Names
- Processes
- Writable layers
- Network interfaces
- Port mappings
- Runtime configurations

## Image Naming Format

```text
REGISTRY/REPOSITORY:TAG
```

Example:

```text
docker.io/library/nginx:alpine
```

| Part | Value |
|---|---|
| Registry | `docker.io` |
| Repository | `library/nginx` |
| Tag | `alpine` |

When no tag is provided, Docker normally uses `latest`.

```bash
docker pull nginx
```

This is interpreted as:

```bash
docker pull nginx:latest
```

For consistent deployments, use explicit version tags instead of relying on `latest`.

## Practice Sections

| File or Folder | Purpose |
|---|---|
| `image-commands.md` | Image pull, tag, inspect, save and cleanup |
| `container-commands.md` | Container creation and management |
| `nginx-container/` | Run and customize an existing Nginx container |
| `custom-image/` | Build a basic custom Nginx image |

## Practice Checklist

- [ ] Pull an image
- [ ] List and inspect images
- [ ] Understand image tags
- [ ] Run multiple containers from one image
- [ ] Publish different host ports
- [ ] View logs and container processes
- [ ] Execute commands inside a container
- [ ] Build a custom image
- [ ] Tag the custom image
- [ ] Run a container from the custom image
- [ ] Export and import an image
- [ ] Remove practice resources
