#!/bin/bash

echo "waiting for argocd"
while ! kubectl -n argocd get deploy/argocd-server > /dev/null 2>&1; do echo -n .; sleep 1; done
echo
kubectl -n argocd wait --for=condition=Available deploy/argocd-server

password="$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)"

cat <<EOF

***
Initial admin password: $password
***

EOF

kubectl -n argocd port-forward service/argocd-server 8080:80 &

xdg-open http://localhost:8080

wait
