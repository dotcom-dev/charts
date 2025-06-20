# GKE Deployer

`TODO: Description`

## TL;DR

```bash
$ helm repo add dotcom https://dotcom-dev.github.io/charts
$ helm install my-release dotcom/gke-deployer
```

## Introduction

`TODO: Introduction`

## Prerequisites

`TODO: Prerequisites`

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add dotcom https://dotcom-dev.github.io/charts
$ helm install my-release dotcom/gke-deployer
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global Parameters


| Name                | Description                                  | Default         |
|---------------------|----------------------------------------------|-----------------|
| `nameOverride`      | Override the name of the chart               | `""`            |
| `fullNameOverride`  | Override the full name of the resources      | `""`            |


### Service Parameters


| Name                  | Description             | Default     |
|-----------------------|-------------------------|-------------|
| `service.enabled`     | Enable Service creation | `true`      |
| `service.type`        | Service type            | `ClusterIP` |
| `service.port`        | Service port            | `3000`      |
| `service.annotations` | Service annotations     | `{}`        |


### HTTPRoute Parameters (Gateway API)

| Name                         | Description                  | Default           |
|------------------------------|------------------------------|-------------------|
| `httpRoute.enabled`          | Enable HTTPRoute creation    | `false`           |
| `httpRoute.namespace`        | HTTPRoute namespace          | Release namespace |
| `httpRoute.gatewayName`      | Referenced gateway name      | `""`              |
| `httpRoute.gatewayNamespace` | Referenced gateway namespace | `""`              |
| `httpRoute.hostname`         | Route hostname               | `""`              |


### Multi-Cluster Service Parameters


| Name                        | Description                                     | Default            |
|-----------------------------|-------------------------------------------------|--------------------|
| `serviceExport.enabled`     | Enable ServiceExport for multi-cluster services | `false`            |
| `serviceExport.namespace`   | ServiceExport namespace                         | nameOverride value |
| `serviceExport.annotations` | ServiceExport annotations                       | `{}`               |


### Infisical Secret CRD Parameters


| Name                                                                       | Description                                                                                                                             | Default           |
|----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| `infisicalSecretCRD.enabled`                                               | Enable Infisical Secret CRD creation                                                                                                    | `false`           |
| `infisicalSecretCRD.namespace`                                             | Infisical Secret CRD namespace                                                                                                          | Release namespace |
| `infisicalSecretCRD.resyncInterval`                                        | Secret resync interval in seconds - we only recommend going to very low values for debugging the auth flow of your infisical secret CRD | `60`              |
| `infisicalSecretCRD.authentication.universalAuth.credentialsRef`           | Credentials reference                                                                                                                   | `{}`              |
| `infisicalSecretCRD.managedKubeSecretReferences`                           | Managed Kubernetes secret references                                                                                                    | `[]`              |
| `infisicalSecretCRD.universalAuth.credentialsRef.secretsScope.envSlug`     | slug of the environment within your infisical project                                                                                   | `"dev"`           |
| `infisicalSecretCRD.universalAuth.credentialsRef.secretsScope.projectSlug` | slug of your infisical project. You can get it from the "project Settings" tab in the infisical web UI                                  | `"dev"`           |



#### How the InfisicalSecret CRD works

The following components are at play:
- the CRD resource itself (provisioned by this Helm chart) 
- a k8s `secret` containing the `clientID` and `clientSecret` of an infisical [machine identity](https://infisical.com/docs/documentation/platform/identities/machine-identities) which has access to your team's infisical projects. This should be referenced here but provisioned by making a PR [here](https://github.com/dotcom-dev/gowish-infrastructure/blob/main/tf_new_setup/2-projects/gowish_devx/terraform.tfvars). (As of 06MAY25) Ask the cloud engineers how this is done.
- a `managedKubeSecretReferences`: this is where your infisical secrets will actually be stored.
By default, all of these things should be in the same namespace as your app.


### Pod Disruption Budget Parameters

| Name                                 | Description                                                        | Default |
|--------------------------------------|--------------------------------------------------------------------|---------|
| `podDisruptionBudget.enabled`        | Enable PodDisruptionBudget resource creation                       | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number of pods that must be available during a disruption  | `nil`   |
| `podDisruptionBudget.maxUnavailable` | Maximum number of pods that can be unavailable during a disruption | `nil`   |

### Google Managed Prometheus (GMP) Monitoring Parameters

| Name           | Description                                              | Default    |
|----------------|----------------------------------------------------------|------------|
| `gmp.enabled`  | Enable PodMonitoring resource creation for GMP           | `false`    |
| `gmp.path`     | Path to scrape metrics from                              | `/metrics` |
| `gmp.interval` | Scraping interval                                        | `30s`      |
