# Multi-Stage Docker Build

This exercise uses separate Dockerfile stages for dependency installation and application runtime.

## Why Multi-Stage Builds Are Used

Multi-stage builds help:

- Separate build operations from runtime
- Exclude unnecessary build files
- Reduce the final image attack surface
- Improve Dockerfile organization
- Copy only required artifacts into the final image

## Build Stages

### Dependencies Stage

The first stage installs production dependencies:

```dockerfile
FROM node:22-alpine AS dependencies
```

### Runtime Stage

The second stage contains only the files needed to run the application:

```dockerfile
FROM node:22-alpine AS runtime
```

Dependencies are copied from the first stage:

```dockerfile
COPY --from=dependencies /build/node_modules ./node_modules
```

## Build the Image

```bash
docker build \
  -t multi-stage-api:1.0.0 \
  .
```

## Run the Container

```bash
docker run -d \
  --name multi-stage-api \
  -p 3000:3000 \
  --memory="256m" \
  --cpus="0.50" \
  multi-stage-api:1.0.0
```

## Test the API

Application endpoint:

```bash
curl http://localhost:3000
```

Health endpoint:

```bash
curl http://localhost:3000/health
```

## Check Health Status

```bash
docker ps
```

Detailed health information:

```bash
docker inspect \
  --format '{{json .State.Health}}' \
  multi-stage-api
```

## Confirm Runtime User

```bash
docker exec multi-stage-api whoami
```

Expected output:

```text
node
```

## View Logs

```bash
docker logs multi-stage-api
```

Follow logs:

```bash
docker logs -f multi-stage-api
```

## Inspect Image History

```bash
docker image history multi-stage-api:1.0.0
```

## Stop Gracefully

```bash
docker stop multi-stage-api
```

The application receives `SIGTERM` and closes the HTTP server before exiting.

## Cleanup

```bash
docker rm multi-stage-api
docker image rm multi-stage-api:1.0.0
```
