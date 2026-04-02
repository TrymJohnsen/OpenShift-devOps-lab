#!/usr/bin/env bash
set -euo pipefail

# namespace variabel
NS="interview-lab"

# vis pods
echo "== Pods =="
kubectl -n "${NS}" get pods -o wide

# navn på nginx pod, den første, for å bruke i videre kommandoer
POD="$(kubectl -n "${NS}" get pod -l app=nginx -o jsonpath='{.items[0].metadata.name}')"

# gir info om pod, logs, events og en rask sjekk inne i podden for å se at nginx kjører og kan serve requests
echo
echo "== Describe pod =="
kubectl -n "${NS}" describe pod "${POD}" | sed -n '1,120p'

# viser de siste 50 linjene i access og error loggene til nginx, hvis de finnes, og fortsetter selv om det ikke finnes noen logs (f.eks. hvis nginx ikke har startet)
echo
echo "== Logs (nginx access/error) =="
kubectl -n "${NS}" logs "${POD}" --tail=50 || true

# viser de siste 30 eventene i namespace, sortert etter tid, for å se om det har vært noen feil eller relevante hendelser
echo
echo "== Events =="
kubectl -n "${NS}" get events --sort-by=.lastTimestamp | tail -n 30

# kjør kommandoer inni nginx podden
# se hvilken bruker prosessen kjører som, nginx versjon, og gjør en enkel HTTP request til localhost for å se at nginx kan serve requests
echo
echo "== Exec a quick check inside pod =="
kubectl -n "${NS}" exec -it "${POD}" -- sh -lc 'id && nginx -v && wget -qO- http://127.0.0.1:8080 | head'


# scriptet tar en god lagvis debug-tilnærming:
# 1. Ser poden?
# 2. Hva sier pod-beskrivelsen?
# 3. Hva sier loggene?
# 4. Hva sier Kubernetes-events?
# 5. Fungerer appen inni containeren?