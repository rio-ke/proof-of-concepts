#### petclinic microservice  deployment proocess
---


**resource creation use github action**

In this use case, we are preparing the CICD pipeline by using github actions to deliver all resources.

**how to run the pipeline?**

We have currently configured the manual trigger pipeline. This pipeline can be used to create environment-based resources.

![image](https://user-images.githubusercontent.com/61459314/171553067-330c0ad3-3912-4ba5-a3e2-658ab1c519c1.png)

**pipeline success status**

![image](https://user-images.githubusercontent.com/61459314/171552903-fcabeddd-4c12-46c1-a486-c7457f4e120e.png)


**Download the eks credentials**

```bash

sudo apt install awscli -y
aws configure
aws eks update-kubeconfig --region us-east-1 --name prod-dev

```

after terraform resource creation We must first validate the rds mysql database connectivity. In this case, I'm making use of the private rds database. We are unable to gain access from outside the cluster. As a consequence, the internal connectivity validation process is required.

```yml
---
# filename: mysql.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "petclinic"
        ports:
        - containerPort: 3306
          name: mysql

```

following deployment Enter the container and validate connctivity use  their credentials.

**validation commands**

```bash

kubectl create -f mysql.yml
kubectl get po
wordpress-mysql-cd69497df-988gp
kubectl exec -ti wordpress-mysql-cd69497df-988gp bash
mysql -h petclinics.crhzreu3chpm.us-east-1.rds.amazonaws.com -u petclinic -p
Password: 

# after validate caonnectivity
kubectl delete -f mysql.yml
```

**create the ingress-nginx controller**

```bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml

```

**certificate manager**

```helm

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true

# upgrade the palybook
helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --set installCRDs=true

```

As per the repository source code `https://github.com/spring-projects/spring-petclinic` you should replace mysql credentials under `main/resources/application-mysql.properties` 

The file 'application-mysql.properties' should look like this.

```properties
# database init, supports mysql too
database=mysql
spring.datasource.url=${MYSQL_URL:jdbc:mysql://petclinics.crhzreu3chpm.us-east-1.rds.amazonaws.com/petclinic}
spring.datasource.username=${MYSQL_USER:petclinic}
spring.datasource.password=${MYSQL_PASS:petclinic}
# SQL is written to be idempotent so this is safe
spring.sql.init.mode=always

```


**Docker file preparation**

```Dockerfile

FROM openjdk:11 as build
WORKDIR /apps
COPY . .
RUN ./mvnw package
# RUN ./mvnw package spring.profiles.active=mysql

FROM openjdk:11
WORKDIR /app
COPY --from=build /apps/target/*.jar .
EXPOSE 8080
CMD ["java","-Dspring.profiles.active=mysql","-jar","spring-petclinic-2.7.0-SNAPSHOT.jar"]

```

**Docker image preparation**

```bash
docker build -t jjino/petclinic:v1.0 .
docker push jjino/petclinic:v1.0

```

**Deployment file preparation with certificate manager**

```yml

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  revisionHistoryLimit: 4
  paused: false
  replicas: 2
  minReadySeconds: 10
  selector:
    matchLabels:
      role: webserver
    matchExpressions:
      - {key: version, operator: In, values: [v1, v2, v3]}
  template:
    metadata:
      name: web
      labels:
        role: webserver
        version: v1
        tier: frond-end
    spec:
      containers:
        - name: web
          image: jjino/petclinic:v1.0
          ports:
            - containerPort: 8080
              protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  labels:
    role: web-service
spec:
  selector:
    role: webserver
    version: v1
  type: ClusterIP
  ports:
    - port: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: petclinic.fourtimes.ml
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-dev"
    kubernetes.io/tls-acme: "true"
    # ingress.kubernetes.io/force-ssl-redirect: "true"
    # nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  tls:
    - hosts:
      - petclinic.fourtimes.ml
      secretName: petclinic.fourtimes.ml
  rules:
  - host: petclinic.fourtimes.ml
    http:
      paths:
      - backend:
          service:
            name: web-service
            port:
              number: 8080
        path: /
        pathType: ImplementationSpecific
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-dev
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: jinojoe@gmail.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-dev
    # Enable the HTTP-01 challenge provider
    solvers:
    - selector: {}
      http01:
        ingress:
          class: nginx
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: petclinic.fourtimes.ml
spec:
  secretName: petclinic.fourtimes.ml
  privateKey:
    rotationPolicy: Always
  issuerRef:
    name: letsencrypt-dev
    kind: ClusterIssuer
    group: cert-manager.io
  commonName: petclinic.fourtimes.ml
  dnsNames:
    - petclinic.fourtimes.ml

```

_results_

In this case, I'm using a freenom domain in conjunction with a certificate manager to obtain letencrypt SSL.

open your browser https://petclinic.fourtime.ml

![image](https://user-images.githubusercontent.com/61459314/171373685-c32f5c87-1c12-4b90-aa2b-710024a794f6.png)
