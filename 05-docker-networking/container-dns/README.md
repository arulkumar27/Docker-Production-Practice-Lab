# Docker Container DNS Practice

Docker provides embedded DNS-based service discovery for containers connected to user-defined networks.

Containers can communicate using:

- Container names
- Network aliases
- Service names in Docker Compose
- Container IP addresses

Container names and service names are preferred because IP addresses can change.

## Create a DNS Practice Network

```bash
docker network create dns-practice-network
```

## Start an API Container

```bash
docker run -d \
  --name user-api \
  --network dns-practice-network \
  --network-alias users \
  hashicorp/http-echo:1.0 \
  -listen=:3000 \
  -text='{"service":"user-api","status":"healthy"}'
```

This container can be reached using:

```text
user-api
```

or its network alias:

```text
users
```

## Start a Client Container

```bash
docker run -d \
  --name dns-client \
  --network dns-practice-network \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

## Test Using the Container Name

```bash
docker exec dns-client \
  wget -qO- http://user-api:3000
```

## Test Using the Network Alias

```bash
docker exec dns-client \
  wget -qO- http://users:3000
```

Both commands should reach the same API container.

## View DNS Configuration

```bash
docker exec dns-client \
  cat /etc/resolv.conf
```

On a user-defined network, Docker commonly provides an embedded DNS resolver.

## Resolve the Container Name

Alpine includes `getent` through its standard utilities in many versions:

```bash
docker exec dns-client \
  getent hosts user-api
```

If the command is unavailable, use a troubleshooting container:

```bash
docker run --rm \
  --network dns-practice-network \
  nicolaka/netshoot \
  dig user-api
```

## Inspect Network Aliases

```bash
docker inspect \
  --format '{{json .NetworkSettings.Networks}}' \
  user-api
```

## Why IP Addresses Should Not Be Hard-Coded

Display the current API address:

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  user-api
```

Remove and recreate the API container:

```bash
docker rm -f user-api
```

```bash
docker run -d \
  --name user-api \
  --network dns-practice-network \
  --network-alias users \
  hashicorp/http-echo:1.0 \
  -listen=:3000 \
  -text='{"service":"user-api","status":"recreated"}'
```

Its IP address may change, but this request still works:

```bash
docker exec dns-client \
  wget -qO- http://user-api:3000
```

DNS-based service discovery allows containers to be replaced without changing the client configuration.

## DNS Failure Scenario

Disconnect the API:

```bash
docker network disconnect \
  dns-practice-network \
  user-api
```

Test:

```bash
docker exec dns-client \
  wget -qO- http://user-api:3000
```

The request should fail because the API is no longer connected to the same network.

Reconnect:

```bash
docker network connect \
  --alias users \
  dns-practice-network \
  user-api
```

Test again:

```bash
docker exec dns-client \
  wget -qO- http://users:3000
```

## Common DNS Troubleshooting Checks

### Check Both Containers Are Running

```bash
docker ps
```

### Check Network Membership

```bash
docker network inspect dns-practice-network
```

### Check the Requested Name

```bash
docker inspect user-api
```

### Check the Correct Port

```bash
docker logs user-api
```

### Test Name Resolution

```bash
docker run --rm \
  --network dns-practice-network \
  nicolaka/netshoot \
  dig user-api
```

### Test the Application Port

```bash
docker run --rm \
  --network dns-practice-network \
  nicolaka/netshoot \
  curl -v http://user-api:3000
```

## Important Difference

These are different checks:

```text
DNS resolution:
Can the client convert user-api into an IP address?

Network connectivity:
Can the client reach the resolved IP?

Application availability:
Is the application listening and responding on port 3000?
```

A successful DNS lookup does not guarantee that the application is healthy.

## Cleanup

```bash
docker rm -f user-api dns-client
docker network rm dns-practice-network
```
