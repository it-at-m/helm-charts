# kf-app-eai

## Introduction

This chart bootstraps a [kf-app-eai](https://github.com/it-at-m/kf-app-eai) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm install my-kf-app-eai-release it-at-m/kf-app-eai --values values.yaml
```

The command deploys kf-app-eai on the Kubernetes cluster with some default configuration. The default parameters can be found in the default [values.yaml](https://github.com/it-at-m/helm-charts/blob/main/charts/kf-app-eai/values.yaml).

To allow running this app without any further configuration the default spring profile is `no-security` allowing unauthenticated access to all API-endpoints. Make sure to set `activeSpringProfiles` and `kitafinderBaseUrl` when running in a non-dev environment.
