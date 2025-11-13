# erzwingungshaft

## Introduction

This chart bootstraps an [erzwingungshaft](https://github.com/it-at-m/erzwingungshaft) cronjob deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm upgrade --install -f values.yaml erzwingungshaft charts/erzwingungshaft
```

The command deploys cronjob and additional configMap to start erzwingungshaft on kubernetes cluster. The [Configuration](#configuration) section lists the parameters that can be configured during installation. Use values.yaml configMaps.ehaft to configure erzwingungshaft application.yaml.

## Configuration

| Key                                        | Type   | Default          | Description                                                                                                                                                                                                                                                |
| ------------------------------------------ | ------ | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| modules.ehaft.cronjob.schedule                           | string | - | Valid crontab expression to start kubernetes cronjob                                                                                                                                                                                                                                 |
| modules.ehaft.image                                  | object | -             | Image configuration (registry, repository, tag, pullPolicy)                                                                                                                                                                                                                              |
| modules.ehaft.data                                  | object | -             | application.yaml configuration. See <https://github.com/it-at-m/Erzwingungshaft/blob/main/erzwingungshaft-eai/src/main/resources/application.yml> + <https://github.com/it-at-m/Erzwingungshaft/blob/main/erzwingungshaft-eai/src/test/resources/application-test.yml>                                                                                                                                                                                                                                                 |
