# dave
helmchart for [DAVe traffic counting plattform](https://opensource.muenchen.de/software/dave.html)
This chart bootstraps on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

Install this chart using:

```bash
helm upgrade --install my-dave it-at-m/dave -f my-values.yaml
```

Create your local configuration from [values-minimal.yaml](values-minimal.yaml) and add optional values from [values.yaml](values.yaml)
