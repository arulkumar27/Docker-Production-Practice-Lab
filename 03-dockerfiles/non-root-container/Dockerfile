FROM node:22-alpine

LABEL org.opencontainers.image.title="Non-Root Node Application"
LABEL org.opencontainers.image.description="Security-focused Node.js container running as a dedicated user"
LABEL org.opencontainers.image.authors="Arul Kumar"
LABEL org.opencontainers.image.version="1.0.0"

ARG APP_UID=10001
ARG APP_GID=10001

ENV NODE_ENV=production
ENV PORT=3000

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

COPY package.json ./

RUN npm install --omit=dev && \
    npm cache clean --force

COPY --chown=appuser:appgroup server.js ./

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:3000/health || exit 1

CMD ["node", "server.js"]
