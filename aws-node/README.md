This image contains:
 * aws_cli
 * jq 
 * git
 * zip
 * curl

# Usage
```
export _tag=`date +%m%d%Y` && \
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/aws-node:$_tag \
             -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/aws-node:latest \
             . && \
docker push -a us-central1-docker.pkg.dev/cloudkite-public/docker-images/aws-node
```