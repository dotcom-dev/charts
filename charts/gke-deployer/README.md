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


| Name                      | Description                                                 | Default     |
|---------------------------|-------------------------------------------------------------|-------------|
| `service.enabled`         | Enable Service creation                                     | `true`      |
| `service.type`            | Service type                                                | `ClusterIP` |
| `service.port`            | Service port                                                | `3000`      |
| `service.annotations`     | Service annotations                                         | `{}`        |
| `headlessService.enabled` | Enable headless service creation                            | `false`     |
| `headlessService.port`    | Headless service port (defaults to service.port if not set) | `3000`      |


### Health Check Policy Parameters (GKE)

| Name                                            | Description                                                | Default   |
|-------------------------------------------------|------------------------------------------------------------|-----------|
| `healthCheckPolicy.enabled`                     | Enable HealthCheckPolicy creation                          | `false`   |
| `healthCheckPolicy.httpHealthCheck.requestPath` | Path to check for HTTP health checks                       | `/health` |
| `healthCheckPolicy.checkIntervalSec`            | Interval between health checks in seconds                  | `10`      |
| `healthCheckPolicy.timeoutSec`                  | Timeout for each health check in seconds                   | `5`       |
| `healthCheckPolicy.healthyThreshold`            | Number of consecutive successful checks to mark as healthy | `1`       |
| `healthCheckPolicy.unhealthyThreshold`          | Number of consecutive failed checks to mark as unhealthy   | `10`      |

The Health Check Policy feature creates a GKE HealthCheckPolicy resource that configures HTTP load balancer health checks for your service. This is particularly useful for ensuring proper traffic routing and service availability in GKE environments.

**Important**: The health check policy automatically targets the appropriate resource type:
- When `serviceExport.enabled` is `false` (default): Targets the regular Kubernetes `Service`
- When `serviceExport.enabled` is `true`: Targets the `ServiceImport` resource for multi-cluster scenarios

**Port Configuration**: The health check automatically uses the service's named port (defaults to "http"). No explicit port configuration is needed as it uses `USE_NAMED_PORT` specification to reference the port defined in your service.

**Example: Enable basic HTTP health check**

```yaml
healthCheckPolicy:
  enabled: true
  httpHealthCheck:
    requestPath: "/api/health"
```

**Example: Custom health check configuration**

```yaml
healthCheckPolicy:
  enabled: true
  httpHealthCheck:
    requestPath: "/healthz"
  checkIntervalSec: 15
  timeoutSec: 3
  healthyThreshold: 2
  unhealthyThreshold: 5
```

### HTTPRoute Parameters (Gateway API)

| Name                                    | Description                           | Default |
|-----------------------------------------|---------------------------------------|---------|
| `httpRoute.enabled`                     | Enable HTTPRoute creation             | `false` |
| `httpRoute.gatewayName`                 | Referenced gateway name               | `""`    |
| `httpRoute.gatewayNamespace`            | Referenced gateway namespace          | `""`    |
| `httpRoute.hostname`                    | Route hostname                        | `""`    |
| `httpRoute.defaultWeight`               | Weight for default service            | `100`   |
| `httpRoute.additionalBackends`          | List of additional backends           | `[]`    |
| `httpRoute.additionalBackends[].name`   | Backend service name                  | `""`    |
| `httpRoute.additionalBackends[].weight` | Backend weight                        | `0`     |


### Multi-Cluster Service Parameters

| Name                        | Description                                     | Default |
|-----------------------------|-------------------------------------------------|---------|
| `serviceExport.enabled`     | Enable ServiceExport for multi-cluster services | `false` |
| `serviceExport.annotations` | ServiceExport annotations                       | `{}`    |


### Regional Services Parameters

| Name                                           | Description               | Default     |
|------------------------------------------------|---------------------------|-------------|
| `regionalServices`                             | List of regional services | `[]`        |
| `regionalServices[].name`                      | Service name              | `""`        |
| `regionalServices[].type`                      | Service type              | `ClusterIP` |
| `regionalServices[].serviceExport.enabled`     | Enable ServiceExport      | `false`     |
| `regionalServices[].serviceExport.annotations` | ServiceExport annotations | `{}`        |

#### Regional Services and Weighted Traffic Distribution

The regional services feature allows you to create region-specific services with service exports and distribute traffic using weighted HTTPRoute backends. This is particularly useful for gradual traffic migration between regions.

**Example: EU-first deployment with gradual US rollout**

