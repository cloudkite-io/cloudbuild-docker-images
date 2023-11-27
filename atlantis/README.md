This image contains:
 * atlantis
 * jq 

# Usage
```
export _tag=`date +%m%d%Y` && \
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis:$_tag \
             -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis:latest \
             . && \
docker push -a us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis
```