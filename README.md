# Docker Production Practice Lab

A structured hands-on repository created to learn, practise, and demonstrate Docker concepts from fundamentals to production-oriented container workflows.

This repository contains topic-based practice folders, reusable examples, troubleshooting exercises, and one complete real-time multi-container project.

> This is a learning and practice repository. The configurations demonstrate production-oriented concepts but are not claimed as a live production deployment.

## Objectives

- Understand Docker architecture and container lifecycle
- Write efficient and secure Dockerfiles
- Build and manage custom Docker images
- Practise Docker networking and persistent storage
- Run multi-container applications using Docker Compose
- Manage environment variables, secrets, health checks, and resource limits
- Implement container logging and monitoring
- Troubleshoot common Docker problems
- Understand Docker usage within CI/CD pipelines
- Build one complete production-style project

## Repository Structure

```text
Docker-Production-Practice-Lab/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── 01-docker-fundamentals/
│   ├── README.md
│   ├── architecture.md
│   ├── installation.md
│   ├── container-lifecycle.md
│   └── basic-commands.md
│
├── 02-images-and-containers/
│   ├── README.md
│   ├── image-commands.md
│   ├── container-commands.md
│   ├── nginx-container/
│   └── custom-image/
│
├── 03-dockerfiles/
│   ├── README.md
│   ├── basic-dockerfile/
│   ├── multi-stage-build/
│   ├── non-root-container/
│   └── dockerfile-best-practices/
│
├── 04-storage-and-volumes/
│   ├── README.md
│   ├── bind-mounts/
│   ├── named-volumes/
│   ├── tmpfs-mounts/
│   └── backup-and-restore/
│
├── 05-docker-networking/
│   ├── README.md
│   ├── bridge-network/
│   ├── host-network/
│   ├── custom-network/
│   └── container-dns/
│
├── 06-docker-compose/
│   ├── README.md
│   ├── basic-compose/
│   ├── service-dependencies/
│   ├── environment-variables/
│   └── compose-profiles/
│
├── 07-container-security/
│   ├── README.md
│   ├── non-root-user/
│   ├── read-only-filesystem/
│   ├── resource-limits/
│   ├── secrets-management/
│   └── image-scanning/
│
├── 08-registry-and-image-management/
│   ├── README.md
│   ├── docker-hub.md
│   ├── image-tagging.md
│   ├── image-versioning.md
│   └── cleanup.md
│
├── 09-logging-and-monitoring/
│   ├── README.md
│   ├── docker-logs.md
│   ├── docker-stats.md
│   ├── health-checks/
│   └── prometheus-grafana/
│
├── 10-ci-cd-integration/
│   ├── README.md
│   ├── jenkins/
│   └── github-actions/
│
├── 11-troubleshooting/
│   ├── README.md
│   ├── exited-containers.md
│   ├── permission-errors.md
│   ├── networking-errors.md
│   ├── volume-errors.md
│   └── troubleshooting-checklist.md
│
├── 12-interview-preparation/
│   ├── README.md
│   ├── docker-questions.md
│   ├── scenario-questions.md
│   └── command-cheatsheet.md
│
└── 13-real-time-project/
    └── containerized-web-platform/
        ├── README.md
        ├── architecture.md
        ├── .env.example
        ├── compose.yaml
        ├── compose.dev.yaml
        ├── compose.prod.yaml
        ├── frontend/
        ├── backend/
        ├── database/
        ├── nginx/
        ├── monitoring/
        ├── scripts/
        └── docs/
```

## Real-Time Project: Containerized Web Platform

The project demonstrates how multiple application components can be containerized and operated together.

### Architecture

```text
User
  |
Nginx Reverse Proxy
  |
  ├── Frontend Container
  |
  └── Backend API Container
          |
          ├── PostgreSQL Container
          └── Redis Container

Monitoring:
Prometheus + Grafana
```

### Services

| Service | Responsibility |
|---|---|
| Nginx | Reverse proxy and request routing |
| Frontend | User interface |
| Backend API | Application and business logic |
| PostgreSQL | Persistent relational data |
| Redis | Caching and temporary data |
| Prometheus | Metrics collection |
| Grafana | Metrics visualization |

### Concepts Demonstrated

- Multi-stage Docker builds
- Lightweight base images
- Non-root container execution
- Custom Docker networks
- Named volumes for persistent data
- Environment-specific Compose files
- Container health checks
- Service dependency management
- Restart policies
- CPU and memory limits
- Reverse-proxy routing
- Centralized configuration
- Image tagging and versioning
- Logging and monitoring
- Vulnerability scanning
- CI/CD image build workflow
- Backup and recovery procedures

## Prerequisites

- Git
- Docker Engine or Docker Desktop
- Docker Compose
- GitHub account
- Basic Linux command-line knowledge

## Common Commands

```bash
# Check Docker installation
docker --version
docker compose version

# Build project images
docker compose build

# Start all services
docker compose up -d

# List running containers
docker compose ps

# View service logs
docker compose logs -f

# View a particular service
docker compose logs -f backend

# View container resource usage
docker stats

# Stop the application
docker compose stop

# Start stopped services
docker compose start

# Stop and remove containers
docker compose down

# Stop containers and remove volumes
docker compose down -v
```

> `docker compose down -v` deletes the project’s named-volume data. Use it carefully.

## Learning Workflow

1. Read the README inside each topic folder.
2. Execute the provided commands manually.
3. Build the practice Dockerfiles.
4. Inspect images, containers, networks, and volumes.
5. Reproduce and troubleshoot the documented errors.
6. Complete the real-time project.
7. Integrate image building and scanning into CI/CD.
8. Document observations and solutions.

## Security Practices

- Run application processes as non-root users
- Avoid storing credentials inside Dockerfiles
- Use environment files only for local practice
- Add sensitive files to `.gitignore`
- Use trusted and minimal base images
- Pin important image versions
- Scan images before deployment
- Apply CPU and memory limits
- Remove unnecessary packages and permissions

## Troubleshooting Approach

When a container fails:

```bash
docker ps -a
docker logs <container_name>
docker inspect <container_name>
docker stats
docker network inspect <network_name>
docker volume inspect <volume_name>
docker exec -it <container_name> /bin/sh
```

The troubleshooting section includes exercises covering:

- Containers exiting immediately
- Port conflicts
- Docker daemon permission errors
- Failed health checks
- DNS and container communication failures
- Missing environment variables
- Volume permission problems
- Large image sizes
- Application connection failures

## Skills Demonstrated

- Docker CLI
- Dockerfile development
- Container image optimization
- Docker Compose
- Container networking
- Persistent storage
- Reverse proxy configuration
- Container security
- Observability
- Troubleshooting
- CI/CD integration
- Technical documentation

## Future Improvements

- Push versioned images to Docker Hub
- Add automated integration tests
- Add Trivy image scanning
- Add Jenkins and GitHub Actions pipelines
- Deploy the application to an AWS EC2 instance
- Add HTTPS support
- Migrate the application to Kubernetes

## Author

**Arul Kumar**

Aspiring Cloud and DevOps Engineer focused on AWS, Linux, Docker, Kubernetes, Jenkins, Terraform, Ansible, and CI/CD automation.

## Disclaimer

This repository is intended for learning, experimentation, interview preparation, and portfolio demonstration. Production-inspired practices are included to develop practical understanding.
