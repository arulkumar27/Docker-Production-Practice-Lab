const express = require("express");

const app = express();
const port = Number(process.env.PORT) || 3000;
const startedAt = new Date().toISOString();

app.disable("x-powered-by");

app.get("/", (request, response) => {
  response.status(200).json({
    application: "Docker Multi-Stage Practice API",
    version: "1.0.0",
    environment: process.env.NODE_ENV || "development",
    message: "Application is running successfully",
    hostname: process.env.HOSTNAME || "unknown"
  });
});

app.get("/health", (request, response) => {
  response.status(200).json({
    status: "healthy",
    startedAt,
    uptimeSeconds: Math.floor(process.uptime())
  });
});

const server = app.listen(port, "0.0.0.0", () => {
  console.log(`Application listening on port ${port}`);
});

function shutdown(signal) {
  console.log(`${signal} received. Starting graceful shutdown.`);

  server.close(() => {
    console.log("HTTP server closed.");
    process.exit(0);
  });

  setTimeout(() => {
    console.error("Graceful shutdown timed out.");
    process.exit(1);
  }, 10000).unref();
}

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));
