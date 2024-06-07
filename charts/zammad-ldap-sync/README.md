# zammad-ldap-sync

## Introduction

This chart bootstraps an [zammad-ldap-sync](https://github.com/it-at-m/zammad-ldap-sync) cronjob deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm upgrade --install -f values.yaml zammad-ldap-sync charts/zammad-ldap-sync
```

The command deploys cronjob and additional configMap to start zammad-ldap-sync on kubernetes cluster. The [Configuration](#configuration) section lists the parameters that can be configured during installation. Use values.yaml ldapSync.configMap.yaml to configure zammad-ldap-sync application.yaml.
A valid secret containing zammad token is not created and must be present.

## Configuration

| Key                                        | Type   | Default          | Description                                                                                                                                                                                                                                                |
| ------------------------------------------ | ------ | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ldapSync.cronjob.schedule                           | string | - | Valid crontab expression to start kubernetes cronjob                                                                                                                                                                                                                                 |
| ldapSync.cronjob.secrets                   | Kubernetes secret   | -             | Kubernetes secret with key ZAMMAD_TOKEN                                                                                                                                                                                                                           |
| ldapSync.configMap.name                    | Kubernetes configMap | - | Kubernetes configMap containing https://github.com/it-at-m/zammad-ldap-sync/blob/dev/src/main/resources/application.yaml.                                                                                                                                                                                                                                         |
| ldapSync.configMap.yaml                                  | string | -             | application.yaml containing https://github.com/it-at-m/zammad-ldap-sync/blob/dev/src/main/resources/application.yaml.                                                                                                                                                                                                                                                 |

