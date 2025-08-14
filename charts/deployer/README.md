# Deployer

`TODO: Description`

## TL;DR

```bash
$ helm repo add dotcom https://dotcom-dev.github.io/charts
$ helm install my-release dotcom/deployer
```

## Introduction

`TODO: Introduction`

## Prerequisites

`TODO: Prerequisites`

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add dotcom https://dotcom-dev.github.io/charts
$ helm install my-release dotcom/deployer
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Service Parameters

| Name                      | Description                                                 | Default     |
|---------------------------|-------------------------------------------------------------|-------------|
| `service.enabled`         | Enable service resource creation                            | `true`      |
| `service.type`            | Service type                                                | `ClusterIP` |
| `service.port`            | Service port                                                | `80`        |
| `headlessService.enabled` | Enable headless service creation                            | `false`     |
| `headlessService.port`    | Headless service port (defaults to service.port if not set) | `80`        |

### Cloud Context Parameters

| Name                       | Description                                             | Default |
|----------------------------|---------------------------------------------------------|---------|
| `cloudContext.enabled`     | Enable GoWish Cloud Context environment variables       | `true`  |
| `cloudContext.provider`    | Cloud provider (e.g., "gcp", "aws", "azure")            | `"gcp"` |
| `cloudContext.region`      | Cloud region (e.g., "europe-west1")                     | `""`    |
| `cloudContext.regionGroup` | Manual region group override (e.g., "eu", "us", "asia") | `""`    |
| `cloudContext.zone`        | Availability zone (e.g., "europe-west1-a")              | `""`    |
| `cloudContext.clusterName` | Kubernetes cluster name                                 | `""`    |

The Cloud Context feature automatically injects GoWish Cloud Context environment variables (`GWCC_*`) into your pods when enabled. This provides consistent access to cloud and infrastructure metadata.

**Environment Variables Injected:**
- `GWCC_PROVIDER` - Always injected with the configured provider value
- `GWCC_REGION` - Only injected if `cloudContext.region` is provided
- `GWCC_REGION_GROUP` - Only injected if `cloudContext.regionGroup` is provided
- `GWCC_ZONE` - Only injected if `cloudContext.zone` is provided  
- `GWCC_CLUSTER_NAME` - Only injected if `cloudContext.clusterName` is provided
- `GWCC_NAMESPACE` - Always injected via Kubernetes Downward API (pod's namespace)
- `GWCC_POD_NAME` - Always injected via Kubernetes Downward API (pod's name)

**Example: Enable Cloud Context**

```yaml
cloudContext:
  enabled: true
  provider: "gcp"
  region: "europe-west1"
  regionGroup: "eu"
  zone: "europe-west1-a"
  clusterName: "my-cluster"
```

**TypeScript Applications:** For TypeScript applications, you can use the [`@dotcom-dev/gowish-cloud-context`](https://github.com/dotcom-dev/gowish-cloud-context) library to automatically parse these injected environment variables and provide a typed interface.

### Pod Disruption Budget Parameters

| Name                                 | Description                                                        | Default |
|--------------------------------------|--------------------------------------------------------------------|---------|
| `podDisruptionBudget.enabled`        | Enable PodDisruptionBudget resource creation                       | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number of pods that must be available during a disruption  | `nil`   |
| `podDisruptionBudget.maxUnavailable` | Maximum number of pods that can be unavailable during a disruption | `nil`   |
