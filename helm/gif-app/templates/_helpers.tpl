{{/*
Expand the name of the chart.
*/}}
{{- define "gif-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "gif-app.fullname" -}}
{{- printf "%s-%s" (include "gif-app.name" .) .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "gif-app.labels" -}}
app.kubernetes.io/name: {{ include "gif-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
