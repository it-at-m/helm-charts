# mucgpt

Helm chart for deploying [MUCGPT](https://github.com/it-at-m/mucgpt), a chatbot application for workers at public administrations. It deploys the MUCGPT frontend, core service, assistant service, a database migration job, the [refarch-gateway](https://github.com/it-at-m/helm-charts/tree/main/charts/refarch-gateway) as entry point and an optional Valkey cache.

## Introduction

This chart is an umbrella chart built on top of [refarch-templates](https://github.com/it-at-m/helm-charts/tree/main/charts/refarch-templates). See that chart's README for all module-level options (resources, autoscaling, probes, ingress, ...).

Deployed components:

| Component                    | Image                                                | Description                                  |
| ---------------------------- | --------------------------------------------         | -------------------------------------------- |
| frontend                     | `ghcr.io/it-at-m/mucgpt/mucgpt-frontend`             | React web UI                                 |
| core                         | `ghcr.io/it-at-m/mucgpt/mucgpt-core`                 | LLM orchestration backend                    |
| assistants                   | `ghcr.io/it-at-m/mucgpt/mucgpt-assistant`            | Assistant configuration backend              |
| assistants-migrations (Job)  | `ghcr.io/it-at-m/mucgpt/mucgpt-assistant-migrations` | Database schema migrations (Helm hook)       |
| refarch-gateway              | –                                                    | API gateway, single entry point              |
| valkey (optional)            | Cloud Pirates valkey chart                           | Cache for core and assistant services        |

## Installing the Chart

Add the repositories and install:

```console
helm repo add it-at-m https://it-at-m.github.io/helm-charts
helm repo add cloudpirates https://cloudpirates-io.github.io/helm-charts
helm repo update
helm install my-release it-at-m/mucgpt -f my-values.yaml
```

Look at the [values-example.yaml](./values-example.yaml) for a complete, working example configuration.

## Requirements

### SSO

MUCGPT requires an OIDC identity provider (e.g. Keycloak). Deploy and operate Keycloak separately (e.g. using the [Cloud Pirates keycloak chart](https://github.com/CloudPirates-io/helm-charts)). Provide the connection details via a Secret named `sso` with the keys `URL`, `REALM`, `CLIENTID`, `CLIENTSECRET`, `SCOPE` and `ROLE` (see `refarch-templates.secrets`).

### Database

The assistant service needs a PostgreSQL database (schema migrations run automatically via the `assistants-migrations` job). **You are strongly encouraged to operate PostgreSQL via a database operator** such as [CloudNativePG](https://cloudnative-pg.io) instead of rolling the included `postgres` subchart yourself. Note that the subchart cannot be combined with the automatic migrations (the job runs as a `pre-install` hook, before the bundled PostgreSQL exists) - if you enable it, set `assistantsMigration.enabled=false` and run the migrations manually.

Provide the database host/name/user via the assistant `config.yaml` (`assistantConfig`) and the credentials via a Secret injected as environment variables (`MUCGPT_ASSISTANT_DB__PASSWORD`, see `assistantsMigration.envFrom` and the assistants module `envFrom` in [values-example.yaml](./values-example.yaml)).

### Cache

The core and assistant services use Valkey as cache. As with the database, consider using an external cache or the official [Valkey operator](https://github.com/valkey-io/valkey-operator) (**early development, not production-ready**) instead of the bundled `valkey` subchart. If you disable the subchart, point the services' `REDIS` settings in their `config.yaml` to your external cache and provide the cache password via the `MUCGPT_CORE_REDIS__PASSWORD` / `MUCGPT_ASSISTANT_REDIS__PASSWORD` environment variables.

### Document parser

The core service requires a document parsing backend (see [MUCGPT documentation](https://github.com/it-at-m/mucgpt)). Deploy it separately in your cluster and configure it in the core `config.yaml` (`PARSER_BACKEND`, `XBERG_URL`, ...).

## Configuration

The following table lists the main configurable parameters of the chart and their default values. Module-level parameters (`refarch-templates.modules.<name>.*`, `refarch-templates.refarch-gateway.*`) are documented in the [refarch-templates](https://github.com/it-at-m/helm-charts/tree/main/charts/refarch-templates) and [refarch-gateway](https://github.com/it-at-m/helm-charts/tree/main/charts/refarch-gateway) charts.

| Key                                         | Type    | Default                                                                                        | Description                                                                                                                                                                            |
| ------------------------------------------  | ------- | --------------                                                                                 | ---------------------------------------------------------------------------------------------------------------                                                                        |
| `coreConfig.data`                           | object  | `{}`                                                                                           | Core service `config.yaml` content, rendered into a ConfigMap. Ignored if `coreConfig.existingConfigmap` is set                                                                        |
| `coreConfig.existingConfigmap`              | string  | `nil`                                                                                          | Existing ConfigMap containing a `config.yaml` key for the core service                                                                                                                 |
| `assistantConfig.data`                      | object  | `{}`                                                                                           | Assistant service `config.yaml` content, rendered into a ConfigMap. Ignored if `assistantConfig.existingConfigmap` is set                                                              |
| `assistantConfig.existingConfigmap`         | string  | `nil`                                                                                          | Existing ConfigMap containing a `config.yaml` key for the assistant service                                                                                                            |
| `assistantsMigration.enabled`               | bool    | `true`                                                                                         | Enable the assistant database migrations Helm hook job                                                                                                                                 |
| `assistantsMigration.image`                 | object  | see values.yaml                                                                                | Migration job image                                                                                                                                                                    |
| `assistantsMigration.resources`             | object  | see values.yaml                                                                                | Resources for the migration job                                                                                                                                                        |
| `assistantsMigration.activeDeadlineSeconds` | int     | `600`                                                                                          | Time limit for the migration job                                                                                                                                                       |
| `assistantsMigration.useCAcerts`            | bool    | `false`                                                                                        | Mount the CA bundle (see `caCerts`) into the migration job                                                                                                                             |
| `assistantsMigration.envFrom`               | list    | `[]`                                                                                           | envFrom entries, e.g. a credentials Secret (see values-example.yaml)                                                                                                                   |
| `assistantsMigration.env`                   | list    | `[]`                                                                                           | Environment variables for the migration job                                                                                                                                            |
| `caCerts.enabled`                           | bool    | `false`                                                                                        | Mount a CA bundle into the migrations job (when `assistantsMigration.useCAcerts=true`) and set `SSL_CERT_FILE`; application containers need their own wiring (see values-example.yaml) |
| `caCerts.existingSecret`                    | string  | `nil`                                                                                          | Existing Secret holding the CA bundle                                                                                                                                                  |
| `caCerts.existingConfigmap`                 | string  | `nil`                                                                                          | Existing ConfigMap holding the CA bundle (alternative to `existingSecret`)                                                                                                             |
| `caCerts.key`                               | string  | `ca-bundle.crt`                                                                                | Key within the Secret/ConfigMap                                                                                                                                                        |
| `caCerts.mountPath`                         | string  | `/etc/pki/ca-trust/extracted/pem`                                                              | Mount path of the CA bundle volume                                                                                                                                                     |
| `refarch-templates`                         | object  | see values.yaml                                                                                | Configuration of the refarch-templates subchart (modules `frontend`, `core`, `assistants` and `refarch-gateway`)                                                                       |
| `valkey.enabled`                            | bool    | `true`                                                                                         | Deploy the bundled Valkey (see README section "Cache")                                                                                                                                 |
| `valkey.*`                                  | various | see [valkey chart](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/valkey)     | Valkey configuration                                                                                                                                                                   |
| `postgres.enabled`                          | bool    | `false`                                                                                        | Deploy the bundled PostgreSQL (discouraged, see README section "Database")                                                                                                             |
| `postgres.*`                                | various | see [postgres chart](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/postgres) | PostgreSQL configuration                                                                                                                                                               |

> **Note:** The ConfigMaps rendered from `coreConfig.data` / `assistantConfig.data` (named `<release>-core-config` / `<release>-assistant-config`) are **not mounted automatically**.
Add the matching `volumes` / `volumeMounts` entries to the `core` / `assistants` module configuration yourself (see [values-example.yaml](./values-example.yaml)) - the services read their configuration from `/app/config.yaml`.

> **Note:** Keep credentials (database passwords, API keys, ...) out of `config.yaml`.
MUCGPT resolves configuration with the priority environment variables > `config.yaml` (nested values use `__` as delimiter, e.g. `MUCGPT_ASSISTANT_DB__PASSWORD`).
Provide credentials via Secrets injected as environment variables through the modules' `envFrom` entries (see [values-example.yaml](./values-example.yaml)).

> **Note:** The bundled `postgres` subchart cannot be combined with the automatic migrations: the `assistants-migrations` job runs as a `pre-install` hook, before the in-chart PostgreSQL is created, and chart rendering fails if both are enabled. Use an external database (e.g. via CloudNativePG) or run the migrations manually.

## Changelog

### 0.1.0

Initial release.
