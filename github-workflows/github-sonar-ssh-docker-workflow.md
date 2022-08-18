

```yml
---
name: kafka apps docker build
on:
  push:
    branches:
      - main
jobs:
  kafka:
    name: kafka app build
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v1
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: "sqp_deb2d6cc66d26941a8c4a2e3a2c7c624f4bf1170"
          SONAR_HOST_URL: "http://107.23.14.177:9000"
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      - uses: azure/docker-login@v1
        with:
          username: ${{ secrets.DOCKER_USER }}
          password: ${{ secrets.DOCKER_TOKEN }}
      - name: docker build
        run: docker build -t  ${{ secrets.DOCKER_USER }}/azure-hdinsight-kafka:$GITHUB_RUN_NUMBER .
      - name: show the docker image name
        run: echo ${{ secrets.DOCKER_USER }}/azure-hdinsight-kafka:$GITHUB_RUN_NUMBER
      - name: docker push
        run: docker push ${{ secrets.DOCKER_USER }}/azure-hdinsight-kafka:$GITHUB_RUN_NUMBER
      - name: docker logout
        run: docker logout
      - name: executing remote ssh commands using password
        uses: appleboy/ssh-action@master
        with:
          host: "107.23.14.177"
          username: "ubuntu"
          key: ${{ secrets.KEY }}
          port: 22
          script: sudo docker run -d nginx

```
