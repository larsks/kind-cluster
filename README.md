## Prerequisites

### Software

For all this to run, we need:

- [Kind](https://kind.sigs.k8s.io/)
- [Docker](https://docker.com) (there is experimental support for [Podman](https://podman.io/), but I haven't tried that yet)
- `kubectl`

### Network configuration

I've made some specific configuration changes in my local network environment to support this repository. In particular:

- I have wildcard DNS entries configured for each cluster:

  | Name                    | Address       |
  |-------------------------|---------------|
  | `*.apps.infra.house`    | 192.168.1.200 |
  | `*.apps.cluster1.house` | 192.168.1.201 |
  | `*.apps.cluster2.house` | 192.168.1.202 |

  I also have the following static entries configured; these aren't necessary but I find them useful:

  | Name                 | Address       |
  |----------------------|---------------|
  | `api.infra.house`    | 192.168.1.200 |
  | `api.cluster1.house` | 192.168.1.201 |
  | `api.cluster2.house` | 192.168.1.202 |

- I have the above three addresses configured as additional addresses attached to `eth0` on the host running the Kind cluster:

  ```
  $ ip addr show eth0
  2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
      altname eno2
      altname enp0s31f6
      inet 192.168.1.200/24 brd 192.168.1.255 scope global noprefixroute eth0
         valid_lft forever preferred_lft forever
      inet 192.168.1.175/24 brd 192.168.1.255 scope global secondary dynamic noprefixroute eth0
         valid_lft 65588sec preferred_lft 65588sec
      inet 192.168.1.201/24 scope global secondary eth0
         valid_lft forever preferred_lft forever
      inet 192.168.1.202/24 scope global secondary eth0
         valid_lft forever preferred_lft forever
  ```

## Bootstrapping the infra cluster

1. Install a minimally configured ArgoCD:

    ```
    kubectl apply -k apps/argocd/overlays/bootstrap
    ```

2. Install cluster secrets.

    We use the [external-secrets](https://external-secrets.io/) operator to manage cluster secrets. Since we're storing secrets in AWS SecretsManger, we need to provide appropriate credentials to allow the operator to fetch secrets. These secrets are for obvious reasons not included in the repository. I have a local repository that creates the secret `aws-secrets-reader` in the `cluster-secrets` namespace.

3. Install the `root` application:

    ```
    kubectl apply -k apps/root/overlays/infra
    ```

    The `root` application deploys itself and the `cluster-apps` and `cluster-projects` ApplicationSets (which will in turn take care of deploying the per-cluster configurations contained in the `clusters/` directory).

There is a script `scripts/bootstrap.sh` that performs all of the above tasks.
