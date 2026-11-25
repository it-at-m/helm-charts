# it@M Common Library Chart

A [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm) for grouping common logic between it@M charts.

## TL;DR

```yaml
dependencies:
  - name: common
    version: "^1.0.0"
    repository: https://it-at-m.github.io/helm-charts
```

```console
helm dependency update
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: { { include "common.fullname" . } }
data:
  myvalue: "Hello World"
```

## Introduction

This chart provides common template helpers for developing new charts using the [Helm](https://helm.sh) package manager.

## Parameters

The following table lists the helpers available in the library which are scoped in different sections.

### Helpers

| Helper identifier           | Description                                                                 | Expected Input                                                                                        |
| --------------------------- | --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `common.name`               | Expand the name of the chart or use `.Values.nameOverride`                  | `.` Chart context                                                                                     |
| `common.fullname`           | Create a default fully qualified app name.                                  | `.` Chart context                                                                                     |
| `common.chart`              | Chart name plus version                                                     | `.` Chart context                                                                                     |
| `common.labels`             | Return Kubernetes standard labels                                           | `.` Chart context                                                                                     |
| `common.selectorLabels`     | Labels to use on `deploy.spec.selector.matchLabels` and `svc.spec.selector` | `.` Chart context                                                                                     |
| `common.serviceAccountName` | name of the service account to use                                          | `.` Chart context                                                                                     |
| `common.secretName`         | Generate secret name                                                        | `dict "existingSecret" .Values.path.to.the.existingSecret "defaultNameSuffix" "mySuffix" "context" $` |

### Service

| Helper identifier | Description        | Expected Input    |
| ----------------- | ------------------ | ----------------- |
| `common.service`  | Creates a Service. | `.` Chart context |

### HorizontalPodAutoscaler

| Helper identifier    | Description                                           | Expected Input                               |
| -------------------- | ----------------------------------------------------- | -------------------------------------------- |
| `common.autoscaling` | Creates a Kubernetes `HorizontalPodAutoscaler` (HPA). | `dict "root" . "config" .Values.autoscaling` |

The `common.autoscaling` helper creates an HPA targeting the `Deployment` named by `common.fullname`.
The HPA is only rendered when `config.enabled` is `true`.

The helper requires at least one CPU or memory target. For each resource, configure either a utilization target or an average-value target, but not both.
CPU and memory targets may be used together.

> **Note:** Utilization-based targets require CPU and/or memory resource
> requests on the containers of the target Deployment.

| Configuration key                   | Type    | Required                             | Default | Description                                                                                                         |
| ----------------------------------- | ------- | ------------------------------------ | ------- | ------------------------------------------------------------------------------------------------------------------- |
| `enabled`                           | Boolean | Yes                                  | —       | Whether to create the HPA.                                                                                          |
| `minReplicas`                       | Integer | No                                   | `1`     | Minimum number of replicas.                                                                                         |
| `maxReplicas`                       | Integer | Yes, when enabled                    | —       | Maximum number of replicas. Must be greater than or equal to `minReplicas`.                                         |
| `targetCPUUtilizationPercentage`    | Integer | One CPU or memory target is required | —       | Target average CPU utilization percentage. Mutually exclusive with `targetCPUAverageValue`.                         |
| `targetCPUAverageValue`             | String  | One CPU or memory target is required | —       | Target average CPU quantity, for example `"500m"`. Mutually exclusive with `targetCPUUtilizationPercentage`.        |
| `targetMemoryUtilizationPercentage` | Integer | One CPU or memory target is required | —       | Target average memory utilization percentage. Mutually exclusive with `targetMemoryAverageValue`.                   |
| `targetMemoryAverageValue`          | String  | One CPU or memory target is required | —       | Target average memory quantity, for example `"512Mi"`. Mutually exclusive with `targetMemoryUtilizationPercentage`. |
| `behavior`                          | Map     | No                                   | —       | Optional HPA scaling behavior configuration, passed through to `spec.behavior`.                                     |

Example using values:

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryAverageValue: 768Mi
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
    scaleUp:
      policies:
        - type: Pods
          value: 2
          periodSeconds: 60
```

Render the helper in a chart template:

```gotemplate
{{ include "common.autoscaling" (dict
  "root" .
  "config" .Values.autoscaling
) }}
```

The configuration may also be passed from another values path or constructed directly in a template:

```gotemplate
{{ include "common.autoscaling" (dict
  "root" .
  "config" .Values.worker.autoscaling
) }}
```

### ServiceMonitor

| Helper identifier       | Description                                                                             | Expected Input    |
| ----------------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `common.serviceMonitor` | Creates a Prometheus Operator `ServiceMonitor` when `serviceMonitor.enabled` is `true`. | `.` Chart context |

The `common.serviceMonitor` helper creates a `ServiceMonitor` named after `common.fullname`. 
It selects the Service using the labels returned by `common.selectorLabels`.

| Value                             | Type    | Required | Default                  | Description                             |
| --------------------------------- | ------- | -------- | ------------------------ | --------------------------------------- |
| `.Values.serviceMonitor.enabled`  | Boolean | Yes      | —                        | Whether to create the `ServiceMonitor`. |
| `.Values.serviceMonitor.interval` | String  | No       | `"15s"`                  | Prometheus scrape interval.             |
| `.Values.serviceMonitor.port`     | String  | No       | `"http"`                 | Name of the Service port to scrape.     |
| `.Values.serviceMonitor.scheme`   | String  | No       | `"http"`                 | HTTP scheme used for scraping.          |
| `.Values.serviceMonitor.path`     | String  | No       | `"/actuator/prometheus"` | Path of the metrics endpoint.           |

Example:

```yaml
serviceMonitor:
  enabled: true
  interval: 30s
  port: http
  scheme: http
  path: /actuator/prometheus
```

### Ingress / Route

| Helper identifier | Description                          | Expected Input                                                                                                  |
| ----------------- | ------------------------------------ | --------------------------------------------------------------------------------------------------------------- |
| `common.ingress`  | Creates an Ingress resource.         | `dict "ingress" .Values.ingress "service" .Values.service "context" $`                                          |
| `common.route`    | Creates an OpenShift Route resource. | `dict "route" $route "service" .Values.service "context" $` (typically called while iterating `.Values.routes`) |

### Image

| Helper identifier | Description                    | Expected Input                               |
| ----------------- | ------------------------------ | -------------------------------------------- |
| `common.image`    | Creates a Docker image string. | `dict "image" .Values.image "chart" $.Chart` |

### ServiceAccount

| Helper identifier       | Description                                              | Expected Input    |
| ----------------------- | -------------------------------------------------------- | ----------------- |
| `common.serviceAccount` | Create a ServiceAccount if serviceAccount.create is true | `.` Chart context |

## Changelog

All notable changes to this Helm chart library will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this Helm chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### 1.0.3

#### Added

- [#317](https://github.com/it-at-m/helm-charts/issues/317): add `HorizontalPodAutoscaler` template 

### 1.0.2

#### Added

- [#316](https://github.com/it-at-m/helm-charts/issues/316): add `ServiceMonitor` template

#### Fixed

- [!345](https://github.com/it-at-m/helm-charts/pull/345): fix common.route generates route name collisions if name must be truncated and the suffixes first 3 characters are identical (e.g. api-public / api-private). to avoid collisions in this case a 8 character long sha256 hash based on the original suffix is used as suffix in the route name.
