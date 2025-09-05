# it@M Common Library Chart

A [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm) for grouping common logic between it@M charts.

## TL;DR

```yaml
dependencies:
  - name: common
    version: 1.x.x
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

This chart provides a common template helpers which can be used to develop new charts using [Helm](https://helm.sh) package manager.

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

### Ingress / Route

| Helper identifier | Description                         | Expected Input                                                         |
| ----------------- | ----------------------------------- | ---------------------------------------------------------------------- |
| `common.ingress`  | Creates a Ingress resource.         | `dict "ingress" .Values.ingress "service" .Values.service "context" $` |
| `common.route`    | Creates a OpenShift Route resource. | `dict "route" .Values.route "service" .Values.service "context" $`     |

### Image

| Helper identifier | Description                    | Expected Input                               |
| ----------------- | ------------------------------ | -------------------------------------------- |
| `common.image`    | Creates a Docker image string. | `dict "image" .Values.image "chart" $.Chart` |

### ServiceAccount

| Helper identifier       | Description                                              | Expected Input    |
| ----------------------- | -------------------------------------------------------- | ----------------- |
| `common.serviceAccount` | Create a ServiceAccount if serviceAccount.create is true | `.` Chart context |
