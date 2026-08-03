FROM node:22-alpine AS dependencies

WORKDIR /build

COPY package.json ./

RUN npm install --omit=dev && \
    npm cache clean --force

FROM node:22-alpine AS runtime

LABEL org.opencontainers.image.title="Multi-Stage Node Application"
LABEL org.opencontainers.image.description="Node.js API built using a multi-stage Dockerfile"
LABEL org.opencontainers.image.authors="Arul Kumar"
LABEL org.opencontainers.image.version="1.0.0"

ENV NODE_ENV=production
ENV PORT=3000

WORKDIR /app

COPY --from=dependencies /build/node_modules ./node_modules
COPY package.json server.js ./

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:3000/health || exit 1

CMD ["node", "server.js"]
