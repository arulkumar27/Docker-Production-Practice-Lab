# Basic Dockerfile Practice

This exercise creates a custom Nginx image using a basic Dockerfile.

## Build the Image

Run from this directory:

```bash
docker build \
  -t dockerfile-fundamentals:1.0.0 \
  .
```

## Run the Container

```bash
docker run -d \
  --name dockerfile-fundamentals \
  -p 8080:80 \
  dockerfile-fundamentals:1.0.0
```

## Test the Application

```bash
curl http://localhost:8080
```

Browser:

```text
http://localhost:8080
```

## View Image Layers

```bash
docker image history dockerfile-fundamentals:1.0.0
```

## Inspect the Image

```bash
docker image inspect dockerfile-fundamentals:1.0.0
```

## Test Docker Build Cache

Run the build again without changing any files:

```bash
docker build \
  -t dockerfile-fundamentals:1.0.0 \
  .
```

Docker should reuse previously cached layers.

Now modify `index.html` and build a new version:

```bash
docker build \
  -t dockerfile-fundamentals:1.1.0 \
  .
```

## Cleanup

```bash
docker rm -f dockerfile-fundamentals
docker image rm dockerfile-fundamentals:1.0.0
docker image rm dockerfile-fundamentals:1.1.0
```
