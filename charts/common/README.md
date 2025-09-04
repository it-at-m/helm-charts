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
  name: {{ include "common.fullname" . }}
data:
  myvalue: "Hello World"
```

## Introduction

This chart provides a common template helpers which can be used to develop new charts using [Helm](https://helm.sh) package manager.

## Parameters

The following table lists the helpers available in the library which are scoped in different sections.

### Helpers

| Helper identifier                  | Description                                                           | Expected Input                                                                                |
| ---------------------------------- | --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `common.name`                | Expand the name of the chart or use `.Values.nameOverride`            | `.` Chart context                                                                             |
| `common.fullname`            | Create a default fully qualified app name.                            | `.` Chart context                                                                             |
| `common.chart`               | Chart name plus version                                               | `.` Chart context                                                                             |
| `common.labels`    | Return Kubernetes standard labels                                           | `.` Chart context |
| `common.selectorLabels` | Labels to use on `deploy.spec.selector.matchLabels` and `svc.spec.selector` | `.` Chart context |
| `common.serviceAccountName` | name of the service account to use | `.` Chart context |

### Ingress / Route

| Helper identifier                         | Description                                                                                                       | Expected Input                                                                                                                                                                   |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `common.route`                  | Creates a OpenShift Route resource if enabled in values.                                              | `.` Chart context |