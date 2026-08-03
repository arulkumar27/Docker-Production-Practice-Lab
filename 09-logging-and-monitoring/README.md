# 09 — Docker Logging and Monitoring

Container observability helps teams understand application behaviour, resource usage, failures and service availability.

This section covers container logs, real-time resource metrics, health checks, Prometheus, cAdvisor and Grafana.

## Learning Objectives

After completing this section, I will be able to:

- View container standard output and error logs
- Follow logs in real time
- Filter logs using time and line limits
- Understand Docker logging drivers
- Monitor CPU and memory usage
- Configure container health checks
- Differentiate running and healthy states
- Collect container metrics using cAdvisor
- Store metrics using Prometheus
- Visualize metrics using Grafana
- Follow a basic troubleshooting workflow

## Observability Components

| Component | Purpose |
|---|---|
| Logs | Records application and container events |
| Metrics | Measures CPU, memory, network and application values |
| Health checks | Determines whether a service responds correctly |
| Alerts | Notifies teams when defined conditions occur |
| Traces | Tracks requests across distributed services |

This section focuses on logs, metrics and health checks.

## Running vs Healthy

A running container only means its main process has not exited.

A healthy container means a configured health-check command is succeeding.

Example:

```text
Running but unhealthy:
The application process exists, but its HTTP endpoint is not responding.

Running and healthy:
The process exists and the health endpoint responds successfully.
```

## Quick Logging Example

```bash
docker run -d \
  --name logging-nginx \
  -p 8080:80 \
  nginx:alpine
```

Generate requests:

```bash
curl http://localhost:8080
curl http://localhost:8080/not-found
```

View logs:

```bash
docker logs logging-nginx
```

## Quick Metrics Example

```bash
docker stats logging-nginx
```

Single output:

```bash
docker stats --no-stream logging-nginx
```

## Quick Health-Check Example

```bash
docker run -d \
  --name healthy-nginx \
  -p 8081:80 \
  --health-cmd='wget --quiet --tries=1 --spider http://127.0.0.1:80/ || exit 1' \
  --health-interval=30s \
  --health-timeout=5s \
  --health-retries=3 \
  --health-start-period=10s \
  nginx:alpine
```

Check:

```bash
docker ps
```

## Monitoring Architecture

```text
Containers
    ↓
cAdvisor
    ↓
Prometheus
    ↓
Grafana
```

- cAdvisor exposes container resource metrics
- Prometheus collects and stores the metrics
- Grafana queries Prometheus and visualizes the results

## Files in This Folder

| File or Folder | Purpose |
|---|---|
| `docker-logs.md` | Container-log commands and practices |
| `docker-stats.md` | CPU and memory monitoring |
| `health-checks/` | Healthy and unhealthy container practice |
| `prometheus-grafana/` | Container monitoring stack |

## Practice Checklist

- [ ] View container logs
- [ ] Follow logs continuously
- [ ] Filter logs by time
- [ ] Inspect a logging driver
- [ ] Monitor CPU and memory
- [ ] Configure a health check
- [ ] Inspect health-check history
- [ ] Troubleshoot an unhealthy container
- [ ] Start cAdvisor
- [ ] Configure Prometheus
- [ ] Connect Grafana to Prometheus
- [ ] Query container metrics