```yaml
# Phase 1: EU only traffic
serviceExport:
  enabled: true

httpRoute:
  enabled: true
  gatewayName: "my-gateway"
  gatewayNamespace: "gateway-system"
  hostname: "myapp.example.com"
  defaultWeight: 0  # No traffic to default service
  additionalBackends:
    - name: eu-service
      weight: 100  # All traffic to EU
    - name: us-service
      weight: 0    # No traffic to US

regionalServices:
  - name: eu-service
    region: eu
    serviceExport:
      enabled: true
  - name: us-service
    region: us
    serviceExport:
      enabled: true
```

**Example: Gradual traffic migration (70% EU, 30% US)**

```yaml
httpRoute:
  defaultWeight: 0
  additionalBackends:
    - name: eu-service
      weight: 70
    - name: us-service
      weight: 30
```

**Example: Cleanup - back to default service**

```yaml
httpRoute:
  defaultWeight: 100
  additionalBackends: []

regionalServices: []  # Remove regional services
```


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
| `gmp.port`     | Port to scrape metrics from (can be a name or a number)  | `http`     |

### Jobs Parameters

| Name                | Description                                | Default    |
|---------------------|--------------------------------------------|------------|
| `jobs.enabled`      | Enable Jobs creation                       | `false`    |
| `jobs.apiVersion`   | API version for jobs                       | `batch/v1` |
| `jobs.list`         | List of one-time job configurations        | `[]`       |

### CronJobs Parameters

| Name                  | Description                          | Default    |
|-----------------------|--------------------------------------|------------|
| `cronJobs.enabled`    | Enable CronJobs creation             | `false`    |
| `cronJobs.apiVersion` | API version for cronJobs             | `batch/v1` |
| `cronJobs.list`       | List of scheduled job configurations | `[]`       |

#### Job Configuration

The chart now provides completely separate configurations for different types of jobs:
- `jobs` for one-time jobs (Kubernetes Jobs)
- `cronJobs` for scheduled jobs (Kubernetes CronJobs)

This separation makes the configuration cleaner and more intuitive, with each job type having its own dedicated template file.

##### One-time Job Configuration Fields

| Field                   | Description                                     | Required |
|-------------------------|-------------------------------------------------|----------|
| `name`                  | Name of the job                                 | Yes      |
| `apiVersion`            | API version (overrides default)                 | No       |
| `containers`            | List of container specifications                | Yes      |
| `restartPolicy`         | Restart policy for the pod                      | No       |
| `activeDeadlineSeconds` | Active deadline in seconds                      | No       |
| `metadata`              | Additional metadata (labels, annotations, etc.) | No       |
| `additionalSpec`        | Additional pod spec fields                      | No       |
| `additionalJobSpec`     | Additional job spec fields                      | No       |

##### CronJob Configuration Fields

| Field                   | Description                                     | Required |
|-------------------------|-------------------------------------------------|----------|
| `name`                  | Name of the job                                 | Yes      |
| `apiVersion`            | API version (overrides default)                 | No       |
| `schedule`              | Cron schedule expression                        | Yes      |
| `concurrencyPolicy`     | Concurrency policy for CronJob                  | No       |
| `containers`            | List of container specifications                | Yes      |
| `restartPolicy`         | Restart policy for the pod                      | No       |
| `activeDeadlineSeconds` | Active deadline in seconds                      | No       |
| `metadata`              | Additional metadata (labels, annotations, etc.) | No       |
| `additionalSpec`        | Additional pod spec fields                      | No       |
| `additionalJobSpec`     | Additional job spec fields                      | No       |

Example of a one-time Job configuration:

```yaml
jobs:
  enabled: true
  list:
    - name: one-time-job
      containers:
        - name: task
          image: alpine:latest
          command: ["echo", "One-time job"]
      restartPolicy: Never
```

Example of a CronJob configuration:

```yaml
cronJobs:
  enabled: true
  list:
    - name: refresh-cache
      schedule: '0 */2 * * *'
      containers:
        - name: refresh
          image: alpine/curl:3.14
          args:
            - '-X'
            - 'POST'
            - 'api-service:80/refresh-cache'
      restartPolicy: OnFailure
```

Example with additional fields:

```yaml
cronJobs:
  enabled: true
  list:
    - name: complex-job
      schedule: '0 0 * * *'
      metadata:
        labels:
          app: my-app
      concurrencyPolicy: Forbid
      containers:
        - name: task
          image: alpine:latest
          command: ["echo", "Complex job"]
      restartPolicy: OnFailure
      additionalJobSpec:
        successfulJobsHistoryLimit: 3
```
