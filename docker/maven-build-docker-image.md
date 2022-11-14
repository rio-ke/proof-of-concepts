_maven-build-docker-image.md_

```Dockerfile
FROM openjdk:11 as build
ARG VERSION=3.8.6
WORKDIR /app
RUN wget https://downloads.apache.org/maven/maven-3/$VERSION/binaries/apache-maven-$VERSION-bin.zip
RUN unzip apache-maven-$VERSION-bin.zip
RUN rm -rf apache-maven-$VERSION-bin.zip
ENV MAVEN_HOME=/app/apache-maven-$VERSION
ENV PATH="$MAVEN_HOME/bin:$PATH"
COPY . .
RUN mvn clean package -U -s settings.xml

```
