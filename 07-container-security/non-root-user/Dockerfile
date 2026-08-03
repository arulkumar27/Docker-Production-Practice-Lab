FROM python:3.13-alpine

LABEL org.opencontainers.image.title="Non-Root Security Practice"
LABEL org.opencontainers.image.description="Minimal container running as a dedicated non-root user"
LABEL org.opencontainers.image.authors="Arul Kumar"
LABEL org.opencontainers.image.version="1.0.0"

ARG APP_UID=10001
ARG APP_GID=10001

RUN addgroup \
      --system \
      --gid "${APP_GID}" \
      appgroup && \
    adduser \
      --system \
      --uid "${APP_UID}" \
      --ingroup appgroup \
      --home /app \
      appuser

WORKDIR /app

RUN printf '%s\n' \
  '<!DOCTYPE html>' \
  '<html lang="en">' \
  '<head><meta charset="UTF-8"><title>Secure Container</title></head>' \
  '<body><h1>Non-Root Container</h1><p>Application is running as appuser.</p></body>' \
  '</html>' \
  > index.html && \
  chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=5s \
  --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:8080/ || exit 1

CMD ["python", "-m", "http.server", "8080", "--bind", "0.0.0.0"]
