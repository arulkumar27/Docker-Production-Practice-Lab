# Docker Resource Monitoring

The `docker stats` command displays live resource usage for running containers.

## Start Practice Containers

```bash
docker run -d \
  --name stats-nginx \
  --memory="256m" \
  --cpus="0.50" \
  nginx:alpine
```

```bash
docker run -d \
  --name stats-alpine \
  --memory="128m" \
  --cpus="0.25" \
  alpine:latest \
  sh -c 'while true; do sleep 3600; done'
```

## Monitor All Containers

```bash
docker stats
```

Press `Ctrl+C` to return to the terminal.

## Monitor Specific Containers

```bash
docker stats \
  stats-nginx \
  stats-alpine
```

## Display One Snapshot

```bash
docker stats --no-stream
```

## Select Output Columns

```bash
docker stats \
  --no-stream \
  --format \
  'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}'
```

## Important Metrics

| Metric | Meaning |
|---|---|
| CPU % | CPU being used by the container |
| Memory usage | Current memory consumption |
| Memory limit | Maximum configured memory |
| Memory % | Percentage of the limit being used |
| Network I/O | Data received and transmitted |
| Block I/O | Disk-related reads and writes |
| PIDs | Number of processes |

## Inspect Configured Limits

Memory limit:

```bash
docker inspect \
  --format '{{.HostConfig.Memory}}' \
  stats-nginx
```

CPU limit:

```bash
docker inspect \
  --format '{{.HostConfig.NanoCpus}}' \
  stats-nginx
```

Process limit:

```bash
docker inspect \
  --format '{{.HostConfig.PidsLimit}}' \
  stats-nginx
```

## Check Out-of-Memory Termination

```bash
docker inspect \
  --format '{{.State.OOMKilled}}' \
  stats-nginx
```

If Docker or the operating system terminated the container because of memory exhaustion, the result may be:

```text
true
```

## Check Container Processes

```bash
docker top stats-nginx
```

Inside the container:

```bash
docker exec stats-nginx ps
```

## Generate Basic Web Traffic

Publish another Nginx container:

```bash
docker run -d \
  --name traffic-nginx \
  -p 8080:80 \
  --memory="256m" \
  --cpus="0.50" \
  nginx:alpine
```

Generate requests:

```bash
for request_number in $(seq 1 100); do
  curl -s -o /dev/null http://localhost:8080
done
```

Observe:

```bash
docker stats traffic-nginx
```

## Monitoring Limitations

`docker stats` is useful for real-time checks but does not provide:

- Long-term metrics storage
- Historical graphs
- Alerting
- Advanced dashboards
- Distributed-service visibility

Production environments normally use a monitoring platform such as Prometheus and Grafana.

## Troubleshooting High CPU

1. Identify the affected container:

```bash
docker stats
```

2. Inspect processes:

```bash
docker top CONTAINER_NAME
```

3. Review logs:

```bash
docker logs \
  --tail 100 \
  CONTAINER_NAME
```

4. Check recent deployments and traffic.

5. Verify CPU limits:

```bash
docker inspect CONTAINER_NAME
```

## Troubleshooting High Memory

1. Check memory usage:

```bash
docker stats --no-stream
```

2. Check configured limits:

```bash
docker inspect CONTAINER_NAME
```

3. Check out-of-memory status:

```bash
docker inspect \
  --format '{{.State.OOMKilled}}' \
  CONTAINER_NAME
```

4. Review application logs.

5. Investigate memory leaks, cache growth and workload changes.

## Cleanup

```bash
docker rm -f \
  stats-nginx \
  stats-alpine \
  traffic-nginx
```
