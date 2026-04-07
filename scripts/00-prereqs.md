# Prereqs (Windows + WSL2 Ubuntu)

## Install / verify in WSL2 Ubuntu
- docker (Docker Desktop on Windows with WSL2 integration) OR podman (hardere på Windows)
- kind
- kubectl

## If you do not have them

### Docker
- Install Docker Desktop on Windows.
- In Docker Desktop, enable WSL2 integration for your Ubuntu distro.
- Verify in WSL:
  - `docker version`

### kind
- Install in WSL Ubuntu:
  - `curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64`
  - `chmod +x ./kind`
  - `sudo mv ./kind /usr/local/bin/kind`
- Verify:
  - `kind version`

### kubectl
- Install in WSL Ubuntu:
  - `sudo snap install kubectl --classic`
- Verify:
  - `kubectl version --client`

Quick checks:
- `docker version`
- `kind version`
- `kubectl version --client`

Notes:
- With kind, Kubernetes runs in Docker containers.
- If Docker isn't available inside WSL2, enable WSL integration in Docker Desktop settings.
