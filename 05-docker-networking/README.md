# 05 — Docker Networking

Docker networking enables communication between containers, the Docker host, external systems, and the internet.

This section covers default bridge networking, custom bridge networks, host networking, container DNS, port publishing, and network troubleshooting.

## Learning Objectives

After completing this section, I will be able to:

- Understand Docker networking architecture
- List and inspect Docker networks
- Explain bridge and host networking
- Create custom bridge networks
- Connect and disconnect containers
- Use container names for service discovery
- Understand port publishing
- Isolate application services
- Troubleshoot container communication
- Understand basic network security practices

## Docker Network Drivers

| Driver | Purpose |
|---|---|
| `bridge` | Container networking on a single Docker host |
| `host` | Container shares the host network namespace |
| `none` | Container has no external network connectivity |
| `overlay` | Multi-host networking, commonly with Docker Swarm |
| `macvlan` | Assigns a network identity similar to a physical device |
| `ipvlan` | Provides network integration using parent-interface addressing |

This repository focuses mainly on bridge and host networking.

## List Docker Networks

```bash
docker network ls
```

A normal Docker installation commonly includes:

```text
bridge
host
none
```

## Inspect a Network

```bash
docker network inspect bridge
```

## Default Bridge Network

When a network is not specified, Docker normally connects the container to the default `bridge` network.

```bash
docker run -d \
  --name default-nginx \
  nginx:alpine
```

Inspect its networks:

```bash
docker inspect \
  --format '{{json .NetworkSettings.Networks}}' \
  default-nginx
```

## Custom Bridge Network

Create a network:

```bash
docker network create application-network
```

Run two containers:

```bash
docker run -d \
  --name frontend \
  --network application-network \
  nginx:alpine
```

```bash
docker run -d \
  --name backend \
  --network application-network \
  nginx:alpine
```

Containers on a custom bridge network can communicate using container names.

```bash
docker exec frontend ping -c 3 backend
```

## Port Publishing

A container port is not automatically exposed through the host.

Publish a port:

```bash
docker run -d \
  --name public-nginx \
  -p 8080:80 \
  nginx:alpine
```

Port mapping:

```text
HOST_PORT:CONTAINER_PORT
8080:80
```

Request flow:

```text
Client → Docker host port 8080 → Container port 80
```

## EXPOSE vs `-p`

Dockerfile instruction:

```dockerfile
EXPOSE 80
```

`EXPOSE` documents the port used by the application. It does not publish the port to the host.

Runtime publishing:

```bash
docker run -p 8080:80 nginx:alpine
```

The `-p` option makes the container service accessible through the host.

## Publish to Localhost Only

```bash
docker run -d \
  --name internal-nginx \
  -p 127.0.0.1:8080:80 \
  nginx:alpine
```

This binds the published port only to the host loopback interface.

## No-Network Container

```bash
docker run --rm \
  --network none \
  alpine:latest \
  ip address
```

The container will only have its loopback interface.

## Useful Commands

```bash
docker network ls
docker network create NETWORK_NAME
docker network inspect NETWORK_NAME
docker network connect NETWORK_NAME CONTAINER_NAME
docker network disconnect NETWORK_NAME CONTAINER_NAME
docker network rm NETWORK_NAME
docker port CONTAINER_NAME
```

## Network Troubleshooting Commands

```bash
docker ps
docker port CONTAINER_NAME
docker inspect CONTAINER_NAME
docker network ls
docker network inspect NETWORK_NAME
docker logs CONTAINER_NAME
docker exec CONTAINER_NAME ip address
docker exec CONTAINER_NAME ip route
docker exec CONTAINER_NAME cat /etc/resolv.conf
```

Minimal images may not include utilities such as `ping`, `curl`, `dig`, or `netstat`. Use a dedicated troubleshooting container when required.

Example:

```bash
docker run --rm -it \
  --network application-network \
  nicolaka/netshoot
```

## Files in This Folder

| Folder | Purpose |
|---|---|
| `bridge-network/` | Practise default bridge networking |
| `host-network/` | Understand host-network behaviour |
| `custom-network/` | Create isolated application networks |
| `container-dns/` | Use Docker DNS and service names |

## Practice Checklist

- [ ] List Docker networks
- [ ] Inspect the default bridge
- [ ] Create a custom network
- [ ] Connect containers to a network
- [ ] Test container-to-container communication
- [ ] Use container names instead of IP addresses
- [ ] Publish a container port
- [ ] Bind a port to localhost
- [ ] Disconnect a container
- [ ] Remove an unused network
- [ ] Troubleshoot a failed connection
