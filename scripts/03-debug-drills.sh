#!/usr/bin/env bash
set -euo pipefail

NS="interview-lab"

echo "== Pods =="
kubectl -n "${NS}" get pods -o wide

POD="$(kubectl -n "${NS}" get pod -l app=nginx -o jsonpath='{.items[0].metadata.name}')"

echo
echo "== Describe pod =="
kubectl -n "${NS}" describe pod "${POD}" | sed -n '1,120p'

echo
echo "== Logs (nginx access/error) =="
kubectl -n "${NS}" logs "${POD}" --tail=50 || true

echo
echo "== Events =="
kubectl -n "${NS}" get events --sort-by=.lastTimestamp | tail -n 30

echo
echo "== Exec a quick check inside pod =="
kubectl -n "${NS}" exec -it "${POD}" -- sh -lc 'id && nginx -v && wget -qO- http://127.0.0.1:8080 | head'