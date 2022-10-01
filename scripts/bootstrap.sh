#!/bin/bash

if ! [ -d secrets ]; then
	echo "ERROR: missing cluster secrets" >&2
	exit 1
fi

set -e

echo "*** Creating clusters"
find clusters/*/config.yaml | xargs -P0 -n1 kind create cluster --config
kubectl config use-context kind-infra

echo "*** Initializing cluster secrets"
kubectl apply -k secrets

echo "*** Apply argocd bootstrap"
kubectl apply -k apps/argocd/overlays/bootstrap

echo "*** Wait for ArgoCD"
while ! kubectl -n argocd get deploy/argocd-server > /dev/null 2>&1; do sleep 1; done
while ! kubectl -n argocd wait --for=condition=Available deploy/argocd-server; do sleep 1; done

echo "*** Install root application"
kubectl apply -k apps/root/overlays/infra

echo "*** Wait for ArgoCD ingress"
while ! curl -sf -o /dev/null https://argocd.apps.infra.house; do sleep 1; done

echo "*** All done!"
