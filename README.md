## Usage

[Helm](https://helm.sh) must be installed to use the charts. Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

    helm repo add appswitcher-server https://it-at-m.github.io/appswitcher-server-helm-chart

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages. You can then run `helm search repo
appswitcher-server` to see the charts.

To install the `appswitcher-server` chart:

    helm install my-appswitcher-server appswitcher-server/appswitcher-server

To uninstall the chart:

    helm delete my-appswitcher-server
