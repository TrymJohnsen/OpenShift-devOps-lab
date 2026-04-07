# Manuell forklaring av debug drills

Denne guiden viser hvordan du kan gjøre samme feilsøking manuelt som i `scripts/03-debug-drills.sh`.

## Hva scriptet gjør
Scriptet følger en lagvis debug-flyt:
1. Ser på pods i namespace
2. Finner en `nginx`-pod
3. Kjører `describe` på poden
4. Leser logger
5. Leser events i namespace
6. Kjører en enkel test inne i containeren

Namespace som brukes er `interview-lab`.

## 1. Se pods
Start med å se hvilke pods som kjører:

```bash
kubectl -n interview-lab get pods -o wide
```

Dette gir deg pod-navn, status, restart-teller, node og IP-adresse.

## 2. Finn riktig pod
Scriptet finner første pod med label `app=nginx`. Manuelt kan du gjøre det enklere først:

```bash
kubectl -n interview-lab get pods -l app=nginx
```

Velg pod-navnet du vil undersøke videre.

## 3. Beskriv poden
Deretter kan du hente detaljert info:

```bash
kubectl -n interview-lab describe pod <pod-navn>
```

Her ser du blant annet:
- container image
- status og conditions
- restart-informasjon
- mounted volumes
- events nederst

Dette er ofte den raskeste måten å oppdage image-feil, probe-feil eller permission-problemer.

## 4. Les logger
Sjekk containerloggene:

```bash
kubectl -n interview-lab logs <pod-navn> --tail=50
```

Dette viser de siste 50 linjene. Hvis appen ikke starter riktig, kommer feilen ofte her.

## 5. Se events i namespace
For å se Kubernetes-hendelser sortert etter tid:

```bash
kubectl -n interview-lab get events --sort-by=.lastTimestamp
```

Events er nyttige når problemet ikke ligger i appen selv, men i scheduling, image pulls, probes eller security policy.

## 6. Test inne i containeren
Scriptet kjører også en rask sjekk inne i poden:

```bash
kubectl -n interview-lab exec -it <pod-navn> -- sh
```

Når du er inne i containeren, kan du teste:

```bash
id
nginx -v
wget -qO- http://127.0.0.1:8080 | head
```

Dette forteller deg:
- hvilken bruker prosessen kjører som
- om `nginx` er tilgjengelig
- om appen svarer lokalt inne i containeren

## Hvordan tenke i praksis
En nyttig rekkefølge er:
1. `get pods` for å se status
2. `describe pod` for å lese Kubernetes sin forklaring
3. `logs` for å lese appens forklaring
4. `get events` for å se hva clusteret rapporterer
5. `exec` for å teste direkte inne i containeren

Dette gjør det lettere å skille mellom:
- app-feil
- konfigurasjonsfeil
- nettverksfeil
- Kubernetes-feil
- security / permission-feil

## Manuell kommando vs script
Scriptet i `scripts/03-debug-drills.sh` gjør i praksis dette:

```bash
kubectl -n interview-lab get pods -o wide
kubectl -n interview-lab get pods -l app=nginx
kubectl -n interview-lab describe pod <pod-navn>
kubectl -n interview-lab logs <pod-navn> --tail=50
kubectl -n interview-lab get events --sort-by=.lastTimestamp
kubectl -n interview-lab exec -it <pod-navn> -- sh
```

Forskjellen er at scriptet automatisk finner pod-navnet og kjører alt i en fast rekkefølge.
