# 10 — Docker CI/CD Integration

This section demonstrates how Docker image building, testing, vulnerability scanning and registry publishing can be automated through CI/CD pipelines.

The examples include:

- Jenkins
- GitHub Actions
- Docker BuildKit
- Trivy vulnerability scanning
- Docker Hub image publishing
- Git commit-based image tagging

## Learning Objectives

After completing this section, I will be able to:

- Automate Docker image builds
- Validate Dockerfiles through a pipeline
- Run container smoke tests
- Scan images for vulnerabilities
- Authenticate securely with Docker Hub
- Tag images using Git commit identifiers
- Push verified images to a registry
- Configure branch-based publishing
- Clean temporary containers after pipeline execution
- Understand a production-oriented CI workflow

## CI/CD Pipeline Flow

```text
Git push or pull request
          ↓
Checkout source code
          ↓
Build Docker image
          ↓
Start test container
          ↓
Run smoke test
          ↓
Scan image with Trivy
          ↓
Authenticate with registry
          ↓
Push versioned image
          ↓
Remove temporary resources
```

## Pipeline Behaviour

| Event | Build | Test | Scan | Push |
|---|---:|---:|---:|---:|
| Pull request | Yes | Yes | Yes | No |
| Feature-branch push | Yes | Yes | Yes | No |
| Main-branch push | Yes | Yes | Yes | Yes |
| Manual workflow | Yes | Yes | Yes | Yes when run from main |

## Image Tags

The pipeline creates traceable tags such as:

```text
arulkumar27/docker-ci-practice:sha-a1b2c3d
arulkumar27/docker-ci-practice:latest
```

The Git commit tag connects the image to the source code used during the build.

## Folder Contents

| Path | Purpose |
|---|---|
| `sample-app/` | Small Nginx application used by both pipelines |
| `jenkins/Jenkinsfile` | Jenkins declarative pipeline |
| `github-actions/README.md` | GitHub Actions setup instructions |
| `/.github/workflows/docker-ci.yaml` | Active GitHub Actions workflow |

## Required Credentials

### Jenkins

Create a Jenkins username-and-password credential:

```text
Credential ID: dockerhub-credentials
Username: Docker Hub username
Password: Docker Hub access token
```

### GitHub Actions

Create:

```text
Repository variable:
DOCKERHUB_USERNAME

Repository secret:
DOCKERHUB_TOKEN
```

Do not store registry credentials in:

- Jenkinsfiles
- Workflow files
- Dockerfiles
- Shell scripts
- README files
- Source code
- Git history

## Practice Checklist

- [ ] Build the sample image locally
- [ ] Run the sample application
- [ ] Configure Jenkins credentials
- [ ] Execute the Jenkins pipeline
- [ ] Configure GitHub Actions secrets
- [ ] Open a pull request
- [ ] Verify build, test and scan stages
- [ ] Merge to the main branch
- [ ] Verify the image push
- [ ] Confirm the Git commit image tag
- [ ] Pull the published image
- [ ] Run the published image locally
