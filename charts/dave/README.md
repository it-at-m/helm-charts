# dave
helmchart for [DAVe traffic counting plattform](https://opensource.muenchen.de/software/dave.html)
This chart bootstraps on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm upgrade --install my-dave it-at-m/dave -f my-values.yaml
```

Create your local configuration from [ci/test-values.yaml](ci/test-values.yaml) and add optional values from [values.yaml](values.yaml)


### Adding CA certificate fingerprint

Elasticsearch must communicate with TLS, including Kubernetes internally.
Therefore, the SSL fingerprint of a new Elasticsearch instance must be set to the backend as env ELASTICSEARCH_HTTP_CA_CERTIFICATE.
This must only be done when a new Elasticsearch instance is created, not with every deploy.

```bash
kubectl/oc rsh dave-elasticsearch-master-0
$ openssl x509 -fingerprint -sha256 -nocert -in /opt/bitnami/elasticsearch/config/certs/tls.crt | cut -d= -f2
```

Add this fingerprint as env `ELASTICSEARCH_HTTP_CA_CERTIFICATE` to your locale `backend.extraEnvVars.env`.

We are looking for an automatic solution https://github.com/it-at-m/helm-charts/issues/106.
