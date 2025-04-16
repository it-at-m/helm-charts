{{/*
Get the truncated module name #backend
*/}}
{{- define "getName" -}}
{{- $moduleName := . }}
{{- printf "%s" $moduleName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the truncated module name with the release name #dev-backend
*/}}
{{- define "getFullname" -}}
{{- $moduleName := . }}
{{- printf "%s-%s" ".Release.Name" $moduleName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the truncated chart name
*/}}
{{- define "getChartName" -}}
{{- printf "%s" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Get the Common labels
*/}}
{{- define "getLabels" -}}
{{- $moduleName := . }}
helm.sh/chart: {{ include "getChartName" . }}
{{ include "getSelectorLabels" $moduleName }}
{{- if .Chart.Version }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Get the Selector labels for connection between service and pods
*/}}
{{- define "getSelectorLabels" -}}
{{- $moduleName := . }}
app.kubernetes.io/name: {{ include "getName" $moduleName }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
