# Docker Image Versioning

Image versioning makes releases identifiable, traceable and easier to roll back.

## Why Versioning Matters

Without versioned images:

- The deployed code may be unclear
- Rollbacks become difficult
- Different environments may run different builds
- Incident investigation becomes harder
- Mutable tags may silently change

## Semantic Versioning

Format:

```text
MAJOR.MINOR.PATCH
```

Example:

```text
2.4.1
```

| Part | Meaning |
|---|---|
| Major | Breaking or incompatible changes |
| Minor | Backward-compatible features |
| Patch | Backward-compatible fixes |

Example tags:

```text
payment-api:1.0.0
payment-api:1.1.0
payment-api:1.1.1
payment-api:2.0.0
```

## Version Tag Hierarchy

One image can receive several tags:

```text
payment-api:2.4.1
payment-api:2.4
payment-api:2
payment-api:stable
```

Commands:

```bash
docker tag payment-api:2.4.1 payment-api:2.4
docker tag payment-api:2.4.1 payment-api:2
docker tag payment-api:2.4.1 payment-api:stable
```

The precise version remains:

```text
payment-api:2.4.1
```

Broader aliases can move when newer versions are released.

## Git-Based Version

```bash
GIT_COMMIT="$(git rev-parse --short HEAD)"
```

```bash
docker build \
  -t "payment-api:git-${GIT_COMMIT}" \
  .
```

Example:

```text
payment-api:git-a1b2c3d
```

## CI Build Version

```text
payment-api:build-208
```

This connects the image with a CI/CD pipeline execution.

## Combined Version

```text
payment-api:2.4.1-build.208
```

or:

```text
payment-api:2.4.1-a1b2c3d
```

## Release Candidate

```text
payment-api:2.5.0-rc.1
payment-api:2.5.0-rc.2
```

Release candidates should be tested before the final release:

```text
payment-api:2.5.0
```

## Immutable Deployment Reference

Tag-based deployment:

```text
payment-api:2.4.1
```

Digest-based deployment:

```text
payment-api@sha256:DIGEST_VALUE
```

A digest identifies exact image content.

Retrieve the digest after pulling:

```bash
docker pull nginx:1.27-alpine
```

```bash
docker image inspect \
  --format '{{index .RepoDigests 0}}' \
  nginx:1.27-alpine
```

## Recommended CI/CD Versioning Flow

```text
Git commit
   ↓
CI pipeline starts
   ↓
Tests run
   ↓
Image is built once
   ↓
Tags are assigned:
- semantic version
- Git commit
- build number
   ↓
Image is scanned
   ↓
Image is pushed
   ↓
Same image is promoted through environments
```

## Example Release Commands

```bash
APPLICATION_NAME="payment-api"
APPLICATION_VERSION="2.4.1"
GIT_COMMIT="$(git rev-parse --short HEAD)"
REGISTRY_REPOSITORY="arulkumar27/payment-api"
```

Build:

```bash
docker build \
  -t "${REGISTRY_REPOSITORY}:${APPLICATION_VERSION}" \
  -t "${REGISTRY_REPOSITORY}:git-${GIT_COMMIT}" \
  .
```

Push version:

```bash
docker push \
  "${REGISTRY_REPOSITORY}:${APPLICATION_VERSION}"
```

Push Git tag:

```bash
docker push \
  "${REGISTRY_REPOSITORY}:git-${GIT_COMMIT}"
```

## Rollback Example

Current release:

```text
payment-api:2.4.1
```

Previous verified release:

```text
payment-api:2.4.0
```

Rollback:

```bash
docker rm -f payment-api
```

```bash
docker run -d \
  --name payment-api \
  -p 3000:3000 \
  payment-api:2.4.0
```

A rollback is practical because the previous image version remains identifiable.

## Recommended Rules

- Build once and promote the same image
- Use explicit version tags
- Include Git commit traceability
- Avoid deploying only `latest`
- Never overwrite released version tags
- Preserve required rollback versions
- Record the image digest used for deployment
- Scan images before promotion
- Apply an image-retention policy
