all: external-secrets.yaml

external-secrets.yaml: version.txt
	helm template -n external-secrets \
		--no-hooks \
		--include-crds \
		--set fullnameOverride=external-secrets \
		--version=$(shell cat version.txt) \
		external-secrets/external-secrets > $@ || { rm -f $@; exit 1; }
