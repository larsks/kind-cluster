## Applications

<!--
find .. -name clusters -prune -o -name .git -execdir git remote -v \; |
awk '{print $2}' |
sed '
  s|ssh://||
  s|git@|https://|
  s|:larsks|/larsks|
  s/.git$//
' |
sort -u |
awk -F/ '
  {printf "- [%s](%s)\n", $5, $0}
' |
sed 's/k8s-//'
-->

- [argocd](https://github.com/larsks/k8s-argocd)
- [argocd-apps](https://github.com/larsks/k8s-argocd-apps)
- [cert-manager](https://github.com/larsks/k8s-cert-manager)
- [devpi](https://github.com/larsks/k8s-devpi)
- [external-secrets](https://github.com/larsks/k8s-external-secrets)
- [metallb](https://github.com/larsks/k8s-metallb)
- [nginx-ingress](https://github.com/larsks/k8s-nginx-ingress)
- [postgres](https://github.com/larsks/k8s-postgres)
- [step-ca](https://github.com/larsks/k8s-step-ca)
- [traefik-ingress](https://github.com/larsks/k8s-traefik-ingress)
- [whoami](https://github.com/larsks/k8s-whoami)
