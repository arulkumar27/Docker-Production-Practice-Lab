FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="Docker CI Practice"
LABEL org.opencontainers.image.description="Nginx application for Docker CI/CD practice"
LABEL org.opencontainers.image.authors="Arul Kumar"

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:80/ || exit 1
