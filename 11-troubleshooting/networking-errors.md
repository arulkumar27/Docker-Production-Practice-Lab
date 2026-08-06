# Troubleshooting Docker Networking Errors

Container network failures can occur at several layers:

```text
Client
  ↓
Host firewall or cloud security group
  ↓
Published Docker port
  ↓
Container network
  ↓
Application listening port
  ↓
Application process
```

Each layer must be checked separately.

## Scenario 1: Website Does Not Open

Start Nginx:

```bash
docker run -d \
  --name network-nginx \
  -p 8080:80 \
  nginx:alpine
```

### Check Container Status

```bash
docker ps
```

### Check Logs

```bash
docker logs network-nginx
```

### Check Port Mapping

```bash
docker port network-nginx
```

Expected:

```text
80/tcp -> 0.0.0.0:8080
```

### Test from the Host

```bash
curl -v http://127.0.0.1:8080
```

### Test Inside the Container

```bash
docker exec network-nginx \
  wget -qO- http://127.0.0.1:80
```

If the inside test succeeds but the host test fails, investigate port publishing or the host firewall.

If both fail, investigate the application process and configured port.

## AWS EC2 Checks

If localhost works but the EC2 public IP does not:

- Confirm the instance has a public IP
- Confirm the security group permits the required port
- Confirm the network ACL permits the traffic
- Confirm the subnet route table has an internet-gateway route
- Confirm the host firewall permits the port
- Confirm the container port is published

For practice, restrict inbound access to your own public IP where possible.

## Scenario 2: Port Is Already Allocated

Error:

```text
Bind for 0.0.0.0:8080 failed: port is already allocated
```

Check Docker containers:

```bash
docker ps \
  --format 'table {{.Names}}\t{{.Ports}}'
```

Check host processes:

```bash
sudo ss -lntp |
  grep ':8080'
```

Use a different host port:

```bash
docker run -d \
  --name alternative-nginx \
  -p 8081:80 \
  nginx:alpine
```

## Scenario 3: Containers Cannot Communicate

Create two separate networks:

```bash
docker network create frontend-network
docker network create backend-network
```

Run containers:

```bash
docker run -d \
  --name frontend-client \
  --network frontend-network \
  alpine:latest \
  sleep 3600
```

```bash
docker run -d \
  --name backend-api \
  --network backend-network \
  hashicorp/http-echo:1.0 \
  -listen=:3000 \
  -text='Backend is running'
```

The frontend cannot reach the backend because they do not share a network.

Inspect:

```bash
docker network inspect frontend-network
docker network inspect backend-network
```

Connect the frontend to the backend network:

```bash
docker network connect \
  backend-network \
  frontend-client
```

Test:

```bash
docker exec frontend-client \
  wget -qO- http://backend-api:3000
```

## Scenario 4: Wrong Hostname

Incorrect:

```text
http://localhost:3000
```

From inside the frontend container, `localhost` refers to the frontend container itself.

Correct when the backend service name is `backend-api`:

```text
http://backend-api:3000
```

## Scenario 5: DNS Failure

Check network membership:

```bash
docker network inspect backend-network
```

Check DNS configuration:

```bash
docker exec frontend-client \
  cat /etc/resolv.conf
```

Resolve the backend name:

```bash
docker exec frontend-client \
  getent hosts backend-api
```

Use a troubleshooting image if required:

```bash
docker run --rm \
  --network backend-network \
  nicolaka/netshoot \
  dig backend-api
```

## Scenario 6: Connection Refused

A successful DNS lookup followed by `connection refused` usually means:

- The application is not running
- The application listens on another port
- The application listens only on `127.0.0.1`
- The application has not completed startup

Check logs:

```bash
docker logs backend-api
```

Check network connectivity:

```bash
docker run --rm \
  --network backend-network \
  nicolaka/netshoot \
  curl -v http://backend-api:3000
```

## Application Listening Address

Inside a container, a web application normally needs to listen on:

```text
0.0.0.0
```

If it listens only on:

```text
127.0.0.1
```

other containers cannot reach it through the container network.

## EXPOSE Does Not Publish a Port

This Dockerfile instruction:

```dockerfile
EXPOSE 3000
```

documents the application port.

It does not publish the port through the Docker host.

Publish it at runtime:

```bash
docker run -p 3000:3000 IMAGE_NAME
```

## Network Troubleshooting Checklist

```bash
docker ps
docker logs CONTAINER_NAME
docker port CONTAINER_NAME
docker inspect CONTAINER_NAME
docker network ls
docker network inspect NETWORK_NAME
docker exec CONTAINER_NAME ip address
docker exec CONTAINER_NAME ip route
docker exec CONTAINER_NAME cat /etc/resolv.conf
```

## Cleanup

```bash
docker rm -f \
  network-nginx \
  alternative-nginx \
  frontend-client \
  backend-api
```

```bash
docker network rm \
  frontend-network \
  backend-network
```
