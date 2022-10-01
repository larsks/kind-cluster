all: traefik.yaml

traefik.yaml: version.txt values.yaml
	helm template -n traefik-ingress \
		--no-hooks \
		--include-crds \
		--set fullnameOverride=traefik \
		-f values.yaml \
		--version=$(shell cat version.txt) \
		traefik/traefik > $@ || { rm -f $@; exit 1; }

clean:
	rm -f traefik.yaml
