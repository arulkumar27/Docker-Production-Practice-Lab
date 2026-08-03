# 04 — Docker Storage and Volumes

Containers use a writable layer for temporary runtime changes. Data stored only in this layer is deleted when the container is removed.

Docker provides persistent and temporary storage options for different requirements.

## Learning Objectives

After completing this section, I will be able to:

- Understand the container writable layer
- Explain why persistent storage is required
- Use bind mounts
- Create and manage named volumes
- Use temporary `tmpfs` mounts
- Inspect volume configuration
- Share data between containers
- Back up and restore named volumes
- Understand volume-related security considerations

## Docker Storage Types

| Storage Type | Managed By | Common Usage |
|---|---|---|
| Writable layer | Docker | Temporary container changes |
| Bind mount | User and host OS | Development files and configuration |
| Named volume | Docker | Databases and persistent application data |
| tmpfs mount | Host memory | Temporary and sensitive runtime data |

## Container Writable Layer

Every container receives a writable filesystem layer.

Example:

```bash
docker run -d --name storage-test nginx:alpine
```

Create a file inside it:

```bash
docker exec storage-test \
  sh -c 'echo "Temporary data" > /tmp/example.txt'
```

Verify:

```bash
docker exec storage-test cat /tmp/example.txt
```

Remove the container:

```bash
docker rm -f storage-test
```

When a new container is created, the previous file will not exist.

This is why databases and important application data should not depend only on the container writable layer.

## Bind Mount

A bind mount connects an existing host file or directory to a path inside a container.

```bash
docker run -d \
  --name bind-web \
  -p 8080:80 \
  --mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html,readonly \
  nginx:alpine
```

## Named Volume

A named volume is created and managed by Docker.

```bash
docker volume create application-data
```

Attach it:

```bash
docker run -d \
  --name volume-container \
  --mount type=volume,source=application-data,target=/data \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

## tmpfs Mount

A `tmpfs` mount stores data in host memory instead of persistent storage.

```bash
docker run -d \
  --name temporary-storage \
  --mount type=tmpfs,target=/temporary,tmpfs-size=67108864 \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

The value `67108864` represents 64 MiB in bytes.

## `--mount` vs `-v`

Recommended explicit syntax:

```bash
docker run \
  --mount type=volume,source=my-data,target=/data \
  alpine:latest
```

Short syntax:

```bash
docker run \
  -v my-data:/data \
  alpine:latest
```

`--mount` is more descriptive and reduces ambiguity.

## Important Storage Principle

Containers should be replaceable.

Persistent data should live outside the container writable layer using an appropriate storage mechanism.

## Files in This Folder

| Folder | Purpose |
|---|---|
| `bind-mounts/` | Mount host files into a container |
| `named-volumes/` | Persist Docker-managed data |
| `tmpfs-mounts/` | Store temporary data in memory |
| `backup-and-restore/` | Back up and restore named volumes |

## Practice Checklist

- [ ] Explain why container data can disappear
- [ ] Create a bind mount
- [ ] Create a read-only bind mount
- [ ] Create a named volume
- [ ] Share a volume between containers
- [ ] Inspect a volume
- [ ] Use a tmpfs mount
- [ ] Back up a named volume
- [ ] Restore a named volume
- [ ] Remove unused volumes safely
