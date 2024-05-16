# Contributing Guidelines

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

Contributions are welcome via GitHub pull requests. This document outlines the process to help get your contribution accepted.

## Issue/Pull request template

Isssues or Pull requests to a chart should be created with prefix `[charts/<name>]` eg: `[charts/ezldap]`

## Bumping chart version

Every PR should include chart version bump, because we can not have different version of the charts with the same version name.

_If not, the CI lint will fail and PR can't be accepted_

## Automated Pull Request Checks

Every chart gets _linted_ and _tested_ by [chart-testing](https://github.com/helm/chart-testing).

For testing, the chart is deployed to a Kubernetes cluster (created with [kind](https://kind.sigs.k8s.io/)) using the charts default `values.yaml` _or_ a special `values.yaml` for testing (`<chart-dir>/ci/test-values.yaml`).

After successful deployment, all specified tests (`chart-dir/templates/tests/**`) are executed.

_If linting and testing fails the PR can't be accepted_
