# Docker Hub Practice

Docker Hub is a container registry used to store and distribute container images.

This guide demonstrates the workflow without storing credentials in the repository.

## Prerequisites

- Docker installed
- Docker Hub account
- Docker Hub repository
- Local Docker image
- Permission to push to the selected repository

## Repository Name

For this practice, create:

```text
devops-portfolio
```

Example full repository:

```text
arulkumar27/devops-portfolio
```

Replace `arulkumar27` if your Docker Hub username is different.

## Build a Practice Image

Move to a directory containing a Dockerfile:

```bash
docker build \
  -t devops-portfolio:1.0.0 \
  .
```

Verify:

```bash
docker image ls devops-portfolio
```

## Tag for Docker Hub

```bash
docker tag \
  devops-portfolio:1.0.0 \
  arulkumar27/devops-portfolio:1.0.0
```

Verify:

```bash
docker image ls \
  arulkumar27/devops-portfolio
```

## Log In Interactively

```bash
docker login --username arulkumar27
```

When prompted, use an appropriate Docker Hub access token or credential.

Do not place the credential inside:

- README files
- Shell scripts
- Dockerfiles
- Git repositories
- Screenshots
- Terminal command examples

## Push the Image

```bash
docker push \
  arulkumar27/devops-portfolio:1.0.0
```

## Pull the Image

Remove only the local tagged copy for testing:

```bash
docker image rm \
  arulkumar27/devops-portfolio:1.0.0
```

Pull it again:

```bash
docker pull \
  arulkumar27/devops-portfolio:1.0.0
```

## Run the Pulled Image

```bash
docker run -d \
  --name registry-practice \
  -p 8080:80 \
  arulkumar27/devops-portfolio:1.0.0
```

Test:

```bash
curl http://localhost:8080
```

## Push Additional Tags

Create a stable tag:

```bash
docker tag \
  devops-portfolio:1.0.0 \
  arulkumar27/devops-portfolio:stable
```

Push it:

```bash
docker push \
  arulkumar27/devops-portfolio:stable
```

Create a latest tag only when it is appropriate for the repository:

```bash
docker tag \
  devops-portfolio:1.0.0 \
  arulkumar27/devops-portfolio:latest
```

```bash
docker push \
  arulkumar27/devops-portfolio:latest
```

## View Repository Digests

```bash
docker image ls \
  --digests \
  arulkumar27/devops-portfolio
```

After pushing or pulling, inspect repository digests:

```bash
docker image inspect \
  --format '{{json .RepoDigests}}' \
  arulkumar27/devops-portfolio:1.0.0
```

## Log Out

```bash
docker logout
```

## CI/CD Authentication Pattern

A CI/CD platform should obtain registry credentials from its protected secret store.

Conceptual example:

```bash
printf '%s' "$DOCKER_REGISTRY_TOKEN" |
  docker login \
    --username "$DOCKER_REGISTRY_USERNAME" \
    --password-stdin
```

The token must be configured in the CI/CD secret store and must not be committed to Git.

## Public vs Private Repository

| Public | Private |
|---|---|
| Anyone can usually pull | Authentication is required |
| Suitable for open-source images | Suitable for internal applications |
| Image content is publicly visible | Access is restricted |
| Secrets must still never be included | Secrets must still never be included |

A private registry does not make it safe to place secrets inside an image.

## Troubleshooting

### Access Denied

Possible causes:

- Incorrect username
- Invalid or expired token
- Repository does not exist
- Incorrect repository namespace
- Missing push permission

Check:

```bash
docker logout
docker login --username arulkumar27
```

### Image Does Not Exist Locally

```bash
docker image ls
```

Confirm the source image name and tag before running `docker tag`.

### Incorrect Tag Format

Correct:

```text
username/repository:version
```

Example:

```text
arulkumar27/devops-portfolio:1.0.0
```

## Cleanup

```bash
docker rm -f registry-practice
```

```bash
docker image rm \
  arulkumar27/devops-portfolio:1.0.0 \
  arulkumar27/devops-portfolio:stable \
  arulkumar27/devops-portfolio:latest
```

Removing a local image does not delete it from Docker Hub.
