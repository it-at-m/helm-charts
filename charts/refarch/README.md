# Dokumentation for refarch helm template

Below are all options possible in one module
```yml
configMaps:
  - name: ABC
    data:
      # property-like keys; each key maps to a simple value
      player_initial_lives: "3"
      # file-like keys
      game.properties: |
        enemy.types=aliens,monsters
        player.maximum-lives=5

imagePullSecrets:
  - name: testSecret

modules:
  - name: example
    image:
      repository: ghcr.io/it-at-m/refarch-templates/example
      # pullPolicy: Always # Defaults to IfNotPresent
      tag: "latest"
    applicationYML:
      ENV_VARIABLE: someValue # alternative to env.value
      spring:
        profiles:
          active: "myprofile"
    env:
      # static
      - name: JAVA_OPTS_APPEND
        value: someStaticValue
      # single reference dynamic
      - name: SECRET_ENV_EXAMPLE
        valueFrom:
          secretKeyRef:
            name: nameOfSecret
            key: keyOfSecret
      - name: SECRET_ENV_EXAMPLE
        valueFrom:
          configMapKeyRef:
            name: nameOfConfigMap
            key: keyOfConfigMap
    envFrom:
      # whole files of envs
      - configMapRef:
          name: nameOfConfigMap
      - secretRef:
          name: nameOfSecret

    ### NETWORKING
    service:
      http: true # adds default http port mapping
      javaDebug: false   # adds default java debug port mapping
      ports:
        - name: myport
          protocol: TCP
          port: 8888
          targetPort: http
    # ingress:
    #   # port: 1234    # defaults to 8080
    #   className: ""
    #   # annotations:
    #   #   kubernetes.io/ingress.class: nginx
    #   #   kubernetes.io/tls-acme: "true"
    #   hosts:
    #     - host: chart-example.local
    #       paths:
    #         - path: /
    #           pathType: ImplementationSpecific
    #   # tls:
    #   #  - secretName: chart-example-tls
    #   #    hosts:
    #   #      - chart-example.local

    ### STORAGE
    volumes:
      - name: cacerts-lhm
        secret:
          defaultMode: 420
          secretName: cacerts-lhm
          items:
            - key: cacerts-lhm
              path: cacerts
    volumeMounts:
      - mountPath: /etc/pki/ca-trust/extracted/java
        name: cacerts-lhm
        readOnly: true
#
    ### MONITORING
    ### Does not have to be defined - defaults exist
    # startupProbe:
    #   httpGet:
    #     path: /actuator/health
    #     port: http
    #   initialDelaySeconds: 60
    # livenessProbe:
    #   httpGet:
    #     path: /actuator/health/liveness
    #     port: http
    # readinessProbe:
    #   httpGet:
    #     path: /actuator/health/readiness
    #     port: http
#
    ### RESOURCES & SCALING
    ## It is possible to define requests or limits individually but both (cpu and memory) need to be set!
    # resources:
    #   requests:
    #     cpu: 100m
    #     memory: 512Mi
    #   limits:
    #     cpu: 500m
    #     memory: 512Mi
    # replicas: 2 # defaults to 1
    ## Is disabled by default and enabled by defining this object
    # autoscaling:
    #   minReplicas: 2 # defaults to 1
    #   maxReplicas: 5 # defaults to 10
    #   targetCPUUtilizationPercentage: 80
    #   targetMemoryUtilizationPercentage: 80


```


