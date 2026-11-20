# model2vec-serve Helm Chart

Deploys the model2vec-serve OpenAI/TEI compatible embeddings server on Kubernetes.

## Installing from the it@M chart repository

The chart is published on every versioned chart change. Either use the OCI
registry:

```bash
helm install model2vec-serve \
  oci://ghcr.io/it-at-m/helm-charts/model2vec-serve \
  --version 0.7.0 \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set apiKey=your-secret-key
```

or the HTTP repository:

```bash
helm repo add it-at-m https://it-at-m.github.io/helm-charts
helm repo update
helm install model2vec-serve it-at-m/model2vec-serve \
  --version 0.7.0 \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set apiKey=your-secret-key
```

Installing from a local checkout (`./charts/model2vec-serve`) still works for
development.

## Installation

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set model=minishlab/blink-multilingual-64M \
  --set apiKey=your-secret-key
```

## Multi-model installation

Load multiple models and specify the default one:

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set models[0]=minishlab/potion-base-2M \
  --set models[1]=minishlab/blink-multilingual-64M \
  --set defaultModel=minishlab/potion-base-2M \
  --set apiKey=your-secret-key
```

## Model path aliases

The TEI per-model endpoints (`/tei/{model_id}/embed`, `/tei/{model_id}/info`)
address models by a path identifier. Set `modelAliases` to override the path
identifier of a model. Each entry's `key` must match a `models` entry (or its
derived id); the `alias` becomes the `/tei/{alias}/...` path segment. Duplicate
resolved path segments abort startup.

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set modelAliases[0].key=minishlab/blink-multilingual-64M \
  --set modelAliases[0].alias=blink-multi
```

## Persistent model cache

Set `persistence.enabled` to mount a persistent volume claim at
`persistence.mountPath`. The chart sets the container's `HOME` to that path, so
model downloads land in `<mountPath>/.cache/huggingface/hub` and survive pod
restarts. An operator-supplied `HOME` entry in `env` overrides the injected
value.

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set persistence.enabled=true \
  --set persistence.size=10Gi
```

Set `persistence.existingClaim` to reuse a pre-provisioned claim instead of
creating one.

## Exposing via Ingress

The chart can create a Kubernetes Ingress (disabled by default). Host rules
route to the service `http` port; `ingress.extraLabels` are merged with the
standard chart labels.

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=embeddings.example.com \
  --set ingress.extraLabels.environment=production
```

## Application TLS (end-to-end encryption)

By default the chart serves plain HTTP and TLS terminates at the edge (load
balancer or ingress) in front of it. When traffic must be encrypted on every
hop — all the way to the application inside the container — enable
`tls.enabled` and provide an operator-managed Kubernetes secret containing the
certificate chain and private key. The chart mounts the secret as files and
passes the paths to the service, which then serves HTTPS on the target port
(single listener; plain HTTP is disabled) and switches its probes to the
HTTPS scheme.

Provision the secret first (the chart never creates it):

```bash
kubectl create secret tls model2vec-serve-tls \
  --cert=fullchain.pem --key=privkey.pem
```

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set tls.enabled=true \
  --set tls.existingSecret=model2vec-serve-tls
```

With a passthrough ingress the edge forwards encrypted traffic without
terminating TLS, so encryption reaches the application process. For the
nginx ingress class: the controller must be started with the
`--enable-ssl-passthrough` command-line flag (disabled by default), and the
ingress uses the passthrough annotations:

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set tls.enabled=true \
  --set tls.existingSecret=model2vec-serve-tls \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=embeddings.example.com \
  --set-string ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-passthrough"=true \
  --set ingress.annotations."nginx\.ingress\.kubernetes\.io/backend-protocol"=HTTPS
```

Notes:

- The certificate file should contain the full chain (leaf plus
  intermediates).
- Certificates are loaded once at startup. Renewal = update the secret +
  `kubectl rollout restart deployment/<release>-model2vec-serve -n <namespace>`
  (the chart's generated Deployment name); there is no hot reload.
- `tls.enabled` without `tls.existingSecret` fails `helm template`/install
  with a template error.
- Edge TLS termination in front of a plain-HTTP deployment remains fully
  supported; use `ingress.tls` for that mode instead.

### Automatic certificates with cert-manager

cert-manager can create and renew the certificate that either mode consumes.

*Edge termination* (simplest): put the issuer annotations on the Ingress and
name the secret in `ingress.tls`. cert-manager's ingress-shim issues and
renews the certificate into that secret; the edge terminates TLS:

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=embeddings.example.com \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set ingress.tls[0].secretName=model2vec-serve-tls \
  --set "ingress.tls[0].hosts[0]=embeddings.example.com"
```

