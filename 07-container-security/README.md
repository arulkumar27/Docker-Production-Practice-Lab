# 07 — Docker Container Security

Container security requires protection across the complete image and container lifecycle.

This section covers non-root users, read-only filesystems, resource restrictions, secrets management, vulnerability scanning, Linux capabilities, and privilege-escalation prevention.

## Learning Objectives

After completing this section, I will be able to:

- Run containers as non-root users
- Configure a read-only root filesystem
- Provide controlled writable temporary storage
- Apply CPU, memory and process limits
- Remove unnecessary Linux capabilities
- Prevent privilege escalation
- Avoid storing secrets in images
- Scan images for known vulnerabilities
- Understand image supply-chain risks
- Apply a basic container-security checklist

## Container Security Layers

| Layer | Security Focus |
|---|---|
| Source code | Dependency and application vulnerabilities |
| Dockerfile | Base image, runtime user and exposed configuration |
| Image | Vulnerabilities, secrets and unnecessary packages |
| Registry | Access control, signing and image provenance |
| Runtime | Capabilities, filesystem, resources and networking |
| Host | Docker daemon, kernel, access and patching |
| CI/CD | Secret protection and trusted build pipeline |

## Basic Security Principles

### Use Trusted Base Images

```dockerfile
FROM alpine:3.21
```

Use maintained images from trusted publishers and select explicit versions.

### Run as a Non-Root User

```dockerfile
USER appuser
```

### Remove Linux Capabilities

```bash
docker run \
  --cap-drop=ALL \
  application:1.0.0
```

### Prevent Privilege Escalation

```bash
docker run \
  --security-opt=no-new-privileges:true \
  application:1.0.0
```

### Use a Read-Only Filesystem

```bash
docker run \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  application:1.0.0
```

### Apply Resource Limits

```bash
docker run \
  --memory="256m" \
  --cpus="0.50" \
  --pids-limit=100 \
  application:1.0.0
```

### Scan Images

```bash
trivy image application:1.0.0
```

## Dangerous Configuration Examples

Avoid privileged containers unless a reviewed requirement specifically demands them:

```bash
docker run --privileged application:1.0.0
```

Avoid mounting the Docker socket into untrusted containers:

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

Access to the Docker socket can provide extensive control over the Docker host.

Avoid storing secrets in Dockerfiles:

```dockerfile
ENV DATABASE_PASSWORD=real-password
```

Avoid broad writable host mounts:

```bash
-v /:/host
```

## Security Checklist

- [ ] Trusted and maintained base image
- [ ] Explicit image version
- [ ] Minimal runtime packages
- [ ] Non-root runtime user
- [ ] Read-only filesystem where possible
- [ ] Writable directories explicitly defined
- [ ] Linux capabilities removed
- [ ] Privilege escalation prevented
- [ ] Privileged mode not used
- [ ] CPU and memory limits configured
- [ ] Process limit configured
- [ ] Secrets excluded from images and Git
- [ ] Image scanned for vulnerabilities
- [ ] Image digest and source reviewed
- [ ] Only required ports published
- [ ] Container logs monitored
- [ ] Docker host regularly patched

## Folder Contents

| Folder | Purpose |
|---|---|
| `non-root-user/` | Build an image with a dedicated user |
| `read-only-filesystem/` | Restrict filesystem modifications |
| `resource-limits/` | Control CPU, memory and processes |
| `secrets-management/` | Provide secrets at runtime |
| `image-scanning/` | Scan images using Trivy |
