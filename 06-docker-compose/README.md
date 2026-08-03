# 06 — Docker Compose

Docker Compose is used to define and manage multi-container applications using a YAML configuration file.

Instead of starting every container with separate `docker run` commands, the complete application stack can be described in `compose.yaml`.

## Learning Objectives

After completing this section, I will be able to:

- Understand Docker Compose
- Write a Compose file
- Create multiple services
- Configure ports, networks and volumes
- Use environment variables
- Configure health checks
- Control service startup dependencies
- Use Compose profiles
- View logs and container status
- Rebuild and recreate services
- Stop and remove a complete application stack

## Why Docker Compose Is Used

Without Compose:

```bash
docker network create application-network
docker volume create database-data

docker run -d \
  --name database \
  --network application-network \
  --mount type=volume,source=database-data,target=/var/lib/postgresql/data \
  -e POSTGRES_DB=application \
  -e POSTGRES_USER=application_user \
  -e POSTGRES_PASSWORD=change-me \
  postgres:17-alpine
```

With Compose:

```bash
docker compose up -d
```

The Compose file stores the application configuration in a reusable and version-controlled format.

## Basic Compose Structure

```yaml
name: practice-application

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - frontend-network

networks:
  frontend-network:
    driver: bridge
```

## Main Compose Sections

| Section | Purpose |
|---|---|
| `name` | Defines the Compose project name |
| `services` | Defines application containers |
| `networks` | Defines application networks |
| `volumes` | Defines persistent named volumes |
| `configs` | Defines non-sensitive configuration |
| `secrets` | Defines secret objects where supported |

## Common Commands

Validate the Compose configuration:

```bash
docker compose config
```

Start services:

```bash
docker compose up -d
```

Build and start:

```bash
docker compose up -d --build
```

List services:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs
```

Follow logs:

```bash
docker compose logs -f
```

View a specific service:

```bash
docker compose logs -f web
```

Stop services without removing them:

```bash
docker compose stop
```

Start stopped services:

```bash
docker compose start
```

Restart services:

```bash
docker compose restart
```

Remove containers and networks:

```bash
docker compose down
```

Remove containers, networks and named volumes:

```bash
docker compose down --volumes
```

The `--volumes` option permanently removes Compose-managed persistent data.

## Service Names and DNS

Services on the same Compose network communicate using service names.

Example:

```yaml
services:
  backend:
    image: backend-api:1.0.0

  frontend:
    image: frontend:1.0.0
```

The frontend can connect to:

```text
http://backend:3000
```

It should not depend on the backend container's dynamic IP address.

## Compose File Naming

Recommended default filename:

```text
compose.yaml
```

Docker also recognizes filenames such as:

```text
compose.yml
docker-compose.yaml
docker-compose.yml
```

## Files in This Folder

| Folder | Purpose |
|---|---|
| `basic-compose/` | Run Nginx using Compose |
| `service-dependencies/` | PostgreSQL health checks and Adminer |
| `environment-variables/` | Manage runtime configuration |
| `compose-profiles/` | Start optional services |

## Practice Checklist

- [ ] Validate a Compose file
- [ ] Start a Compose project
- [ ] List services
- [ ] View logs
- [ ] Use a bind mount
- [ ] Use a named volume
- [ ] Create custom networks
- [ ] Configure health checks
- [ ] Use service dependencies
- [ ] Pass environment variables
- [ ] Use optional profiles
- [ ] Stop and remove a stack safely
