
_requiremenets_


|PROJECT NAME| SONAR TOKEN| SONAR HOST |
|---|---|---|
|operation-unknown|sqp_66b2b406460c1d356c0b6d31216b8b693b5a7169|operation-unkown.ml|

_create the github secret under github repo settings_

```bash
SONAR_TOKEN = sqp_66b2b406460c1d356c0b6d31216b8b693b5a7169
SONAR_HOST_URL = operation-unkown.ml
```

_Create the file under you repo with project name_

```bash
cat <<EOF > sonar-project.properties
sonar.projectKey=operation-unknown
EOF
```
_github workflows_

```yml
name: Build
on:
  push:
    branches:
      - master # or the name of your main branch
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
      - uses: sonarsource/sonarqube-quality-gate-action@master
        timeout-minutes: 5
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

 _result_
 
 Fianlly you can view the result under the sonar project console.
 
