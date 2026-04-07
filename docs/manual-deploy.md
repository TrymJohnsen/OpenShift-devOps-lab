# Manuell deploy til Kubernetes

Denne guiden viser hvordan du kan deploye manifestene manuelt, uten å bruke `scripts/02-deploy.sh`.

## Hva scriptet gjør
Scriptet deployer ressursene i `manifests/`, venter på at `nginx`-deploymenten blir klar, og skriver så ut en oversikt over ressursene i namespace `interview-lab`.

## Forutsetninger
Før du deployer bør dette være på plass:

```bash
kubectl config current-context
kubectl get nodes
```

Du bør også ha et kjørende cluster, for eksempel `kind-interview-lab`.

## 1. Opprett namespace
Start med namespace-filen:

```bash
kubectl apply -f manifests/00-namespace.yaml
```

Dette oppretter namespace `interview-lab` hvis det ikke allerede finnes.

## 2. Deploy alle manifestene
Deretter kan du deploye alt i `manifests/`:

```bash
kubectl apply -f manifests/
```

Dette oppretter eller oppdaterer ressursene som ligger der, for eksempel `Deployment`, `Service`, `Ingress`, `ConfigMap` eller andre YAML-filer i mappen.

## 3. Vent på rollout
Når manifestene er applied, kan du sjekke at `nginx` faktisk blir `Ready`:

```bash
kubectl -n interview-lab rollout status deploy/nginx --timeout=240s
```

Hvis dette lykkes, betyr det at deploymenten har startet nye pods og at de har blitt klare innen tidsfristen.

## 4. Se ressursene i namespace
For å få en rask oversikt:

```bash
kubectl -n interview-lab get all
kubectl -n interview-lab get ingress
```

Dette viser pods, deployments, replicasets, services og ingress-ressurser som ble opprettet.

## Ekstra sjekker
Hvis du vil kontrollere litt mer manuelt:

```bash
kubectl -n interview-lab get pods -o wide
kubectl -n interview-lab describe deploy nginx
kubectl -n interview-lab get events --sort-by=.lastTimestamp
```

## Vanlige feil

### Feil context
Hvis du deployer til feil cluster, sjekk:

```bash
kubectl config current-context
```

### Rollout blir ikke ferdig
Hvis `rollout status` henger eller feiler, sjekk:

```bash
kubectl -n interview-lab get pods
kubectl -n interview-lab describe pod <pod-navn>
kubectl -n interview-lab logs <pod-navn>
```

## Manuell kommando vs script
Scriptet i `scripts/02-deploy.sh` gjør i praksis dette:

```bash
kubectl apply -f manifests/00-namespace.yaml
kubectl apply -f manifests/
kubectl -n interview-lab rollout status deploy/nginx --timeout=240s
kubectl -n interview-lab get all
kubectl -n interview-lab get ingress
```

Forskjellen er bare at du her kjører stegene ett og ett manuelt.
