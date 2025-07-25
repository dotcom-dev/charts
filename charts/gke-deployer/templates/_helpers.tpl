{{/*
Expand the name of the chart.
*/}}
{{- define "helpers.name" -}}
    {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helpers.fullName" -}}
    {{- if .Values.fullNameOverride }}
        {{- .Values.fullNameOverride | trunc 63 | trimSuffix "-" }}
    {{- else }}
        {{- $name := default .Chart.Name .Values.nameOverride }}

        {{- if contains $name .Release.Name }}
            {{- .Release.Name | trunc 63 | trimSuffix "-" }}
        {{- else }}
            {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
        {{- end }}
    {{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helpers.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helpers.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helpers.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helpers.labels" -}}
helm.sh/chart: {{ include "helpers.chart" . }}

{{ include "helpers.selectorLabels" . }}

{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helpers.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create }}
        {{- default (include "helpers.fullName" .) .Values.serviceAccount.name }}
    {{- else }}
        {{- default "default" .Values.serviceAccount.name }}
    {{- end }}
{{- end }}

{{/*
Create the name of the service to use
This centralizes service name logic to prevent breaking changes when service template is modified
*/}}
{{- define "helpers.serviceName" -}}
    {{- .Values.service.name | default (include "helpers.fullName" .) }}
{{- end }}

{{/*
Create the name of the port to use
This centralizes port name logic to prevent breaking changes when port configuration is modified
*/}}
{{- define "helpers.portName" -}}
    {{- .Values.service.portName | default "http" }}
{{- end }}
