# pentaho-carte

## Introduction

This chart bootstraps a [pentaho-carte](https://github.com/it-at-m/pentaho-carte) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm install my-pentaho-carte-release it-at-m/pentaho-carte --values values.yaml
```

The command deploys pentaho-carte on the Kubernetes cluster with some default configuration. The [Configuration](#configuration) section lists the parameters that can or **must** be configured during installation.

## Configuration

| Key                                        | Type   | Default                 | Description                             |
| ------------------------------------------ | ------ | ----------------------- | --------------------------------------- |
| replicaCount                               | int    | `1`                     | Number of replicas                      |
| image.repository                           | string | `"itatm/pentaho-carte"` | Image to use for deploying              |
| image.pullPolicy                           | string | `"IfNotPresent"`        | Image pull policy                       |
| image.tag                                  | string | `""`                    | Image tag                               |
| image.imagePullSecrets                     | list   | `[]`                    | Image pull secrets specification        |
| nameOverride                               | string | `""`                    | Override chart name                     |
| fullNameOverride                           | string | `""`                    | Override fullname                       |
| serviceAccount.create                      | bool   | `false`                 | Create service account                  |
| serviceAccount.automount                   | bool   | `false`                 | Mount Service account                   |
| serviceAccount.annotations                 | object | `{}`                    | Service account annotations             |
| serviceAccount.name                        | string | `""`                    | Service account name                    |
| podAnnotations                             | object | `{}`                    | Pod annotations                         |
| podLabels                                  | object | `{}`                    | Pod Labels                              |
| podSecurityContext                         | object | `{}`                    | Pod Security Context                    |
| securityContext                            | object | `{}`                    | Security Context                        |
| service.type                               | string | `"ClusterIP"`           | Service type                            |
| service.port                               | int    | `8080`                  | Service port                            |
| service.targetP ort                        | int    | `8080`                  | Service target port                     |
| ingress.enabled                            | bool   | `true`                  | Enable ingress                          |
| ingress.className                          | string | `""`                    |                                         |
| ingress.annotations                        | object | `{}`                    |                                         |
| ingress.hosts                              | list   | `[]`                    |                                         |
| ingress.tls                                | list   | `[]`                    |                                         |
| route.enabled                              | bool   | `false`                 | Create OpenShift route                  |
| route.annotations                          | object | `{}`                    | Route annotations                       |
| route.host                                 | string | `""`                    | Route host                              |
| route.path                                 | string | `""`                    | Route path                              |
| route.wildcardPolicy                       | string | `"None"`                | Route wildcard policy                   |
| route.tls.termination                      | string | `"Edge"`                | Route tsl termination                   |
| route.tls.insecureEdgeTerminationPolicy    | string | `"Redirect"`            | Route tls insecureEdgeTerminationPolicy |
| route.tls.key                              | string | `""`                    | Route tls key                           |
| route.tls.certificate                      | string | `""`                    | Route tls certificate                   |
| route.tls.caCertificate                    | string | `""`                    | Route tls ca certificate                |
| route.tls.destinationCACertificate         | string | `""`                    | Route tls destination ca certificate    |
| resources                                  | object | `{}`                    | Pod resources                           |
| livenessProbe.httpGet.path                 | string | `/`                     | Path to use for liveness probe          |
| livenessProbe.httpGet.port                 | string | `http`                  | Port to use for liveness probe          |
| readinessProbe.httpGet.path                | string | `/`                     | Path to use for readiness probe         |
| readinessProbe.httpGet.port                | string | `http`                  | Path to use for readiness probe         |
| autoscaling.enabled                        | bool   | `false`                 | Enable autoscaling                      |
| autoscaling.minReplicas                    | int    | `1`                     | Minimal replicas                        |
| autoscaling.maxReplicas                    | int    | `100`                   | Maximal replicas                        |
| autoscaling.targetCPUUtilizationPercentage | bool   | `80`                    | CPU Utilization to use for autoscaling  |
| volumes                                    | list   | `[]`                    | Additional Volumes                      |
| volumeMounts                               | list   | `[]`                    | Additional volume mounts                |
| nodeSelector                               | object | `{}`                    | Kubernetes node selector                |
| tolerations                                | list   | `[]`                    | Kubernetes tolerations                  |
| affinity                                   | object | `{}`                    | Kubernetes node affinity                |
| initContainers                             | list   | `[]`                    | Extra initContainers for the pods       |
| extraEnvVars                               | list   | `[]`                    | Extra environment variables             |
