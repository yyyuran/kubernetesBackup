{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
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
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Created ENV variables
*/}}
{{- define "app.env" -}}
- name: PORT
  value: "80"
- name: NODE_ENV
  value: "{{ .Values.environment }}"
- name: PATH_RAW_IMAGES
  value: "../upload/import/images/"
- name: PATH_RAW_MAIN_IMAGES
  value: "../upload/import/items.csv"
{{- if .Values.additionalEnv }}
{{ toYaml .Values.additionalEnv }}
{{- end }}
{{- end }}


{{- define "app.db" -}}
- name: DB_PASS
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Namespace }}-{{ .Release.Name }}-postgresql-credentials
      key: POSTGRESQL_PASSWORD
- name: DB_DB_NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Namespace }}-{{ .Release.Name }}-postgresql-credentials
      key: POSTGRESQL_DATABASE
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Namespace }}-{{ .Release.Name }}-postgresql-credentials
      key: POSTGRESQL_USERNAME
- name: DB_PORT
  value: "5432"
- name: DB_HOST
  value: {{ .Release.Namespace }}-{{ .Release.Name }}-postgresql-service
{{- end }}
