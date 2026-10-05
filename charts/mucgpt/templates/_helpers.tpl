{{- define "mucgpt.caCertsVolume" -}}
{{- if .Values.caCerts.enabled -}}
- name: mucgpt-ca-certs
  secret:
    {{- if .Values.caCerts.existingSecret }}
    secretName: {{ .Values.caCerts.existingSecret }}
    {{- else if .Values.caCerts.existingConfigmap }}
    secretName: {{ .Values.caCerts.existingConfigmap }}
    {{- end }}
    items:
      - key: {{ .Values.caCerts.key }}
        path: {{ .Values.caCerts.key }}
{{- end -}}
{{- end -}}

{{- define "mucgpt.caCertsVolumeMount" -}}
{{- if .Values.caCerts.enabled -}}
- name: mucgpt-ca-certs
  readOnly: true
  mountPath: {{ .Values.caCerts.mountPath }}
{{- end -}}
{{- end -}}

{{- define "mucgpt.caCertsEnv" -}}
{{- if .Values.caCerts.enabled -}}
- name: SSL_CERT_FILE
  value: {{ printf "%s/%s" (trimSuffix "/" .Values.caCerts.mountPath) .Values.caCerts.key | quote }}
{{- end -}}
{{- end -}}

{{- define "mucgpt.getFullname" -}}
{{- $name := .module.name -}}
{{- if contains $name .dot.Release.Name -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .dot.Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "mucgpt.getLabels" -}}
helm.sh/chart: {{ printf "%s-%s" .dot.Chart.Name .dot.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "mucgpt.getSelectorLabels" . }}
app.kubernetes.io/managed-by: {{ .dot.Release.Service }}
app.kubernetes.io/version: {{ .dot.Chart.AppVersion | quote }}
app.kubernetes.io/part-of: {{ .dot.Release.Name }}
{{- end -}}

{{- define "mucgpt.getSelectorLabels" -}}
app.kubernetes.io/name: {{ .module.name }}
app.kubernetes.io/instance: {{ .dot.Release.Name }}
{{- end -}}

{{- define "mucgpt.gatewayFullname" -}}
{{- $name := "refarch-gateway" -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
