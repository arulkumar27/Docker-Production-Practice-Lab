# Docker Host Network Practice

With host networking, a container shares the Docker host's network namespace.

On a supported Linux host, the container does not receive its own separate network stack.

## Important Platform Note

Host networking behaves most directly on Linux.

Docker Desktop runs containers inside a managed Linux environment, so behaviour and feature support can differ across Windows and macOS versions.

Use a Linux system or Ubuntu EC2 instance for the clearest host-network practice.

## Start Nginx Using Host Networking

First confirm port `80` is available on the host.

```bash
sudo ss -lntp | grep ':80'
```

Run Nginx:

```bash
docker run -d \
  --name host-network-nginx \
  --network host \
  nginx:alpine
```

## Test the Service

```bash
curl http://localhost
```

Because Nginx listens on port `80`, it uses host port `80` directly.

## Port Publishing Is Not Required

This is unnecessary with host networking:

```bash
-p 8080:80
```

Docker may display a warning if port publishing is used together with host networking because published-port settings are ignored.

## Inspect the Container Network

```bash
docker inspect \
  --format '{{.HostConfig.NetworkMode}}' \
  host-network-nginx
```

Expected:

```text
host
```

## View Listening Ports

On the host:

```bash
sudo ss -lntp
```

Inside the container:

```bash
docker exec host-network-nginx \
  cat /proc/net/tcp
```

## Port Conflict Scenario

Try to run a second Nginx container using host networking:

```bash
docker run -d \
  --name second-host-nginx \
  --network host \
  nginx:alpine
```

Both containers attempt to use host port `80`.

The second container may exit because the port is already in use.

Check:

```bash
docker ps -a
docker logs second-host-nginx
```

## Advantages

- No bridge-network address translation
- Direct use of host networking
- Useful for certain network tools
- Can reduce some networking overhead

## Disadvantages

- Reduced network isolation
- Higher possibility of port conflicts
- A container can access host network interfaces
- Port mappings cannot isolate services
- Behaviour can vary with Docker Desktop
- Not suitable as the default choice for most applications

## Bridge vs Host Network

| Bridge Network | Host Network |
|---|---|
| Separate container network namespace | Shares host network namespace |
| Container receives its own IP | Uses host networking |
| Uses port publishing | Normally does not use port publishing |
| Better isolation | Reduced isolation |
| Multiple containers can reuse internal ports | Host ports can conflict directly |
| Common for application containers | Used for specific requirements |

## Security Consideration

Host networking gives a container broader visibility into the host network environment.

Only trusted containers should use it.

Use a bridge network unless host networking is specifically required.

## Cleanup

```bash
docker rm -f \
  host-network-nginx \
  second-host-nginx
```
