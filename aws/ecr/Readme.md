**Docker build and push to ECR**

__Requirements__

* awscli

configure the aws credentials

```bash
aws configure
```

Retrieve an authentication token and authenticate your Docker client to your registry. Use the AWS CLI:

```bash
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 676487226531.dkr.ecr.ap-southeast-1.amazonaws.com
```

Note: If you receive an error using the AWS CLI, make sure that you have the latest version of the AWS CLI and Docker installed.
Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here 
. You can skip this step if your image is already built:

```bash
docker build -t operation-unknown .
```

After the build completes, tag your image so you can push the image to this repository:

```bash
docker tag operation-unknown:latest 676487226531.dkr.ecr.ap-southeast-1.amazonaws.com/operation-unknown:latest
```

Run the following command to push this image to your newly created AWS repository

```bash
docker push 676487226531.dkr.ecr.ap-southeast-1.amazonaws.com/operation-unknown:latest
```
