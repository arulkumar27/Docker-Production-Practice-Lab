# GitHub Actions Docker Pipeline

The active workflow is stored at the repository root:

```text
.github/workflows/docker-ci.yaml
```

GitHub does not execute workflow files stored directly inside:

```text
10-ci-cd-integration/github-actions/
```

## Pipeline Stages

The workflow performs:

1. Repository checkout
2. Required-file validation
3. Image-tag generation
4. Docker Buildx configuration
5. Image build
6. Image inspection
7. Container smoke test
8. Trivy vulnerability scan
9. Docker Hub authentication
10. Main-branch image publishing
11. Cleanup

## Configure Docker Hub Variable

Open the GitHub repository:

```text
Settings
→ Secrets and variables
→ Actions
→ Variables
→ New repository variable
```

Create:

```text
Name: DOCKERHUB_USERNAME
Value: Your Docker Hub username
```

## Configure Docker Hub Secret

Create a repository secret:

```text
Name: DOCKERHUB_TOKEN
Value: Your Docker Hub access token
```

Do not use a real credential in the workflow YAML.

## Workflow Triggers

The pipeline runs when:

- Code is pushed to `main`
- Code is pushed to `develop`
- A pull request targets `main`
- The workflow is manually started

Path filters prevent unrelated repository changes from running this Docker workflow.

## Pull Request Behaviour

For pull requests, the pipeline:

- Builds the image
- Runs a container
- Performs a smoke test
- Scans the image

It does not authenticate with Docker Hub or push an image.

## Main Branch Behaviour

For the main branch, the pipeline also pushes:

```text
USERNAME/docker-ci-practice:sha-COMMIT
USERNAME/docker-ci-practice:latest
```

## Required GitHub Configuration

The workflow expects:

```text
Variable:
DOCKERHUB_USERNAME

Secret:
DOCKERHUB_TOKEN
```

If `DOCKERHUB_USERNAME` is missing, the image reference will be invalid and validation will fail.

## Check Workflow Execution

Open:

```text
GitHub repository
→ Actions
→ Docker CI
```

Review each pipeline step.

## Verify the Published Image

```bash
docker pull \
  arulkumar27/docker-ci-practice:latest
```

Run it:

```bash
docker run -d \
  --name published-ci-image \
  -p 8080:80 \
  arulkumar27/docker-ci-practice:latest
```

Test:

```bash
curl http://localhost:8080
```

Cleanup:

```bash
docker rm -f published-ci-image
```

## Security Practices

- Registry token stored as a GitHub secret
- Workflow receives only read access to repository contents
- Pull requests do not receive registry publishing access
- Images are scanned before publishing
- Temporary containers are removed
- Git commit is included in image metadata
- Branch publishing is explicitly restricted
- Concurrent outdated runs are cancelled

## Recommended Future Improvements

- Generate an SBOM
- Sign images
- Publish vulnerability reports
- Add container-structure tests
- Add multi-platform builds
- Push to Amazon ECR
- Deploy to a staging environment
- Require manual approval before production promotion
