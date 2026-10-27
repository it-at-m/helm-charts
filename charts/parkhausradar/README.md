# Parkhausradar chart

Helm chart for [Parkhausradar](https://github.com/it-at-m/parkhausradar), the live occupancy of the parking garages in Munich's city center.

It deploys:

- `frontend`: the web app (nginx), as a module of [refarch-templates](../refarch-templates)
- `refarch-gateway`: the [refarch-gateway](../refarch-gateway) included by refarch-templates. It gives read-only access to FROST under `/api/frost` (`GET` and `HEAD`, otherwise `405`)
- `collector`: writes the occupancy to FROST every minute, using BasicAuth and optionally a proxy. It has its own Deployment, because it serves no HTTP and therefore does not fit the probes and tests of refarch-templates

The FROST-Server is not part of this chart, it runs separately.

The frontend and the gateway each get an ingress on the same host: `/` for the frontend and `/api` for the gateway. The frontend calls `/api/frost` on its own host, so the chart fails if the hosts of both differ.

## Installing the Chart

```bash
helm install parkhausradar it-at-m/parkhausradar --values my-values.yaml
```

Then fill in the BasicAuth credentials of the collector in the Secret `<release>-frost` (keys `USERNAME` and `PASSWORD`) and restart the collector. The chart creates the Secret only once with empty values and keeps it on upgrades and uninstalls.

## Configuration

| Value | Description |
| --- | --- |
| `global.frost.baseUrl` | Scheme and host of the FROST-Server, e.g. `https://frost.example.com`. Required. |
| `global.frost.path` | Path of the service root without API version. Defaults to `/FROST-Server`. |
| `collector.image.*` | Image of the collector. Defaults to `ghcr.io/it-at-m/parkhausradar/collector:dev`. |
| `collector.proxy` | Proxy of the collector for the data source and FROST, e.g. `http://proxy.example.com:8080`. Empty for none. |
| `collector.noProxy` | Comma separated hosts the collector reaches without the proxy. |
| `collector.caCerts.enabled` | Mount a CA bundle in PEM format into the collector and set `SSL_CERT_FILE`. Defaults to `false`. |
| `collector.caCerts.existingSecret` | Existing Secret holding the CA bundle. |
| `collector.caCerts.existingConfigmap` | Existing ConfigMap holding the CA bundle, alternative to `existingSecret`. |
| `collector.caCerts.key` | Key of the bundle in the Secret or ConfigMap. Defaults to `ca-bundle.crt`. |
| `collector.caCerts.mountPath` | Directory the bundle is mounted to. Defaults to `/etc/pki/ca-trust/extracted/pem`. |
| `collector.resources` | Resources of the collector. |
| `refarch-templates.modules.frontend.*` | Configuration of the frontend, see [refarch-templates](../refarch-templates). |
| `refarch-templates.refarch-gateway.*` | Configuration of the gateway, see [refarch-gateway](../refarch-gateway). |

`global.frost` is global, because the collector and the gateway in the subchart both need it.

The image tags default to `dev` with `pullPolicy: Always`. For immutable tags set `image.tag` and `image.pullPolicy: IfNotPresent` for the collector and the frontend.

## Private CAs

If FROST has a certificate of a private CA, the collector and the gateway have to trust it.

The collector replaces the CA bundle of its image with `collector.caCerts`, so the bundle has to contain the public CAs as well, because the collector also fetches the public data source. On OpenShift, a ConfigMap labeled with `config.openshift.io/inject-trusted-cabundle=true` is filled with such a bundle under the key `ca-bundle.crt`:

```bash
oc create configmap trusted-ca
oc label configmap trusted-ca config.openshift.io/inject-trusted-cabundle=true
```

```yaml
collector:
  caCerts:
    enabled: true
    existingConfigmap: trusted-ca
```

The gateway is a Java application and needs a Java truststore instead, mounted as in the [refarch-templates example](../refarch-templates/values-example.yaml):

```yaml
refarch-templates:
  refarch-gateway:
    volumes:
      - name: cacerts-volume
        secret:
          secretName: cacerts-lhm
          items:
            - key: cacerts-lhm
              path: cacerts
    volumeMounts:
      - name: cacerts-volume
        mountPath: /etc/pki/ca-trust/extracted/java
        readOnly: true
```

## Example

Example for an environment:

```yaml
global:
  frost:
    baseUrl: https://frost.example.com

collector:
  proxy: http://proxy.example.com:8080
  noProxy: frost.example.com

refarch-templates:
  modules:
    frontend:
      ingress:
        className: openshift-default
        annotations:
          route.openshift.io/termination: edge
        hosts:
          - host: parkhausradar.example.com
            paths:
              - path: /
                pathType: Prefix
  refarch-gateway:
    envAppend:
      - name: ALLOWED_ORIGINS_PUBLIC
        value: https://parkhausradar.example.com
    ingress:
      enabled: true
      className: openshift-default
      annotations:
        route.openshift.io/termination: edge
      hosts:
        - host: parkhausradar.example.com
          paths:
            - path: /api
              pathType: Prefix
```
