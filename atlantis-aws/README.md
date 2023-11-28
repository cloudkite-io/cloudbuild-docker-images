This image contains:
 * atlantis
 * jq 
 * aws_cli

# Usage
```
export _tag=`date +%m%d%Y` && \
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws:$_tag \
             -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws:latest \
             . && \
docker push -a us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws
```