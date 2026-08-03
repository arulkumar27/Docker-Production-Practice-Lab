# Docker Monitoring with Prometheus and Grafana

This practice stack collects and visualizes Docker container metrics.

## Architecture

```text
Docker containers
       ↓
    cAdvisor
       ↓
   Prometheus
       ↓
     Grafana
```

## Platform Requirement

This cAdvisor configuration is designed primarily for a Linux Docker host.

Docker Desktop on Windows or macOS runs containers inside a managed Linux environment, so host mounts, device access and container metrics may behave differently.

An Ubuntu EC2 practice instance is suitable, but monitoring ports must not be exposed publicly without appropriate restrictions.

## Security Warning

This local lab uses:

- Privileged cAdvisor access
- Host filesystem mounts
- A simple Grafana practice password

Use it only in an isolated practice environment.

Do not expose ports `3000`, `8081` or `9090` publicly.

## Validate Configuration

```bash
docker compose config
```

## Start the Monitoring Stack

```bash
docker compose up -d
```

## Check Services

```bash
docker compose ps
```

## Service URLs

| Service | Local URL |
|---|---|
| Sample Nginx | `http://localhost:8080` |
| cAdvisor | `http://localhost:8081` |
| Prometheus | `http://localhost:9090` |
| Grafana | `http://localhost:3000` |

## Verify Prometheus Targets

Open:

```text
http://localhost:9090/targets
```

Expected targets:

```text
prometheus:9090
cadvisor:8080
```

Both should report `UP`.

## Test Prometheus Queries

Open:

```text
http://localhost:9090
```

Try:

```promql
up
```

Container CPU usage:

```promql
rate(container_cpu_usage_seconds_total[5m])
```

Container memory usage:

```promql
container_memory_working_set_bytes
```

Container network receive rate:

```promql
rate(container_network_receive_bytes_total[5m])
```

Container network transmission rate:

```promql
rate(container_network_transmit_bytes_total[5m])
```

## Access Grafana

Open:

```text
http://localhost:3000
```

Local practice login:

```text
Username: admin
Password: local-practice-only
```

The Prometheus datasource is automatically provisioned.

## Create a Basic Grafana Dashboard

1. Open Grafana.
2. Select **Dashboards**.
3. Select **New dashboard**.
4. Add a visualization.
5. Select the Prometheus datasource.
6. Enter a PromQL query.
7. Apply the panel.
8. Save the dashboard.

### CPU Panel

```promql
sum by (name) (
  rate(container_cpu_usage_seconds_total{name!=""}[5m])
)
```

### Memory Panel

```promql
sum by (name) (
  container_memory_working_set_bytes{name!=""}
)
```

### Network Receive Panel

```promql
sum by (name) (
  rate(container_network_receive_bytes_total{name!=""}[5m])
)
```

Metric labels can differ depending on Docker, cAdvisor and host configuration. Inspect available labels in Prometheus and adjust the query when necessary.

## Generate Sample Traffic

```bash
for request_number in $(seq 1 500); do
  curl -s -o /dev/null http://localhost:8080
done
```

Observe changes in Prometheus and Grafana.

## View Service Logs

```bash
docker compose logs prometheus
docker compose logs grafana
docker compose logs cadvisor
```

Follow Prometheus logs:

```bash
docker compose logs -f prometheus
```

## Troubleshooting

### cAdvisor Does Not Start

Check:

```bash
docker compose logs cadvisor
```

Possible causes:

- Docker Desktop limitations
- Host path differences
- Missing `/dev/kmsg`
- Permission restrictions
- Unsupported cgroup configuration

### Prometheus Target Is Down

Check:

```bash
docker compose logs prometheus
```

Test from Prometheus:

```bash
docker compose exec prometheus \
  wget -qO- http://cadvisor:8080/metrics
```

### Grafana Cannot Reach Prometheus

The datasource URL must be:

```text
http://prometheus:9090
```

Do not use `localhost:9090` inside Grafana. Inside the Grafana container, `localhost` refers to Grafana itself.

## Stop the Stack

```bash
docker compose down
```

## Remove Monitoring Data

```bash
docker compose down --volumes
```

This permanently removes saved Prometheus metrics and Grafana configuration stored in the named volumes.
