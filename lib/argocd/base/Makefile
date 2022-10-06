MANIFEST = argocd.yaml
VERSION = $(shell cat version.txt)
URL = https://raw.githubusercontent.com/argoproj/argo-cd/$(VERSION)/manifests/install.yaml

all: $(MANIFEST)

$(MANIFEST): version.txt
	curl -Lsf -o $@ $(URL)

clean:
	rm -f $(MANIFEST)
