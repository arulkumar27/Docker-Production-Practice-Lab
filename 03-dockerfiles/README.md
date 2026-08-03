# 03 — Dockerfiles

This section focuses on writing, building, optimizing, and securing Dockerfiles.

## Learning Objectives

After completing this section, I will be able to:

- Understand common Dockerfile instructions
- Build a custom Docker image
- Control the Docker build context
- Use image tags correctly
- Create multi-stage Docker builds
- Reduce final image size
- Run application containers as non-root users
- Configure health checks
- Understand layer caching
- Apply Dockerfile security and optimization practices

## What Is a Dockerfile?

A Dockerfile is a text file containing instructions Docker uses to build an image.

Example:

```dockerfile
FROM nginx:1.27-alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

Build it:

```bash
docker build -t custom-nginx:1.0.0 .
```

Run it:

```bash
docker run -d \
  --name custom-nginx \
  -p 8080:80 \
  custom-nginx:1.0.0
```

## Common Dockerfile Instructions

| Instruction | Purpose |
|---|---|
| `FROM` | Selects the base image |
| `LABEL` | Adds image metadata |
| `ARG` | Defines a build-time variable |
| `ENV` | Defines a runtime environment variable |
| `WORKDIR` | Sets the working directory |
| `COPY` | Copies files into the image |
| `ADD` | Copies files with additional features |
| `RUN` | Executes commands while building |
| `USER` | Selects the runtime user |
| `EXPOSE` | Documents the application port |
| `VOLUME` | Documents a persistent-data location |
| `HEALTHCHECK` | Checks application health |
| `ENTRYPOINT` | Defines the primary executable |
| `CMD` | Provides the default command or arguments |

## Dockerfile Execution Categories

### Build-Time Instructions

These instructions mainly operate while the image is being built:

```dockerfile
FROM
ARG
RUN
COPY
ADD
```

### Runtime Configuration

These instructions influence containers created from the image:

```dockerfile
ENV
USER
EXPOSE
HEALTHCHECK
ENTRYPOINT
CMD
```

## COPY vs ADD

Prefer `COPY` for normal file copying:

```dockerfile
COPY package.json ./
```

Use `ADD` only when its special behavior is specifically required, such as automatic local TAR extraction.

## CMD vs ENTRYPOINT

### CMD

Provides the default container command:

```dockerfile
CMD ["node", "server.js"]
```

It can be replaced at runtime:

```bash
docker run application:1.0.0 node another-script.js
```

### ENTRYPOINT

Defines the main executable:

```dockerfile
ENTRYPOINT ["node"]
CMD ["server.js"]
```

Runtime arguments are appended to the entrypoint.

For many application images, a direct `CMD` is sufficient.

## Exec Form vs Shell Form

Recommended exec form:

```dockerfile
CMD ["node", "server.js"]
```

Shell form:

```dockerfile
CMD node server.js
```

Exec form is generally preferred because signals are delivered directly to the application process.

## Build Context

In this command:

```bash
docker build -t application:1.0.0 .
```

The final `.` is the build context. Docker can access files inside this directory during the build.

Use `.dockerignore` to prevent unnecessary files from being sent into the build context.

## Exercises

| Folder | Purpose |
|---|---|
| `basic-dockerfile/` | Basic custom Nginx image |
| `multi-stage-build/` | Separate dependency build and runtime stages |
| `non-root-container/` | Run a Node.js application as a non-root user |
| `dockerfile-best-practices/` | Production-oriented Dockerfile practices |

## Practice Checklist

- [ ] Build a basic image
- [ ] Understand each Dockerfile instruction
- [ ] Inspect image layers
- [ ] Observe Docker build caching
- [ ] Use `.dockerignore`
- [ ] Build a multi-stage image
- [ ] Compare image sizes
- [ ] Run an application as a non-root user
- [ ] Add a health check
- [ ] Apply explicit image tags
