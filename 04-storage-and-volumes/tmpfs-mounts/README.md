# Docker tmpfs Mount Practice

A tmpfs mount stores data in the Docker host's memory instead of permanent disk storage.

Data in a tmpfs mount is temporary and should not be used for information that must survive container or host restarts.

## Common Use Cases

- Temporary application files
- Runtime caches
- Session information
- Temporary processing data
- Sensitive temporary data
- Writable paths for read-only containers

## Start a Container with tmpfs

```bash
docker run -d \
  --name tmpfs-practice \
  --mount type=tmpfs,target=/temporary,tmpfs-size=67108864,tmpfs-mode=1770 \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

Configuration:

| Setting | Value |
|---|---|
| Container path | `/temporary` |
| Maximum size | 64 MiB |
| Permission mode | `1770` |

## Write Temporary Data

```bash
docker exec tmpfs-practice \
  sh -c 'echo "Temporary memory data" > /temporary/message.txt'
```

Read it:

```bash
docker exec tmpfs-practice \
  cat /temporary/message.txt
```

## Inspect the Mount

```bash
docker inspect \
  --format '{{json .HostConfig.Tmpfs}}' \
  tmpfs-practice
```

You can also view all mount information:

```bash
docker inspect tmpfs-practice
```

## Check Filesystem Usage

```bash
docker exec tmpfs-practice \
  df -h /temporary
```

## Test Temporary Behaviour

Remove the container:

```bash
docker rm -f tmpfs-practice
```

Create another container with the same target:

```bash
docker run -d \
  --name tmpfs-replacement \
  --mount type=tmpfs,target=/temporary,tmpfs-size=67108864 \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

Check the directory:

```bash
docker exec tmpfs-replacement \
  ls -la /temporary
```

The old `message.txt` will not exist because tmpfs does not provide persistent storage.

## Read-Only Root Filesystem with tmpfs

Run a container with a read-only root filesystem:

```bash
docker run -d \
  --name secure-temporary-container \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

Try writing to the root filesystem:

```bash
docker exec secure-temporary-container \
  touch /test-file
```

This should fail.

Try writing to `/tmp`:

```bash
docker exec secure-temporary-container \
  touch /tmp/test-file
```

This should succeed because `/tmp` is a writable tmpfs mount.

Verify:

```bash
docker exec secure-temporary-container \
  ls -la /tmp
```

## Named Volume vs tmpfs

| Named Volume | tmpfs Mount |
|---|---|
| Stored on disk | Stored in memory |
| Persistent | Temporary |
| Survives container removal | Does not provide durable storage |
| Suitable for databases | Not suitable for database persistence |
| Can be backed up | Normally does not require backup |
| Slower than memory | Fast memory-based access |

## Security Considerations

- tmpfs data may still consume host memory
- Set an appropriate size limit
- Do not store permanent data in tmpfs
- Use `noexec` when files do not need execution
- Use `nosuid` to reduce privilege-related risks
- Monitor container and host memory usage

## Cleanup

```bash
docker rm -f \
  tmpfs-replacement \
  secure-temporary-container
```
