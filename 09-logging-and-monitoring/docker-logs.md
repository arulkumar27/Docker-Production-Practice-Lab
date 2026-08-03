# Docker Container Logs

Docker captures output written by a container's main process to:

- Standard output
- Standard error

Applications should normally write operational logs to these streams instead of storing all logs only inside the container filesystem.

## Start an Nginx Container

```bash
docker run -d \
  --name logs-nginx \
  -p 8080:80 \
  nginx:alpine
```

## Generate Log Entries

Successful request:

```bash
curl http://localhost:8080
```

Not-found request:

```bash
curl http://localhost:8080/not-found
```

Generate several requests:

```bash
for request_number in 1 2 3 4 5; do
  curl -s -o /dev/null http://localhost:8080
done
```

## View Logs

```bash
docker logs logs-nginx
```

## Follow Logs in Real Time

```bash
docker logs -f logs-nginx
```

Press `Ctrl+C` to stop following logs. This does not stop the container.

## Show Timestamps

```bash
docker logs \
  --timestamps \
  logs-nginx
```

## Show Latest Lines

```bash
docker logs \
  --tail 20 \
  logs-nginx
```

## Follow from the Latest Lines

```bash
docker logs \
  --follow \
  --tail 10 \
  logs-nginx
```

## Show Logs Since a Duration

Latest five minutes:

```bash
docker logs \
  --since 5m \
  logs-nginx
```

Latest hour:

```bash
docker logs \
  --since 1h \
  logs-nginx
```

## Show Logs Between Times

```bash
docker logs \
  --since "2026-08-03T10:00:00" \
  --until "2026-08-03T11:00:00" \
  logs-nginx
```

Use timestamps appropriate for the Docker host's environment and timezone handling.

## Search Logs

```bash
docker logs logs-nginx 2>&1 |
  grep "404"
```

Case-insensitive search:

```bash
docker logs logs-nginx 2>&1 |
  grep -i "error"
```

## Compose Logs

All services:

```bash
docker compose logs
```

Specific service:

```bash
docker compose logs web
```

Follow a service:

```bash
docker compose logs -f web
```

Latest 50 lines:

```bash
docker compose logs \
  --tail 50 \
  web
```

## Inspect the Logging Driver

```bash
docker inspect \
  --format '{{.HostConfig.LogConfig.Type}}' \
  logs-nginx
```

Check Docker's default logging driver:

```bash
docker info \
  --format '{{.LoggingDriver}}'
```

## Configure Log Rotation

```bash
docker run -d \
  --name rotated-logs-nginx \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  nginx:alpine
```

Configuration:

| Option | Purpose |
|---|---|
| `max-size=10m` | Rotate when the current log reaches 10 MB |
| `max-file=3` | Retain a maximum of three log files |

## Compose Log Rotation

```yaml
services:
  application:
    image: application:1.0.0
    logging:
      driver: json-file
      options:
        max-size: 10m
        max-file: "3"
```

## Common Logging Drivers

| Driver | Purpose |
|---|---|
| `json-file` | Stores logs in Docker's JSON format |
| `local` | Docker-managed local log storage |
| `journald` | Sends logs to systemd journal |
| `syslog` | Sends logs to a syslog server |
| `fluentd` | Sends logs to Fluentd |
| `awslogs` | Sends logs to Amazon CloudWatch Logs |
| `splunk` | Sends logs to Splunk |
| `none` | Disables Docker log collection |

The available and appropriate driver depends on the environment.

## Log Troubleshooting Workflow

1. Confirm the container exists:

```bash
docker ps -a
```

2. Check container logs:

```bash
docker logs CONTAINER_NAME
```

3. Check exit code:

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  CONTAINER_NAME
```

4. Check out-of-memory status:

```bash
docker inspect \
  --format '{{.State.OOMKilled}}' \
  CONTAINER_NAME
```

5. Check runtime configuration:

```bash
docker inspect CONTAINER_NAME
```

6. Check resource usage:

```bash
docker stats --no-stream CONTAINER_NAME
```

## Logging Best Practices

- Write application logs to stdout and stderr
- Use structured logs such as JSON where appropriate
- Include timestamps and request identifiers
- Do not write passwords or tokens into logs
- Configure log rotation
- Centralize logs in production
- Control access to log systems
- Define retention requirements
- Monitor repeated errors and abnormal patterns

## Cleanup

```bash
docker rm -f \
  logs-nginx \
  rotated-logs-nginx
```