*Application TLS (end to end)*: have cert-manager issue into the secret the
chart mounts. Point the issuer annotations (or a standalone
`cert-manager.io/v1 Certificate` resource) at the same secret referenced by
`tls.existingSecret`:

```bash
kubectl apply -f - <<'EOF'
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: model2vec-serve
spec:
  secretName: model2vec-serve-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames: [embeddings.example.com]
EOF

helm install model2vec-serve ./charts/model2vec-serve \
  --set models[0]=minishlab/blink-multilingual-64M \
  --set tls.enabled=true \
  --set tls.existingSecret=model2vec-serve-tls
```

ACME HTTP01 still works with the passthrough example above (ssl-passthrough
only affects port 443; the challenge is served on port 80) — or use a DNS01
solver. After each renewal, restart the pods so the application reloads the
certificate: `kubectl rollout restart
deployment/<release>-model2vec-serve -n <namespace>`.

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `ghcr.io/it-at-m/model2vec-serve` |
| `image.tag` | Container image tag | `"appVersion"` |
| `models` | List of Hugging Face model ids or local paths | `[]` |
| `defaultModel` | Default model when a request does not specify one (defaults to the first model in the list if omitted) | `""` |
| `modelOwner` | Model publisher or owner shown in `/v1/models` responses | `"minishlab"` |
| `modelAliases` | List of `{key, alias}` pairs overriding the `/tei/{model_id}/...` path segments; keys must match a `models` entry, duplicate resolved segments abort startup | `[]` |
| `model` | (Deprecated) Hugging Face model id or local path | `minishlab/blink-multilingual-64M` |
| `apiKey` | API key for authentication | `""` |
| `args` | Extra CLI arguments (must not set `--port`; use `port` instead) | `[]` |
| `port` | Port the application listens on; drives `--port`, the container port and the Service target | `8080` |
| `strategy` | Deployment update strategy; with persistence enabled consider `{ type: Recreate }` so the replacement pod can attach the ReadWriteOnce cache volume | `{}` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `service.annotations` | Extra annotations merged into the Service metadata | `{}` |
| `resources` | CPU/memory requests and limits | see `values.yaml` |
| `startupProbe.enabled` | Startup probe on `/health` with a generous budget for model loading; liveness/readiness start after it succeeds | `true` |
| `autoscaling.enabled` | Enable HPA | `false` |
| `extraVolumes` | Extra volumes | `[]` |
| `extraVolumeMounts` | Extra volume mounts | `[]` |
| `persistence.enabled` | Create and mount a PVC for the model download cache | `false` |
| `persistence.existingClaim` | Use an existing PVC instead of creating one | `""` |
| `persistence.storageClass` | Storage class (empty = cluster default) | `""` |
| `persistence.accessModes` | PVC access modes | `["ReadWriteOnce"]` |
| `persistence.size` | PVC storage request | `5Gi` |
| `persistence.mountPath` | Mount path; `HOME` is set here so the HF cache lives at `<mountPath>/.cache/huggingface/hub` | `/models` |
| `persistence.annotations` | PVC annotations | `{}` |
| `tls.enabled` | Serve HTTPS from the container (single listener; disables plain HTTP) | `false` |
| `tls.existingSecret` | Kubernetes secret with the cert/key entries (required when enabled) | `""` |
| `tls.certKey` | Secret key holding the PEM certificate chain | `tls.crt` |
| `tls.keyKey` | Secret key holding the PEM private key | `tls.key` |
| `tls.mountPath` | Container mount path for the secret | `/etc/model2vec-serve/tls` |
| `ingress.enabled` | Create an Ingress for external access | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.extraLabels` | Extra labels merged into the Ingress metadata | `{}` |
| `ingress.hosts` | Host/path rules (host, paths[path, pathType]) | see `values.yaml` |
| `ingress.tls` | TLS entries (secretName, hosts) | `[]` |

## Volume-mounted models

```bash
helm install model2vec-serve ./charts/model2vec-serve \
  --set model=/models/my-model \
  --set extraVolumes[0].name=model-volume \
  --set extraVolumes[0].hostPath.path=/path/to/local/model \
  --set extraVolumeMounts[0].name=model-volume \
  --set extraVolumeMounts[0].mountPath=/models/my-model
```
