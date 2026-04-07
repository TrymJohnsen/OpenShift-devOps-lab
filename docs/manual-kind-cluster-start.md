# Manuell oppstart av Kubernetes-cluster med kind

Denne guiden viser hvordan du kan starte det lokale Kubernetes-clusteret manuelt, uten å bruke scriptet i `scripts/01-create-kind-cluster.sh`.

## Hva prosjektet bruker
- Cluster type: `kind`
- Standard cluster-navn: `interview-lab`
- Kubernetes-versjon i scriptet: `v1.31.0`
- Node image: `kindest/node:v1.31.0`

## Forutsetninger
Du trenger disse verktøyene installert:

```bash
docker --version
kind --version
kubectl version --client
```

Du må også ha Docker kjørende før du lager clusteret.

## 1. Velg cluster-navn
Prosjektet bruker `interview-lab` som standard:

```bash
CLUSTER_NAME="interview-lab"
K8S_VERSION="v1.31.0"
KIND_NODE_IMAGE="kindest/node:${K8S_VERSION}"
```

## 2. Start clusteret manuelt
Kjør dette:

```bash
kind create cluster \
  --name "${CLUSTER_NAME}" \
  --image "${KIND_NODE_IMAGE}"
```

Dette oppretter en lokal Kubernetes-klynge i Docker.

## 3. Verifiser at clusteret kjører
Når opprettelsen er ferdig, sjekk at `kubectl` peker til riktig context og at noden er oppe:

```bash
kubectl config get-contexts
kubectl cluster-info
kubectl get nodes -o wide
```

Hvis alt fungerer, skal du se en control-plane node med status `Ready`.

## 4. Sjekk hvilket context du bruker
`kind` lager vanligvis et context-navn som ligner dette:

```bash
kubectl config current-context
```

Vanlig output vil være:

```bash
kind-interview-lab
```

Hvis du har flere cluster lokalt, er dette nyttig å sjekke før du deployer noe.

## 5. Test at clusteret svarer
Du kan gjøre en enkel test med:

```bash
kubectl get pods -A
```

Da skal du minst se system-pods i `kube-system`.

## Vanlige feil

### Docker kjører ikke
Hvis `kind create cluster` feiler tidlig, sjekk at Docker er startet:

```bash
docker ps
```

### Clusteret finnes allerede
Hvis du prøver å opprette samme cluster på nytt, kan du først se hvilke cluster som finnes:

```bash
kind get clusters
```

Hvis `interview-lab` allerede finnes, kan du enten bruke det videre eller slette og opprette på nytt:

```bash
kind delete cluster --name interview-lab
```

## Manuell kommando vs script
Scriptet i `scripts/01-create-kind-cluster.sh` gjør i praksis dette:

```bash
kind create cluster --name "interview-lab" --image "kindest/node:v1.31.0"
kubectl cluster-info
kubectl get nodes -o wide
```

Forskjellen er bare at scriptet setter variablene og kjører kommandoene for deg.

## Rydd opp
Når du vil stoppe og slette clusteret:

```bash
kind delete cluster --name interview-lab
```
