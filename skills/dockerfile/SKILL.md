---
name: dockerfile
description: Generate an optimized, secure, production-ready Dockerfile and docker-compose for a given application. Use when containerizing an app or improving an existing Dockerfile.
argument-hint: <language/framework and app description>
user-invocable: true
---

You are a DevOps engineer writing production-grade container configurations.

## Dockerfile Best Practices

### Structure Template
```dockerfile
# ─── Stage 1: Dependencies ────────────────────────────────────────────────────
FROM [base-image]:[pinned-version] AS deps
WORKDIR /app
COPY [lockfile] ./
RUN [install command — deps only, no dev deps]

# ─── Stage 2: Build ───────────────────────────────────────────────────────────
FROM deps AS builder
COPY . .
RUN [build command]

# ─── Stage 3: Production ──────────────────────────────────────────────────────
FROM [minimal-base]:[pinned-version] AS production
WORKDIR /app

# Security: run as non-root
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

# Copy only production artifacts
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules

USER appuser
EXPOSE [port]

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD [health check command]

ENTRYPOINT ["[executable]"]
CMD ["[default args]"]
```

### Base Image Selection
| Language | Development | Production |
|----------|------------|-----------|
| Node.js | `node:20-alpine` | `node:20-alpine` (multi-stage) |
| Python | `python:3.12-slim` | `python:3.12-slim` |
| Go | `golang:1.22-alpine` | `gcr.io/distroless/static` |
| Java | `eclipse-temurin:21-jdk` | `eclipse-temurin:21-jre` |
| Ruby | `ruby:3.3-alpine` | `ruby:3.3-alpine` |

**Always pin to a specific version** — never use `:latest`

### Security Checklist
- [ ] Multi-stage build to minimize final image size
- [ ] Non-root user in production stage
- [ ] No secrets in ENV instructions (use runtime env or secrets manager)
- [ ] `.dockerignore` excludes: `.git`, `node_modules`, `*.env`, test files
- [ ] Read-only filesystem where possible (`--read-only` at runtime)
- [ ] Minimal base image (Alpine or distroless)

### .dockerignore Template
```
.git
.gitignore
node_modules
npm-debug.log
*.env
*.env.*
.env.local
coverage/
.nyc_output/
dist/
build/
*.test.ts
*.spec.ts
docs/
README.md
Dockerfile*
docker-compose*
```

## docker-compose Template (Development)
```yaml
version: "3.9"
services:
  app:
    build:
      context: .
      target: development
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    env_file:
      - .env.local
    volumes:
      - .:/app:delegated
      - /app/node_modules  # anonymous volume to preserve node_modules
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: devpassword
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

## Output
Provide:
1. `Dockerfile` (multi-stage, production-ready)
2. `.dockerignore`
3. `docker-compose.yml` (local development)
4. Build and run commands
5. Image size estimate and optimization notes
