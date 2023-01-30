{{/* vim: set filetype=mustache: */}}

{{/*
    Expand the name of the chart.
*/}}
{{- define "application.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
  {{- printf "%s-%s [%s]" .Chart.Name .Chart.Version .Release.Service | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
    Create image name and tag (assuming the image is in the default repository)
    and the .Image argument is a dict containing 'name' and 'tag'.
*/}}
{{- define "application.image" -}}
  {{- printf "%s/%s:%s" .Values.image_repository .Image.name .Image.tag -}}
{{- end -}}

{{/*
  K8s labels for workloads (deployments, stateful sets, etc.)
*/}}
{{- define "c9s.workload-labels" -}}
app.kubernetes.io/name: {{ .image.name }}
app.kubernetes.io/version: {{ .image.version }}
app.kubernetes.io/component: {{  .component }}
{{- end -}}

{{/*
  K8s labels for services
*/}}
{{- define "c9s.service-labels" -}}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
  K8s labels for all components
*/}}
{{- define "c9s.meta-labels" -}}
app.kubernetes.io/part-of: {{ include "application.name" . }}
app.kubernetes.io/managed-by: {{ include "application.chart" . }}
{{- end -}}
