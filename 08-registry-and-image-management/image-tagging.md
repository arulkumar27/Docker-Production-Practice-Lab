# Docker Image Tagging

A Docker tag is a human-readable label attached to an image.

Tags commonly identify:

- Application version
- Release channel
- Environment build
- Git commit
- Build number
- Release date

## Tag Format

```text
REGISTRY/NAMESPACE/REPOSITORY:TAG
```

Examples:

```text
inventory-api:1.0.0
arulkumar27/inventory-api:1.0.0
ghcr.io/arulkumar27/inventory-api:1.0.0
```

## Build with a Tag

```bash
docker build \
  -t inventory-api:1.0.0 \
  .
```

## Add Another Tag

```bash
docker tag \
  inventory-api:1.0.0 \
  inventory-api:stable
```

Both tags may point to the same image ID.

Verify:

```bash
docker image ls inventory-api
```

## Create a Registry Tag

```bash
docker tag \
  inventory-api:1.0.0 \
  arulkumar27/inventory-api:1.0.0
```

## Create Multiple Tags During Build

```bash
docker build \
  -t inventory-api:1.0.0 \
  -t inventory-api:1.0 \
  -t inventory-api:1 \
  -t inventory-api:stable \
  .
```

## Tag Using Git Commit SHA

Get the short Git commit:

```bash
git rev-parse --short HEAD
```

Build using it:

```bash
IMAGE_TAG="$(git rev-parse --short HEAD)"
```

```bash
docker build \
  -t "inventory-api:${IMAGE_TAG}" \
  .
```

Example:

```text
inventory-api:a1b2c3d
```

This connects the image to the exact source-code revision used for the build.

## Tag Using Build Number

```bash
BUILD_NUMBER=125
```

```bash
docker build \
  -t "inventory-api:build-${BUILD_NUMBER}" \
  .
```

Result:

```text
inventory-api:build-125
```

## Tag Using Date and Git Commit

```bash
RELEASE_DATE="$(date +%Y%m%d)"
GIT_COMMIT="$(git rev-parse --short HEAD)"
IMAGE_TAG="${RELEASE_DATE}-${GIT_COMMIT}"
```

```bash
docker build \
  -t "inventory-api:${IMAGE_TAG}" \
  .
```

Example:

```text
inventory-api:20260803-a1b2c3d
```

## Retag an Existing Image

```bash
docker tag \
  inventory-api:1.0.0 \
  inventory-api:production
```

This does not duplicate the complete image data. It creates another reference to the same image.

## Remove a Tag

```bash
docker image rm inventory-api:production
```

Other tags referencing the same image continue to exist.

## Inspect Tags

```bash
docker image ls inventory-api
```

Inspect repository tags through image metadata:

```bash
docker image inspect inventory-api:1.0.0
```

## Tagging Recommendations

Recommended:

```text
application:1.0.0
application:1.0
application:git-a1b2c3d
application:build-125
```

Use carefully:

```text
application:latest
application:production
application:stable
```

Tags such as `latest`, `production`, and `stable` can be reassigned. They should not be treated as immutable identifiers.

## Avoid Environment-Only Builds

Avoid creating different image contents separately for each environment:

```text
application:development
application:testing
application:production
```

A stronger deployment practice is:

1. Build one verified image.
2. Assign an immutable version.
3. Promote the same image through testing and production.
4. Provide environment-specific configuration at runtime.

This reduces differences between environments.
