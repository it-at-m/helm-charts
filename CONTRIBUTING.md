# Contributing Guidelines

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

## Contributing a new Chart

All it@M developers have direct write access to the repo (through team [`itm-devs`](https://github.com/orgs/it-at-m/teams/itm-devs)) and therefore don't have to fork the repository to contribute.

To contribute a Chart please create a Pull Request. Make sure to also add the maintainer(s) of the new Chart as code-owner in [CODEOWNERS](.github/CODEOWNERS), preferably referencing a corresponding team.

Charts without maintainers **can not be accepted**.

### Use common library

Please use the helpers and definitions of the `it-at-m/common` Helm chart library where applicable to keep our charts DRY.

For more information on how to use the library please see the [documentation](charts/common/README.md).

## Bumping chart version

Every Pull Request that changes a Chart **must include a chart version bump**, because we can not have different versions of the Charts with the same version name.

If not, the CI lint will fail and the Pull Request **can not be accepted**.

## Automated Pull Request Checks

Every changed Chart gets _linted_ and _tested_ using [chart-testing](https://github.com/helm/chart-testing).

For testing, the Chart is deployed to a Kubernetes cluster (created with [kind](https://kind.sigs.k8s.io/)) using the charts default `values.yaml` _or_ a special `values.yaml` for testing (`<chart-dir>/ci/test-values.yaml`).

After successful deployment, all specified tests (`chart-dir/templates/tests/**`) are executed.

If linting or testing fails the Pull Request **can not be accepted**.
