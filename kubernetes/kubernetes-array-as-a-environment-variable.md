_kubernetes-array-as-a-environment-variable_

By default, the kubernetes env variable is not supported by array of values. but instead of we can approch this way to do achieve this kind of scenarios.

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: array
spec:
  replicas: 1
  selector:
    matchLabels:
      app: array
  template:
    metadata:
      labels:
        app: array
    spec:
      containers:
      - name: array
        image: nginx
        env:
        - name: ENV_PROJECTS
          value: "project1,project2,project3"
        ports:
        - containerPort: 80
```

_example_

```js
var demo = "a,b,c,d"
var array = demo.split(",");
console.log(array)
console.log(typeof array)

array.forEach(Element => {
    console.log(Element)
});
```

_actual implementation_

```js
var string =process.env.ENV_PROJECTS
var array = demo.split(",");

console.log(array)
console.log(typeof array)
array.forEach(Element => {
    console.log(Element)
});
```

_expected output_

![image](https://user-images.githubusercontent.com/57703276/217413291-bc5781a6-6f82-4e07-848d-2d4735a3aeaa.png)
