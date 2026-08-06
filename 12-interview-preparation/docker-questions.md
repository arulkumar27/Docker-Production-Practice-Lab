# Docker Interview Questions and Answers

## 1. What is Docker?

Docker is a containerization platform used to package an application with its dependencies and run it consistently across different environments.

## 2. What is a Docker image?

A Docker image is a read-only application package containing code, runtime, libraries, dependencies and configuration.

## 3. What is a container?

A container is a running or stopped instance of a Docker image.

## 4. Image vs Container

An image is a reusable template. A container is an executable instance created from that image.

## 5. Container vs Virtual Machine

Containers share the host operating-system kernel and use fewer resources. Virtual machines run complete guest operating systems through a hypervisor.

## 6. What is a Dockerfile?

A Dockerfile contains instructions used to build a Docker image.

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

## 7. What is Docker Compose?

Docker Compose defines and manages multi-container applications using a YAML file.

```bash
docker compose up -d
```

## 8. What is a Docker volume?

A Docker volume provides persistent storage independent of the container lifecycle.

## 9. Bind Mount vs Named Volume

A bind mount uses a specific host path. A named volume is created and managed by Docker.

## 10. What is Docker networking?

Docker networking allows containers to communicate with other containers, the host and external systems.

## 11. What is port mapping?

Port mapping forwards traffic from a host port to a container port.

```bash
docker run -p 8080:80 nginx
```

## 12. What is a multi-stage build?

A multi-stage build uses multiple `FROM` instructions to separate build and runtime requirements, helping reduce the final image size.

## 13. What is `.dockerignore`?

`.dockerignore` prevents unnecessary or sensitive files from entering the Docker build context.

## 14. Why do containers exit automatically?

A container exits when its main process completes or fails.

## 15. What is a health check?

A health check tests whether the application inside a container is responding correctly.

## 16. Why run containers as non-root?

Running as non-root follows least privilege and reduces the impact of an application compromise.

## 17. How do containers communicate?

Containers on the same custom network can communicate using service or container names.

## 18. What is a container registry?

A registry stores and distributes container images. Examples include Docker Hub, Amazon ECR and GitHub Container Registry.

## 19. What is the difference between `CMD` and `ENTRYPOINT`?

`ENTRYPOINT` defines the main executable. `CMD` provides a default command or default arguments that can be overridden.

## 20. How is Docker used in CI/CD?

CI/CD pipelines build the image, test it, scan it, push it to a registry and deploy the verified version.
