# Helm-Chart for Sample RefArch Backend Application

Sample to test a refarch backend application.

<table>
<tr>
<td>Name</td>
<td>Description</td>
<td>Value</td>
</tr>
<tr>
<td>global.backend.name</td>
<td>Name</td>
<td>backend</td>
</tr>
<tr>
<td>replicaCount</td>
<td>Count of Replicas</td>
<td>1</td>
</tr>
<tr>
<td>image.repository</td>
<td>Repository of the image</td>
<td>ghcr.io/it-at-m/sps/sps-backend</td>
</tr>
<tr>
<td>image.pullPolicy</td>
<td>Image Pull Policy</td>
<td>IfNotPresent</td>
</tr>
<tr>
<td>image.tag</td>
<td>Overrides the image tag whose default is the chart appVersion.</td>
<td>“” /latest</td>
</tr>
<tr>
<td>imagePullSecrets</td>
<td>Secret to pull image</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>nameOverride</td>
<td>Override name</td>
<td>“”</td>
</tr>
<tr>
<td>fullnameOverride</td>
<td>Override full name</td>
<td>“”</td>
</tr>
<tr>
<td>servcieAccount.create</td>
<td>Specifies whether a service account should be created</td>
<td>True</td>
</tr>
<tr>
<td>serviceAccount.automount</td>
<td>Automatically mount a ServiceAccount's API credentials?</td>
<td>True</td>
</tr>
<tr>
<td>serviceAccount.annotations</td>
<td>Annotations to add to the service account</td>
<td>{}</td>
</tr>
<tr>
<td>serviceAccount.Name</td>
<td>

The name of the service account to use.

If not set and create is true, a name is generated using the fullname template

 

 
</td>
<td>“”</td>
</tr>
<tr>
<td>podAnnotations</td>
<td>Pod Annotaions</td>
<td>{}</td>
</tr>
<tr>
<td>podLabels</td>
<td>Pod Labels</td>
<td>{}</td>
</tr>
<tr>
<td>podSecurityContext</td>
<td>Pod Security Context</td>
<td>{}</td>
</tr>
<tr>
<td>securityContext.capbilities.drop</td>
<td>

ecurity-Settings recommended from https://github.com/Checkmarx/kics

 
</td>
<td>“All”</td>
</tr>
<tr>
<td>securityContext.runAsNonRoot</td>
<td>Run container as non root</td>
<td>True</td>
</tr>
<tr>
<td>Service.type</td>
<td>Service Type</td>
<td>ClusterIp</td>
</tr>
<tr>
<td>Service.port</td>
<td>Service Port</td>
<td>8080</td>
</tr>
<tr>
<td>Ingress.enabled</td>
<td>Ingress enabled</td>
<td>False</td>
</tr>
<tr>
<td>Ingress.className</td>
<td>Ingress Class Name</td>
<td>“”</td>
</tr>
<tr>
<td>Ingress.annotations</td>
<td>Ingress Annotations</td>
<td>{}</td>
</tr>
<tr>
<td>Ingress.host</td>
<td>Ingress Host</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>Ingress.tls</td>
<td>Ingress Certificates</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>Resources</td>
<td>Pod Resources</td>
<td>{}</td>
</tr>
<tr>
<td>livenessProbe.httpGet.path</td>
<td>Liveness Probe Path</td>
<td>/</td>
</tr>
<tr>
<td>livenessProbe.httpGet.Port</td>
<td>Liveness Probe Port</td>
<td>http</td>
</tr>
<tr>
<td>readinessProbe.httpGet.path</td>
<td>Readiness Probe Path</td>
<td>/</td>
</tr>
<tr>
<td>readinessProbe.httpGet.port</td>
<td>Readiness Probe Port</td>
<td>http</td>
</tr>
<tr>
<td>Autoscaling.enabled</td>
<td>Autoscalling enabled</td>
<td>False</td>
</tr>
<tr>
<td>Autoscaling.minreplicas</td>
<td>Autoscaling Minimum Replicas</td>
<td>1</td>
</tr>
<tr>
<td>Autoscaling.maxReplicas</td>
<td>Autoscalling maximal Replicas</td>
<td>100</td>
</tr>
<tr>
<td>Autoscaling.targetCPUUtilizationPercentage</td>
<td>Autosceling target CPU Utlization Percentage</td>
<td>80</td>
</tr>
<tr>
<td>Volumes</td>
<td>

Additional volumes on the output Deployment definition.

Possible add Java Truststore
</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>volumeMounts</td>
<td>

Additional volumeMounts on the output Deployment definition.<br>Possible add Java Truststore
</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>nodeSelector</td>
<td>Node Selector</td>
<td>{}</td>
</tr>
<tr>
<td>Tolerations</td>
<td>Tolerations</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>Affinity</td>
<td>Affinity</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>Env</td>
<td>Environments for Pod</td>
<td>

\[\]
</td>
</tr>
<tr>
<td>extraInitContainer</td>
<td>Configure extra InitContainer</td>
<td>{}</td>
</tr>
<tr>
<td>Lifecycle.preStop.exec.command</td>
<td>Lifecycle PreStop Lifecycle Hook</td>
<td>

\[\]
</td>
</tr>
</table>

