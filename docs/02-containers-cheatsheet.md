# Containers cheatsheet

## Core concepts
| Term | Meaning |
|------|---------|
| Image | Read-only template (layers) built from a Dockerfile |
| Container | Running instance of an image |
| Registry | Storage for images (Docker Hub, Quay, ghcr.io) |
| Volume | Persistent storage mounted into a container |
| Network | Virtual network connecting containers |

## Docker / Podman basics
```bash
# Build an image from a Dockerfile in the current directory
docker build -t myapp:latest .

# Run a container (foreground)
docker run --rm -p 8080:8080 myapp:latest

# Run detached, with env var and named volume
docker run -d \
  --name myapp \
  -p 8080:8080 \
  -e APP_ENV=prod \
  -v mydata:/data \
  myapp:latest

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View logs
docker logs myapp
docker logs -f myapp    # follow

# Execute a command inside a running container
docker exec -it myapp /bin/sh

# Stop and remove
docker stop myapp
docker rm myapp

# Remove an image
docker rmi myapp:latest

# List images
docker images
```

## Dockerfile best practices
```dockerfile
# Use a minimal base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy dependency file first (improves layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Run as non-root user (important for OpenShift SCC)
RUN adduser --disabled-password appuser
USER appuser

# Expose port (documentation only; does not publish)
EXPOSE 8080

CMD ["python", "main.py"]
```

## Ports and networking
```bash
# Port mapping: host:container
docker run -p 8080:8080 myapp   # host 8080 -> container 8080
docker run -p 9000:8080 myapp   # host 9000 -> container 8080

# Inspect container network
docker inspect myapp | grep -A 20 '"NetworkSettings"'

# Create a named network and run two containers on it
docker network create mynet
docker run -d --name api --network mynet myapp
docker run -d --name db --network mynet postgres:15
# 'api' can reach 'db' by hostname 'db'
```

## Environment variables
```bash
# Pass single env var
docker run -e DATABASE_URL=postgres://localhost/mydb myapp

# Pass from a file
docker run --env-file .env myapp
```

## Volumes
```bash
# Named volume (managed by Docker)
docker volume create mydata
docker run -v mydata:/data myapp

# Bind mount (maps host path)
docker run -v $(pwd)/config:/app/config:ro myapp
```

## Container health checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

## Podman vs Docker
- `podman` is a drop-in replacement: same CLI flags, rootless by default.
- On RHEL/OpenShift nodes, Podman is the preferred container runtime.
- Replace `docker` with `podman` in most commands above.
