# refarch

## Introduction

This chart bootstraps a sample RefArch deployment based on the architecture described in [RefArch documentation](https://refarch.oss.muenchen.de/overview.html) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
It acts as an example and dependency to create Helm charts for deploying applications based on the RefArch and [its templates](https://refarch.oss.muenchen.de/templates/).
It consists of the following components:
- [refarch-backend](https://github.com/it-at-m/refarch-templates/tree/main/refarch-backend)
- [refarch-eai](https://github.com/it-at-m/refarch-templates/tree/main/refarch-eai)
- [refarch-frontend](https://github.com/it-at-m/refarch-templates/tree/main/refarch-frontend)
- [refarch-webcomponent](https://github.com/it-at-m/refarch-templates/tree/main/refarch-webcomponent)
- [API Gateway](https://refarch.oss.muenchen.de/gateway.html), as a chart dependency via [refarch-gateway](https://github.com/it-at-m/helm-charts/tree/main/charts/refarch-gateway) chart

## Installing the Chart

Install this chart using:

```bash
helm install my-refarch-release it-at-m/refarch --values values.yaml
```

The command deploys a minimal example on the Kubernetes cluster with some default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during via `values.yaml`.

## Configuration

The configuration in split into global configuration options (which are to be reused by all defined modules), and module specific options that only apply to one RefArch component.
`module` is a concept introduced in this chart to be able to define all required deployments as a list and keep the Helm charts using the RefArch as a dependency as lean as possible.

**Note:** All code snippets included in this `README` are intended as required. This allows to easily copy and paste configuration snippets into your own `values.yml`.

### Global configurations

Those configurations create Kubernetes resources which are not specifically bound to a module.

#### Secrets

Global secrets can be created using this Helm chart. Note that the keys for the secret can be created, but the values need to be filled in manually using GUI or CLI mechanisms.

Example:
```yaml
secrets:
  - name: my-secret
    keys:
      - mykey1
      - mykey2
      - mykey3
```

#### ConfigMaps

Global ConfigMaps can be configured to reuse them across multiple modules. You can store property-like keys and file-like keys in it.

Example:
```yaml
configMaps:
  - name: my-configmap
    data:
      # property-like keys; each key maps to a simple value
      player_initial_lives: "3"
      # file-like keys
      myfile.txt: |
        enemy.types=aliens,monsters
        player.maximum-lives=5
```

#### ImagePull Secrets

Image pull secrets might be necessary to bypass pull limits by certain container registries.
The image pull secrets are reused for all modules you define.

Example:
```yaml
imagePullSecrets:
  - name: testSecret
```

### Module configurations

Modules are an individual component deployed for an application and thus consist of module specific Kubernetes resources (e.g. Deployment, Service, HPA, ...).
All configuration has to be done under the `modules` key.

Example:
```yaml
modules:
  # add your modules configuration here (as a list)
```

#### Base information

Base information involves setting the module name and the docker image (and tag) to use.
Additionally, you can override the `pullPolicy`, which is set to `IfNotPresent` by default.

Example:
```yaml
  - name: frontend
    image:
      repository: ghcr.io/it-at-m/refarch-templates/refarch-frontend
      pullPolicy: Always # Defaults to IfNotPresent
      tag: "latest"
```

#### Resources & Scaling

You can configure the desired resources like CPU and RAM and set up auto-scaling.

You can define your resources and desired replica as stated below. If you don't set those properties, those values will be used by default:
```yaml
  resources:
    requests:
      cpu: 100m
      memory: 512Mi
    limits:
      cpu: 500m
      memory: 512Mi
  replicas: 1
```

**Note:** You can also just override the `requests` or `limits`, but always need to set `cpu` and `memory` if you do so.

Configuring auto-scaling is optional and disabled by default.
Example:
```yaml
  autoscaling:
    minReplicas: 1 # defaults to 1
    maxReplicas: 10 # defaults to 10
    targetCPUUtilizationPercentage: 80
    targetMemoryUtilizationPercentage: 80
```

#### Configuration management

This chart provides multiple ways to set configuration for your deployments.

If you have a Spring-based application you can directly configure the content of the application.yml file.
The content will be placed inside a module-specific ConfigMap which is mounted into the container at runtime.
You can define environment variables in it as well.

Example:
```yaml
  applicationYML:
    MY_ENV_VARIABLE: someValue
    spring:
      profiles:
        active: "myprofile"
```

Alternatively you can define single environment variables as follows, optionally referencing and entry inside a global secret or ConfigMap.
This can e.g. be used to set `JAVA_OPTS_APPEND`.

Example:
```yaml
  env:
    # static
    - name: MY_ENV_VARIABLE
      value: myvalue
    # reference to secret
    - name: MY_ENV_FROM_SECRET
      valueFrom:
        secretKeyRef:
          name: my-global-secret
          key: my-key
    # reference to configmap
    - name: MY_ENV_FROM_CONFIGMAP
      valueFrom:
        configMapKeyRef:
          name: my-global-configmap
          key: my-key
```

If you need to set multiple environment variables at once, you can load the whole content of a global secret or configmap.
In this case, the name of the keys in the secret or configmap define the name of the created environment variable.

Example:
```yaml
  envFrom:
    # whole files of envs
    - configMapRef:
      name: my-global-configmap
    - secretRef:
      name: my-global-secret
```

#### Networking

To expose your deployments (either cluster-interally or externally) services and ingresses can be used.

For services, you can either define all port mappings manually or use the custom defined properties, which configure mappings that are required by most services.
Setting `http` to `true` maps to:
```yaml
    - name: http
      protocol: TCP
      port: 8080
      targetPort: http
```

Setting `javaDebug` to `true` maps to:
```yaml
    - name: debug
      protocol: TCP
      port: 8778
      targetPort: http
```

Example for configuring the service:
```yaml
  service:
    http: true
    javaDebug: false
    ports:
      - name: custom-port
        protocol: TCP
        port: 1234
        targetPort: 5678
```

Ingress is required if you want to expose the deployment externally.
Example:
```yaml
  ingress:
    port: 1234    # defaults to 8080
    className: "" # optional 
    annotations: # optional custom annotations
      kubernetes.io/ingress.class: nginx
      kubernetes.io/tls-acme: "true"
    hosts:
      - host: my-example.local
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls:
      - secretName: my-tls-secret
        hosts:
          - my-example.local
```

#### Storage

By default, no volumes are defined and no mounts are mounted connected to the containers. This can be useful to mount important files like certificates.
Example:
```yaml
  volumes:
    - name: cacerts-lhm
      secret:
        defaultMode: 420
        secretName: cacerts-lhm
        items:
          - key: cacerts-lhm
            path: cacerts
  volumeMounts:
    - mountPath: /etc/pki/ca-trust/extracted/java
      name: cacerts-lhm
      readOnly: true
```

#### Monitoring

Health checks are required to validate the functionality of the running deployments.
You can override `startupProbe`, `livenessProbe` and `readinessProbe` individually.

The following configuration is picked up by default:
```yaml
  startupProbe:
    httpGet:
      path: /actuator/health
      port: http
      initialDelaySeconds: 60
  livenessProbe:
    httpGet:
      path: /actuator/health/liveness
      port: http
  readinessProbe:
    httpGet:
      path: /actuator/health/readiness
      port: http
```

**Note:**: Those defaults are suitable for Spring-based applications, because applications like `refarch-backend` or `refarch-eai` expose those endpoints via Spring Actuator.
Web components like `refarch-frontend` or `refarch-webcomponent` are compatible as well, as those mimic the actuator API.