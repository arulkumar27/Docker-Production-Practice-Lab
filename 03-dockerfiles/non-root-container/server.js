const express = require("express");
const os = require("node:os");

const app = express();
const port = Number(process.env.PORT) || 3000;

app.disable("x-powered-by");

app.get("/", (request, response) => {
  response.status(200).json({
    application: "Non-Root Container Practice",
    message: "Application is running with restricted privileges",
    environment: process.env.NODE_ENV || "development",
    hostname: os.hostname(),
    processUserId: typeof process.getuid === "function"
      ? process.getuid()
      : "not-supported"
  });
});

app.get("/health", (request, response) => {
  response.status(200).json({
    status: "healthy",
    uptimeSeconds: Math.floor(process.uptime())
  });
});

const server = app.listen(port, "0.0.0.0", () => {
  console.log(`Non-root application listening on port ${port}`);
});

function shutdown(signal) {
  console.log(`${signal} received. Shutting down.`);

  server.close(() => {
    console.log("Application stopped successfully.");
    process.exit(0);
  });

  setTimeout(() => process.exit(1), 10000).unref();
}

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));
