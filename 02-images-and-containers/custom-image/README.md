# Custom Docker Image Practice

This exercise builds a custom Nginx image containing a portfolio-style landing page.

## Files

```text
custom-image/
├── README.md
├── Dockerfile
├── .dockerignore
└── index.html
```

## Build the Image

Run from the `custom-image` directory:

```bash
docker build \
  -t arul-docker-portfolio:1.0.0 \
  .
```

## Verify the Image

```bash
docker image ls arul-docker-portfolio
```

Inspect it:

```bash
docker image inspect arul-docker-portfolio:1.0.0
```

View its layers:

```bash
docker image history arul-docker-portfolio:1.0.0
```

## Run the Container

```bash
docker run -d \
  --name arul-portfolio \
  -p 8080:80 \
  arul-docker-portfolio:1.0.0
```

## Verify the Application

```bash
docker ps
docker logs arul-portfolio
curl http://localhost:8080
```

Browser:

```text
http://localhost:8080
```

## Create Another Version

After modifying `index.html`, build a new version:

```bash
docker build \
  -t arul-docker-portfolio:1.1.0 \
  .
```

Run it using a different host port:

```bash
docker run -d \
  --name arul-portfolio-v1-1 \
  -p 8081:80 \
  arul-docker-portfolio:1.1.0
```

Both versions can run simultaneously:

```text
http://localhost:8080
http://localhost:8081
```

## Add a Stable Tag

```bash
docker tag \
  arul-docker-portfolio:1.1.0 \
  arul-docker-portfolio:stable
```

Verify:

```bash
docker image ls arul-docker-portfolio
```

## Important Learning

Unlike copying a file manually into a running container, the custom HTML file is now included in the image.

Every container created from this image will contain the same application files.

## Cleanup

```bash
docker rm -f arul-portfolio arul-portfolio-v1-1
```

Remove the image tags when no longer required:

```bash
docker image rm \
  arul-docker-portfolio:1.0.0 \
  arul-docker-portfolio:1.1.0 \
  arul-docker-portfolio:stable
```
