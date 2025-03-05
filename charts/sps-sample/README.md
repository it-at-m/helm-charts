# Helm-Chart for Sample RefArch Application

Sample to test a refarch application.

| Name            | Description                                                                                            | Value |
|-----------------|--------------------------------------------------------------------------------------------------------|-------|
| refarch-gateway | Config for refarch-gateway see https://github.com/it-at-m/helm-charts/tree/main/charts/refarch-gateway | {}    |
| frontend        | Config for frontend see https://github.com/it-at-m/helm-charts/tree/main/charts/sps-sample/frontend    | {}    |
| backend         | Config for frontend see https://github.com/it-at-m/helm-charts/tree/main/charts/sps-sample/backend     | {}    |
| postgresql      | Config for postgresql see https://github.com/bitnami/charts/tree/main/bitnami/postgresql               | {}    |
| keycloak        | Config for keycloak see https://github.com/bitnami/charts/tree/main/bitnami/keycloak                   | {}    |
| appswitcher     | Config for appswitcher see https://github.com/it-at-m/helm-charts/tree/main/charts/appswitcher-server  | {}    |

## Optionale Charts

Eine PostgreSQL-Datenbank, Keycloak und Appswitcher sind optional. Diese können jeweils einzeln in der Datei [`values.yaml`](charts/sps-sample/values.yaml) durch setzen der Variable `enabled` auf `true` aktiviert werden.
Zusätzlich müssen in der Datei [`values.yaml`](charts/sps-sample/values.yaml) bestimmte Konfigurationen einkommentiert werden.

### Konfiguration für PostgreSQL

- In der `values.yaml` für `backend.image` ein Image wählen, dass eine PostgreSQL Datenbank unterstützt (z.B. ghcr.io/it-at-m/refarch-templates/refarch-backend)
- Database-Variablen für das Backend einkommentieren
- Wert für `database.enabled` auf `true` setzen

### Konfiguration für Keycloak

- In der `values.yaml` das Spring Profil `no-security` für das refarch-gateway auskommentieren
- Die Variablen für Keycloak beim refarch-gateway einkommentieren
- Wert für `keycloak.enabled` auf `true` setzen

### Konfiguration für Appswitcher

- `INFO_APPSWITCHER_URL`-Variable unter refarch-gateway in der `values.yaml` einkommentieren
- Wert für `appswitcher-server.enabled` auf `true` setzen
- Unter `appswitcher-server.applications` die gewünschten Anwendungen konfigurieren
