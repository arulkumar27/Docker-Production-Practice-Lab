# 08 — Docker Registry and Image Management

A container registry stores and distributes Docker images.

Development teams use registries to share versioned application images between developer systems, CI/CD pipelines, testing environments and deployment servers.

## Learning Objectives

After completing this section, I will be able to:

- Explain the purpose of a container registry
- Understand image naming conventions
- Tag Docker images
- Authenticate with Docker Hub
- Push and pull custom images
- Use versioned image tags
- Understand mutable and immutable references
- Save and load images without a registry
- Inspect image metadata and digests
- Clean up unused images safely

## Common Container Registries

| Registry | Example Image Reference |
|---|---|
| Docker Hub | `docker.io/arulkumar27/application:1.0.0` |
| Amazon ECR | `ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/application:1.0.0` |
| GitHub Container Registry | `ghcr.io/arulkumar27/application:1.0.0` |
| Azure Container Registry | `registry.azurecr.io/application:1.0.0` |
| Google Artifact Registry | `REGION-docker.pkg.dev/PROJECT/repository/application:1.0.0` |
| Private registry | `registry.example.com/team/application:1.0.0` |

## Image Reference Format

```text
REGISTRY/NAMESPACE/REPOSITORY:TAG
```

Example:

```text
docker.io/arulkumar27/devops-portfolio:1.0.0
```

| Component | Value |
|---|---|
| Registry | `docker.io` |
| Namespace | `arulkumar27` |
| Repository | `devops-portfolio` |
| Tag | `1.0.0` |

## Image Management Workflow

```text
Dockerfile
   ↓
docker build
   ↓
Local image
   ↓
docker tag
   ↓
Registry-compatible image name
   ↓
docker push
   ↓
Container registry
   ↓
docker pull
   ↓
Deployment environment
```

## Basic Workflow

Build:

```bash
docker build \
  -t devops-portfolio:1.0.0 \
  .
```

Tag:

```bash
docker tag \
  devops-portfolio:1.0.0 \
  arulkumar27/devops-portfolio:1.0.0
```

Authenticate:

```bash
docker login --username arulkumar27
```

Push:

```bash
docker push \
  arulkumar27/devops-portfolio:1.0.0
```

Pull:

```bash
docker pull \
  arulkumar27/devops-portfolio:1.0.0
```

## Tag vs Digest

Tag reference:

```text
nginx:1.27-alpine
```

Digest reference:

```text
nginx@sha256:DIGEST_VALUE
```

A tag is a human-readable label and can potentially be changed to reference another image.

A digest identifies specific image content.

Production systems may use digests when immutable deployment references are required.

## Files in This Folder

| File | Purpose |
|---|---|
| `docker-hub.md` | Docker Hub login, push and pull workflow |
| `image-tagging.md` | Image naming and tag commands |
| `image-versioning.md` | Release-versioning strategies |
| `cleanup.md` | Safe image and container cleanup |

## Practice Checklist

- [ ] Build a local image
- [ ] Create a registry-compatible tag
- [ ] Authenticate with a registry
- [ ] Push an image
- [ ] Pull the image on another system
- [ ] Inspect the image digest
- [ ] Create semantic-version tags
- [ ] Create a Git commit tag
- [ ] Save an image as a TAR archive
- [ ] Load an image from an archive
- [ ] Review Docker disk usage
- [ ] Clean unused resources safely
