# Dockerfile Best Practices

These practices improve image security, repeatability, performance, and maintainability.

## 1. Use Trusted Base Images

Prefer trusted and maintained images:

```dockerfile
FROM node:22-alpine
```

Review the image publisher, update history, supported versions, and known vulnerabilities.

## 2. Use Explicit Versions

Avoid relying only on:

```dockerfile
FROM node:latest
```

Prefer:

```dockerfile
FROM node:22-alpine
```

For stronger reproducibility, production teams may pin images by digest.

## 3. Use Small Base Images Carefully

Smaller images can provide:

- Faster image downloads
- Reduced storage usage
- Smaller attack surface

However, minimal images may exclude debugging tools or required compatibility libraries. Select the base image based on application requirements.

## 4. Use Multi-Stage Builds

```dockerfile
FROM node:22-alpine AS dependencies

WORKDIR /build
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

FROM node:22-alpine AS runtime

WORKDIR /app
COPY --from=dependencies /build/node_modules ./node_modules
COPY server.js ./

CMD ["node", "server.js"]
```

Only required runtime files are copied into the final stage.

## 5. Order Instructions for Caching

Copy dependency files before application source code:

```dockerfile
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .
```

Application code changes will not invalidate the dependency layer unless dependency files also change.

## 6. Use `.dockerignore`

Example:

```text
.git
node_modules
.env
*.log
coverage
README.md
```

This:

- Reduces build context size
- Improves build speed
- Prevents unnecessary files from entering images
- Reduces the chance of copying sensitive files

## 7. Never Store Secrets in Images

Do not write:

```dockerfile
ENV DATABASE_PASSWORD=my-password
ENV API_KEY=my-api-key
```

Image layers and metadata may expose these values.

Provide secrets securely at runtime using an approved secret-management system.

## 8. Run as a Non-Root User

```dockerfile
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser

USER appuser
```

Verify:

```bash
docker exec CONTAINER_NAME whoami
```

## 9. Use COPY Instead of ADD

Preferred:

```dockerfile
COPY server.js ./
```

Use `ADD` only when its additional behavior is required.

## 10. Combine Related Package Commands

Recommended:

```dockerfile
RUN apk add --no-cache curl ca-certificates
```

For Debian-based images:

```dockerfile
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*
```

This prevents package-index files from remaining in a separate layer.

## 11. Use Exec-Form Commands

Recommended:

```dockerfile
CMD ["node", "server.js"]
```

Avoid when unnecessary:

```dockerfile
CMD node server.js
```

Exec form provides better signal handling.

## 12. Add a Health Check

```dockerfile
HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:3000/health || exit 1
```

A health check determines whether the application responds correctly, not merely whether its process exists.

## 13. Do Not Install Unnecessary Packages

Every unnecessary package can:

- Increase image size
- Increase attack surface
- Add vulnerabilities
- Increase maintenance requirements

Install only runtime dependencies.

## 14. Add OCI Image Labels

```dockerfile
LABEL org.opencontainers.image.title="Application API"
LABEL org.opencontainers.image.description="Containerized API service"
LABEL org.opencontainers.image.authors="Arul Kumar"
LABEL org.opencontainers.image.version="1.0.0"
```

## 15. Keep Containers Focused

A container should normally have one primary responsibility.

Example separation:

- Nginx container
- Backend API container
- PostgreSQL container
- Redis container

This makes services easier to scale, replace, monitor, and troubleshoot.

## 16. Configure Resource Limits at Runtime

Resource limits are normally applied when starting or orchestrating containers:

```bash
docker run -d \
  --memory="512m" \
  --cpus="1.0" \
  application:1.0.0
```

## 17. Use a Read-Only Filesystem Where Possible

```bash
docker run -d \
  --read-only \
  --tmpfs /tmp \
  application:1.0.0
```

Applications requiring persistent writes should use an explicitly configured volume.

## 18. Scan Images

Example with Docker Scout when available:

```bash
docker scout cves application:1.0.0
```

Example with Trivy when installed:

```bash
trivy image application:1.0.0
```

Findings should be reviewed and remediated based on severity, exploitability, and application exposure.

## 19. Inspect the Final Image

```bash
docker image inspect application:1.0.0
docker image history application:1.0.0
docker image ls application
```

Check:

- Image size
- Runtime user
- Environment variables
- Exposed ports
- Entrypoint and command
- Number and size of layers

## 20. Use Versioned Tags

Recommended:

```text
application:1.0.0
application:1.1.0
application:2026.08.03
```

Versioned tags make rollback and release identification easier.

## Review Checklist

- [ ] Trusted base image used
- [ ] Explicit version selected
- [ ] Multi-stage build considered
- [ ] Dependency caching optimized
- [ ] `.dockerignore` included
- [ ] Secrets excluded
- [ ] Non-root user configured
- [ ] Minimal packages installed
- [ ] Exec-form command used
- [ ] Health check configured
- [ ] Image labels included
- [ ] Image scanned
- [ ] Image versioned
- [ ] Runtime limits documented
