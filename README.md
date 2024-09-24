# The DotCom Library for Kubernetes

Applications and libraries, ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add dotcom https://dotcom-dev.github.io/charts
$ helm repo update
$ helm search repo dotcom
$ helm install my-release dotcom/<chart>
```

## Notes

### Commands

```shell
helm lint charts/deployer
helm package charts/deployer 
```

### References

Guides followed to create this repository:
- [Host your Helm Chart Repo on GitHub](https://tealfeed.com/host-helm-chart-repo-github-n1nly)

Check this template for more information: [helm-template](https://github.com/bitnami/charts/tree/main/template)
