# Custom Bridge Network Practice

A custom bridge network provides better container isolation and automatic DNS-based service discovery.

This exercise creates a frontend and backend service on a private application network.

## Create the Network

```bash
docker network create application-network
```

Verify:

```bash
docker network ls
docker network inspect application-network
```

## Start the Backend

```bash
docker run -d \
  --name backend-api \
  --network application-network \
  hashicorp/http-echo:1.0 \
  -listen=:3000 \
  -text='{"service":"backend-api","status":"running"}'
```

The backend listens on port `3000` inside the network.

Its port is not published to the host.

## Start a Frontend Test Container

```bash
docker run -d \
  --name frontend-client \
  --network application-network \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

## Test Frontend-to-Backend Communication

```bash
docker exec frontend-client \
  wget -qO- http://backend-api:3000
```

Expected:

```json
{"service":"backend-api","status":"running"}
```

The frontend uses `backend-api` as the hostname.

Docker DNS resolves it to the backend container's current IP address.

## Verify Backend Is Not Published

Check:

```bash
docker port backend-api
```

No published port should be displayed.

The service is accessible to containers on `application-network`, but it is not directly published through the Docker host.

## Publish Only the Frontend

Run Nginx:

```bash
docker run -d \
  --name public-frontend \
  --network application-network \
  -p 8080:80 \
  nginx:alpine
```

Now only Nginx is exposed through:

```text
http://localhost:8080
```

This resembles a common application design:

```text
User → Published frontend/reverse proxy → Private backend
```

## Create a Database Network

```bash
docker network create database-network
```

Start a database placeholder:

```bash
docker run -d \
  --name database-service \
  --network database-network \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

## Connect Backend to Both Networks

```bash
docker network connect \
  database-network \
  backend-api
```

The backend now belongs to:

- `application-network`
- `database-network`

Inspect:

```bash
docker inspect \
  --format '{{json .NetworkSettings.Networks}}' \
  backend-api
```

## Network Isolation

The frontend belongs only to `application-network`.

The database belongs only to `database-network`.

The frontend should not be able to resolve the database:

```bash
docker exec frontend-client \
  ping -c 2 database-service
```

The backend is connected to both networks, so it can communicate with both frontend-side and database-side services.

This produces basic network segmentation:

```text
Frontend network:
public-frontend ↔ backend-api

Database network:
backend-api ↔ database-service
```

## Disconnect a Container

```bash
docker network disconnect \
  database-network \
  backend-api
```

Test the network membership:

```bash
docker network inspect database-network
```

Reconnect:

```bash
docker network connect \
  database-network \
  backend-api
```

## Create a Network with a Custom Subnet

Do not run this if the subnet conflicts with an existing Docker, host, VPC, VPN, or local network.

```bash
docker network create \
  --driver bridge \
  --subnet 172.28.0.0/16 \
  --gateway 172.28.0.1 \
  controlled-network
```

Run a container with a specific IP for practice:

```bash
docker run -d \
  --name controlled-container \
  --network controlled-network \
  --ip 172.28.0.10 \
  nginx:alpine
```

Inspect:

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  controlled-container
```

For normal application containers, automatic addressing and DNS names are generally preferred over manually assigned IP addresses.

## Cleanup Containers

```bash
docker rm -f \
  backend-api \
  frontend-client \
  public-frontend \
  database-service \
  controlled-container
```

## Cleanup Networks

```bash
docker network rm \
  application-network \
  database-network \
  controlled-network
```

A network must not have connected containers when it is removed.
