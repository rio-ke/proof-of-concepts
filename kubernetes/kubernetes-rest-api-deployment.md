## kubernetes-rest-api

```bash
    # https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#deploymentspec-v1-apps
    # https://kubernetes.io/docs/reference/using-api/api-concepts/
    
    # Check all possible clusters, as your .KUBECONFIG may have multiple contexts:
    kubectl config view -o jsonpath='{"Cluster name\tServer\n"}{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'

    # Select name of cluster you want to interact with from above output:
    export CLUSTER_NAME="some_server_name"

    # Point to the API server referring the cluster name
    APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")

    # Gets the token value
    TOKEN=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)

    # Explore the API with TOKEN
    curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure

```


kubectl command

```bash

$ echo 'apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-example
spec:
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14
        ports:
        - containerPort: 80
' | kubectl create -f -

```

curl command (requires kubectl proxy to be running)

```bash

$ kubectl proxy
$ curl -X POST -H 'Content-Type: application/yaml' --data '
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-example
spec:
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14
        ports:
        - containerPort: 80
' http://127.0.0.1:8001/apis/apps/v1/namespaces/default/deployments

```
