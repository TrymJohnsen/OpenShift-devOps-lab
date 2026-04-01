# Prereqs (Windows + WSL2 Ubuntu)

## Install / verify in WSL2 Ubuntu
- docker (Docker Desktop on Windows with WSL2 integration) OR podman (hardere på Windows)
- kind
- kubectl

Quick checks:
- `docker version`
- `kind version`
- `kubectl version --client`

Notes:
- With kind, Kubernetes runs in Docker containers.
- If Docker isn't available inside WSL2, enable WSL integration in Docker Desktop settings.