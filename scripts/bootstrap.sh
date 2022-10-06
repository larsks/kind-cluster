#!/bin/bash

set -e

echo "*** Bootstrapping cluster"
kubectl apply -k bootstrap

echo "*** Wait for ArgoCD"
while ! kubectl -n argocd get deploy/argocd-server > /dev/null 2>&1; do sleep 1; done
while ! kubectl -n argocd wait --for=condition=Available deploy/argocd-server; do sleep 1; done

echo "*** Install root application"
kubectl apply -k lib/root

echo "*** Wait for ArgoCD ingress"
while ! curl -sf -o /dev/null https://argocd.apps.infra.house; do sleep 1; done

echo "*** All done!"
