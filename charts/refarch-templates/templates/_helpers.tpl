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
{{- $moduleName := .moduleName }}
{{- printf "%s-%s" .dot.Release.Name $moduleName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the truncated module name for the image stream
*/}}
{{- define "getFullnameImageStream" -}}
{{- $releaseName := index . 0 }}
{{- $imagestreamName := index . 1 }}
{{- printf "%s-%s" $releaseName $imagestreamName | trunc 63 | trimSuffix "-" -}}
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
{{- $moduleName := .moduleName }}
helm.sh/chart: {{ include "getChartName" .dot }}
{{- include "getSelectorLabels" . }}
{{- if ".Chart.Version" }}
app.kubernetes.io/version: {{ .dot.Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .dot.Release.Service }}
{{- end }}

{{/*
Get the Selector labels for connection between service and pods
*/}}
{{- define "getSelectorLabels" -}}
{{- $moduleName := .moduleName }}
{{- if $moduleName }}
app.kubernetes.io/name: {{ include "getName" $moduleName }}
{{- end }}
app.kubernetes.io/instance: {{ .dot.Release.Name }}
{{- end }}

{{/*
Get the trigger annotation
*/}}
{{- define "triggerAnnotation" -}}
  {{- $moduleName := (index . 0) }}
  {{- $imagestream := index . 1 }}
  {{- $releaseName := index . 2}}
image.openshift.io/triggers: '[{"from":{"kind":"ImageStreamTag","name":"{{include "getFullnameImageStream" (list $releaseName $imagestream)}}:{{ $moduleName  }}"},"fieldPath":"spec.template.spec.containers[?(@.name==\"{{ $moduleName  }}\")].image"}]'
{{- end }}
