# RefArch gateway chart

Helm chart for the [refarch-gateway](https://github.com/it-at-m/refarch).

## Configuration

### Memory limit change

**Warning:** When `resources.limit.memory` is changed, `javaHeapMaxMemRatio` (mapped to `JAVA_MAX_MEM_RATIO`) needs to
be modified accordingly.

The default value of `javaHeapMaxMemRatio=30` is intended for the default `resources.limit.memory=500m`.
See [documentation of env var `JAVA_MAX_MEM_RATIO`](https://rh-openjdk.github.io/redhat-openjdk-containers/ubi9/ubi9-openjdk-21-runtime.html).
