# Jenkins Docker CI/CD Pipeline

This pipeline performs:

1. Source-code checkout
2. Environment validation
3. Git commit tag generation
4. Docker image build
5. Image inspection
6. Container smoke testing
7. Trivy vulnerability scanning
8. Docker Hub publishing from the main branch
9. Temporary-container cleanup

## Jenkins Requirements

The Jenkins agent requires:

- Git
- Docker CLI
- Access to a Docker daemon
- `curl`
- Jenkins Pipeline support
- Docker Hub credentials configured in Jenkins

## Docker Permission

The Jenkins operating-system user must have authorized access to the Docker daemon.

Example on an isolated Ubuntu Jenkins agent:

```bash
sudo usermod -aG docker jenkins
```

Restart Jenkins after changing group membership:

```bash
sudo systemctl restart jenkins
```

Verify:

```bash
sudo -u jenkins docker version
```

Membership in the Docker group provides powerful host-level access. Use isolated and controlled Jenkins agents.

## Configure Docker Hub Credentials

In Jenkins:

```text
Manage Jenkins
→ Credentials
→ System
→ Global credentials
→ Add Credentials
```

Configure:

```text
Kind: Username with password
Username: Docker Hub username
Password: Docker Hub access token
ID: dockerhub-credentials
```

## Create the Jenkins Pipeline

Create:

```text
New Item
→ Pipeline
```

Recommended approach:

```text
Definition: Pipeline script from SCM
SCM: Git
Repository URL: GitHub repository URL
Branch: */main
Script Path: 10-ci-cd-integration/jenkins/Jenkinsfile
```

## Branch-Based Publishing

The pipeline pushes images only when Jenkins identifies the branch as:

```text
main
```

For accurate branch detection, a Jenkins Multibranch Pipeline is recommended.

Feature branches still execute:

- Build
- Inspect
- Smoke test
- Vulnerability scan

## Image Tags

Example:

```text
arulkumar27/docker-ci-practice:sha-a1b2c3d
arulkumar27/docker-ci-practice:latest
```

## Trivy Policy

The pipeline:

- Displays high and critical vulnerabilities
- Fails only for fixed critical vulnerabilities
- Ignores currently unfixed findings in the blocking step

Real organizations should select a policy based on their security requirements.

## Common Problems

### Docker Permission Denied

```bash
sudo -u jenkins docker version
```

Confirm the Jenkins user belongs to the authorized Docker group and restart the Jenkins service.

### Smoke Test Fails

Check:

```bash
docker logs jenkins-docker-ci-test
docker ps -a
curl -v http://127.0.0.1:8085
```

### Docker Hub Push Denied

Confirm:

- Correct Docker Hub username
- Valid access token
- Correct credential ID
- Repository exists
- User has permission to push

### Pipeline Does Not Push

Confirm the pipeline is running as a multibranch job and Jenkins identifies the branch as `main`.

## Security Notes

- Use an isolated Jenkins agent
- Never hard-code registry credentials
- Protect Jenkins credentials
- Restrict access to the Docker daemon
- Do not run untrusted pull-request code on a privileged agent
- Apply plugin and operating-system updates
- Review container images used by the pipeline
