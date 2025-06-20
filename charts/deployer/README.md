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

### Pod Disruption Budget Parameters

| Name                                 | Description                                                        | Default |
|--------------------------------------|--------------------------------------------------------------------|---------|
| `podDisruptionBudget.enabled`        | Enable PodDisruptionBudget resource creation                       | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number of pods that must be available during a disruption  | `nil`   |
| `podDisruptionBudget.maxUnavailable` | Maximum number of pods that can be unavailable during a disruption | `nil`   |
