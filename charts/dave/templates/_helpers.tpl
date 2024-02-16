{{/*
Helper to check whether all required variables for all Openshift Objects are configured.
*/}}
{{- define "check.required.values.all" }}
  {{- $applicationName := required "applicationName muss angegeben werden!" .Values.daveBackend.applicationName -}}
  {{- $applicationEnv := required "applicationEnv muss angegeben werden!" .Values.daveBackend.applicationEnv -}}
  {{- $applicationLabel := required "applicationLabel muss angegeben werden!" .Values.daveBackend.applicationLabel -}}
{{ end -}}

{{/*
Helper to check whether all required variables for Openshift Object Deployment are configured.
*/}}
{{- define "check.required.values.deployment" }}
  {{- $springProfilesActive := required "springProfilesActive muss angegeben werden!" .Values.daveBackend.springProfilesActive -}}
{{ end -}}
