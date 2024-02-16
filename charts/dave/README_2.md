# helm-template

[Helm](https://helm.sh/) Template zur Erzeugung / Änderung der Openshift Objekte für RefAch-Anwendungen.

# Konfiguration

## KUBECONFIG Dateien

CICD-Variable in der gitlab-Gruppe oder dem gitlab-Projekt anlegen für jeden Openshift Namespace:  
Standard:

- OPENSHIFT_C_TOKEN: Token für DEV/TEST Umgebung
- OPENSHIFT_P_TOKEN: Token für PROD Umgebung

Erstellung der Kubeconfig siehe https://git.muenchen.de/ccse/cicd/docs-gitlab-runner/-/blob/main-2.x/Creation.adoc#user-content-cap-infrastruktur


## values-\*.yaml

Die Konfiguration für die Openshift Objekte erfolgt in [values.yaml](https://helm.sh/docs/chart_template_guide/values_files/)-Dateien.

Zum Start der Konfiguration kann die Datei [values-minimum.yaml](https://git.muenchen.de/ccse/cicd/helm/helm-template/-/blob/main/values-minimum.yaml) verwendet werden. Sie enthält die minimal notwendigen Konfigurationen, die für einen Service gesetzt werden müssen.

Um weitere Konfigurationen vorzunehmen, werden die jeweiligen Parameter aus der [values.yaml](https://git.muenchen.de/ccse/cicd/helm/helm-template/-/blob/main/values.yaml) in die für den Service vorgesehene values.yaml-Datei kopiert und dort konfiguriert.

Es gibt verschiedene Möglichkeiten, die Openshift Objekte für alle Services und alle Umgebungen einer RefArch-Anwendung zu konfiguieren. Einige Beispiele befinden sich in den [helm-samples](https://git.muenchen.de/ccse/cicd/helm/helm-samples).

## .gitlab-ci.yaml

Die im Projekt vorhandene [`.gitlab-ci.yaml`-Datei](https://git.muenchen.de/ccse/cicd/helm/helm-template/-/blob/main/.gitlab-ci.yml) kann als Basis für die Infrastruktur Pipeline verwendet werden. Die Datei hat Jobs, um einen Service für die DEV- (`upgrade-dev`), TEST- (`upgrade-test`) und PROD- (`upgrade-prod`) Umgebung aufzusetzen.

## Wichtigste Konfigurationsparameter in values.yaml

**build.enabled**  
Dieser Wert ist standardmäßig auf `false` gesetzt und muss für die Umgebung, in der das Anwendungsimage erstellt wird (normalerweise: `dev`) auf `true` gesetzt werden:

```
build:
  enabled: true
```

**route.enabled**  
Dieser Wert ist standardmäßig auf `false` gesetzt und muss für einen Service, der von außen erreichbar sein soll (normalerweise: `apigateway`) auf `true` gesetzt werden:

```
route:
  enabled: true
```

**deploy.envFrom**  
Standardmäßig werden keine Umgebungsparameter über Secret oder ConfigMap geladen. Damit Umgebungsparameter aus einem Secret oder ConfigMap geladen werden, muss envFrom konfiguriert werden:

```
deploy:
  envFrom:
    configMapRef: yourConfigMap
    secretRef: yourSecret
```

**deploy.env**  
Standardmäßig sind die Umgebungsparameter `SPRING_PROFILES_ACTIVE`, `GC_MAX_METASPACE_SIZE`, `JAVA_OPTIONS`, `JAVA_TOOL_OPTIONS` und `TZ` gesetzt. Benötigt die Anwendung weitere Parameter, können diese wie folgt konfiguriert werden:

```
deploy:
  env:
    KEY: VALUE
```

**appdynamics.enabled**  
Dieser Wert ist standardmäßig auf `false` gesetzt. Soll ein Service mit Appdynamics konfiguriert werden, kann der Wert auf `true` gesetzt werden:

```
appdynamics:
  enabled: true
```
