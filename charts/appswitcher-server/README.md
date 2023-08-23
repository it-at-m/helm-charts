# appswitcher-server

## Introduction

This chart bootstraps a [appswitcher-server](https://github.com/it-at-m/appswitcher-server) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm install my-appswitcher-release it-at-m/appswitcher-server --values values.yaml
```

The command deploys appswitcher-server on the Kubernetes cluster with some default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during via `values.yaml`.

## Configuration

| Key                                     | Type   | Default                      | Description                                                                                                                                                                                 |
| --------------------------------------- | ------ | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| activeSpringProfiles                    | string | `""`                         | List of active spring profiles (include `keycloak` to activate Keycloak integration)                                                                                                        |
| applications                            | object | `{}`                         | Map of your [custom applications](https://github.com/it-at-m/appswitcher-server#custom-applications). See [`values.yaml`](charts/appswitcher-server/values.yaml) for an example.            |
| keycloak.issuerUri                      | string | `""`                         | Issuer uri (e.g. `https://keycloak.mycompany.org/auth/realms/myrealm`)                                                                                                                      |
| keycloak.jwkSetUri                      | string | `""`                         | JWK set uri (e.g. `https://keycloak.mycompany.org/auth/realms/myrealm/protocol/openid-connect/certs`)                                                                                       |
| keycloak.scopes                         | string | `"openid,roles"`             | Comma-seperated list of requested scopes (e.g. `openid,roles`).                                                                                                                             |
| keycloak.ssoSessionMax                  | string | `"36000"`                    | Maximum time in seconds before your Keycloak expires the sso sessions (e.g. '36000' for 10 hours).                                                                                          |
| credentials.existingSecret              | string | `""`                         | secret containing keys (CLIENT_ID, CLIENT_SECRET) for Keycloak integration. If specified, this Secret will be used and no Secret will be generated.                                         |
| credentials.clientId                    | string | `""`                         | Client ID for Keycloak integration                                                                                                                                                          |
| credentials.clientSecret                | string | `""`                         | Client Secret for Keycloak integration                                                                                                                                                      |
| existingConfigMap                       | string | `""`                         | config map with key `application.yml` containing a Spring Boot application.yml. If specified, this ConfigMap will be used for Spring Boot configuration and no ConfigMap will be generated. |
| image.imagePullSecrets                  | list   | `[]`                         | Image pull secrets specification                                                                                                                                                            |
| replicaCount                            | int    | `1`                          | Replica count                                                                                                                                                                               |
| resources                               | object | `{}`                         | Pod resource definition                                                                                                                                                                     |
| image.pullPolicy                        | string | `"IfNotPresent"`             | Image pull policy                                                                                                                                                                           |
| image.repository                        | string | `"itatm/appswitcher-server"` | Image to use for deploying                                                                                                                                                                  |
| image.tag                               | string | `""`                         | Image tag. If not specified defaults to `appVersion` of the chart.                                                                                                                          |
| ingress.annotations                     | object | `{}`                         |                                                                                                                                                                                             |
| ingress.className                       | string | `""`                         |                                                                                                                                                                                             |
| ingress.enabled                         | bool   | `false`                      | Enable ingress                                                                                                                                                                              |
| ingress.hosts                           | list   | `[]`                         |                                                                                                                                                                                             |
| ingress.tls                             | list   | `[]`                         |                                                                                                                                                                                             |
| nameOverride                            | string | `""`                         | Override chart name                                                                                                                                                                         |
| podSecurityContext                      | object | `""`                         | Security Context                                                                                                                                                                            |
| service.annotations                     | object | `{}`                         | Service annotations                                                                                                                                                                         |
| service.port                            | int    | `8080`                       | Service port                                                                                                                                                                                |
| service.type                            | string | `"ClusterIP"`                | Service type                                                                                                                                                                                |
| serviceAccount.annotations              | object | `{}`                         | Service account annotations                                                                                                                                                                 |
| serviceAccount.create                   | bool   | `false`                      | Create service account                                                                                                                                                                      |
| serviceAccount.name                     | string | `""`                         | Service account name                                                                                                                                                                        |
| extraEnvVars                            | list   | `[]`                         | Extra environment variables                                                                                                                                                                 |
| extraVolumes                            | list   | `[]`                         | Extra volumes                                                                                                                                                                               |
| extraVolumeMounts                       | list   | `[]`                         | Extra volumeMounts for the pods                                                                                                                                                             |
| initContainers                          | list   | `[]`                                                  | Extra initContainers for the pods                                                                                                        |
| route.enabled                           | bool   | `false`                      | Create OpenShift route                                                                                                                                                                      |
| route.annotations                       | object | `{}`                         | Route annotations                                                                                                                                                                           |
| route.host                              | string | `""`                         | Route host                                                                                                                                                                                  |
| route.path                              | string | `""`                         | Route path                                                                                                                                                                                  |
| route.wildcardPolicy                    | string | `"None"`                     | Route wildcard policy                                                                                                                                                                       |
| route.tls.termination                   | string | `"Edge"`                     | Route tls termination                                                                                                                                                                       |
| route.tls.insecureEdgeTerminationPolicy | string | `"Redirect"`                 | Route tls insecureEdgeTerminationPolicy                                                                                                                                                     |
| route.tls.key                           | string | `""`                         | Route tls key                                                                                                                                                                               |
| route.tls.certificate                   | string | `""`                         | Route tls certificate                                                                                                                                                                       |
| route.tls.caCertificate                 | string | `""`                         | Route tls ca certificate                                                                                                                                                                    |
| route.tls.destinationCACertificate      | string | `""`                         | Route tls destination ca certificate                                                                                                                                                        |

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/it-at-m/appswitcher-server-helm-chart.svg?style=for-the-badge
[contributors-url]: https://github.com/it-at-m/appswitcher-server-helm-chart/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/it-at-m/appswitcher-server-helm-chart.svg?style=for-the-badge
[forks-url]: https://github.com/it-at-m/appswitcher-server-helm-chart/network/members
[stars-shield]: https://img.shields.io/github/stars/it-at-m/appswitcher-server-helm-chart.svg?style=for-the-badge
[stars-url]: https://github.com/it-at-m/appswitcher-server-helm-chart/stargazers
[issues-shield]: https://img.shields.io/github/issues/it-at-m/appswitcher-server-helm-chart.svg?style=for-the-badge
[issues-url]: https://github.com/it-at-m/appswitcher-server-helm-chart/issues
[license-shield]: https://img.shields.io/github/license/it-at-m/appswitcher-server-helm-chart.svg?style=for-the-badge
[license-url]: https://github.com/it-at-m/appswitcher-server-helm-chart/blob/main/LICENSE
