# The Gamote Library for Kubernetes

Applications and libraries, provided by [Gamote](https://github.com/Gamote), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add gamote https://gamote.github.io/charts
$ helm repo update
$ helm search repo gamote
$ helm install my-release gamote/<chart>
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
