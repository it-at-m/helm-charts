# ezLDAP

## Introduction

This chart bootstraps an [ezLDAP](https://github.com/it-at-m/ezLDAP) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm install my-ezldap-release it-at-m/ezldap --values values.yaml
```

The command deploys ezLDAP on the Kubernetes cluster with some default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

## Configuration

| Key                        | Type   | Default          | Description                                                                                          |
| -------------------------- | ------ | ---------------- | ---------------------------------------------------------------------------------------------------- |
| image.imagePullSecrets     | list   | `[]`             | Image pull secrets specification                                                                     |
| image.pullPolicy           | string | `"IfNotPresent"` | Image pull policy                                                                                    |
| image.repository           | string | `"itatm/ezldap"` | Image to use for deploying                                                                           |
| image.tag                  | string | `""`             | Image tag                                                                                            |
| ingress.annotations        | object | `{}`             |                                                                                                      |
| ingress.className          | string | `""`             |                                                                                                      |
| ingress.enabled            | bool   | `false`          | Enable ingress                                                                                       |
| ingress.hosts              | list   | `[]`             |                                                                                                      |
| ingress.tls                | list   | `[]`             |                                                                                                      |
| nameOverride               | string | `""`             | Override chart name                                                                                  |
| podSecurityContext         | object | `{}`             | Security Context                                                                                     |
| service.annotations        | object | `{}`             | Service annotations                                                                                  |
| service.port               | int    | `8080`           | Service pot                                                                                          |
| service.type               | string | `"ClusterIP"`    | Service type                                                                                         |
| serviceAccount.annotations | object | `{}`             | Service account annotations                                                                          |
| serviceAccount.create      | bool   | `true`           | Create service account                                                                               |
| serviceAccount.name        | string | `""`             | Service account name                                                                                 |
| credentials.existingSecret | string | `""`             | set a secret name here if you want to manage secrets on your own. required keys: [USER_DN, PASSWORD] |
| credentials.userDn         | string | `""`             | Bind User-DN for LDAP authentication                                                                 |
| credentials.password       | string | `""`             | Password for LDAP authentication                                                                     |
| extraEnvVars               | list   | `[]`             | Extra environment variables                                                                          |
| extraVolumes               | list   | `[]`             | Extra volumes                                                                                        |
| extraVolumeMounts          | list   | `[]`             | Extra volumeMounts for the pods                                                                      |
| initContainers             | list   | `[]`             | Extra initContainers for the pods                                                                    |
| routes                     | object | `{}`             | OpenShift Route definitions (see default `values.yaml` for examples)                                 |

## Changelog

### 2.0.0

#### Route definition

**Breaking change**: `eaiRoute` was replaced by `routes` (object). Example:

```yaml
routes:
  main:
    host: example.com
    to:
      kind: Service
      name: my-svc
```
