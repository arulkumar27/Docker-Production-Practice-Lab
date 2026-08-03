# Default Bridge Network Practice

The default `bridge` network is automatically created when Docker starts.

Containers run without an explicit `--network` option normally join this network.

## Inspect the Default Bridge

```bash
docker network inspect bridge
```

## Start Two Containers

```bash
docker run -d \
  --name bridge-web-one \
  nginx:alpine
```

```bash
docker run -d \
  --name bridge-web-two \
  nginx:alpine
```

## Verify Network Attachment

```bash
docker inspect \
  --format '{{json .NetworkSettings.Networks}}' \
  bridge-web-one
```

```bash
docker inspect \
  --format '{{json .NetworkSettings.Networks}}' \
  bridge-web-two
```

## Get Container IP Addresses

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  bridge-web-one
```

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  bridge-web-two
```

Container IP addresses are dynamically assigned and can change when containers are recreated.

Application configuration should not depend on hard-coded container IP addresses.

## Test Communication by IP Address

Store the second container's IP address:

```bash
WEB_TWO_IP="$(docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  bridge-web-two)"
```

Test Nginx from the first container:

```bash
docker exec bridge-web-one \
  wget -qO- "http://${WEB_TWO_IP}"
```

## Test Communication by Container Name

```bash
docker exec bridge-web-one \
  ping -c 3 bridge-web-two
```

Name-based discovery is limited on the default bridge network compared with user-defined bridge networks.

For multi-container applications, a custom bridge network is recommended.

## Publish a Container Port

The following container is reachable through host port `8080`:

```bash
docker run -d \
  --name published-bridge-nginx \
  -p 8080:80 \
  nginx:alpine
```

Test from the host:

```bash
curl http://localhost:8080
```

Check the mapping:

```bash
docker port published-bridge-nginx
```

## Publish an Automatically Selected Host Port

```bash
docker run -d \
  --name random-port-nginx \
  -P \
  nginx:alpine
```

Check the selected port:

```bash
docker port random-port-nginx
```

Uppercase `-P` publishes all ports declared by the image to automatically selected host ports.

Lowercase `-p` allows an explicit mapping:

```bash
docker run -p 8080:80 nginx:alpine
```

## Inspect Bridge Membership

```bash
docker network inspect bridge
```

Check the `Containers` section.

## Important Observations

- Containers receive private IP addresses
- Container IPs may change
- Port publishing is required for host or external access
- Default bridge networking offers limited automatic name resolution
- Custom networks are preferred for multi-container applications

## Cleanup

```bash
docker rm -f \
  bridge-web-one \
  bridge-web-two \
  published-bridge-nginx \
  random-port-nginx
```
