#!/bin/bash

for cluster in {1..2}; do
	argocd cluster add "kind-cluster${cluster}" --name "cluster${cluster}" -y
done

for cluster in {1..2}; do
	echo "waiting for cluster${cluster}"
	while ! curl -sf -o /dev/null "https://whoami.apps.cluster${cluster}.house"; do
		sleep 1
	done

	curl -sf "https://whoami.apps.cluster${cluster}.house"
done
