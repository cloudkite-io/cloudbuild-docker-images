# atlantis-gcp

This image contains:
 * atlantis
 * curl
 * jq 
 * gcloud

## Usage
```bash
export _tag=`date +%m%d%Y` && \
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-gcp:$_tag \
              -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-gcp:latest . && \
docker push -a us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-gcp
```

## CICD

The deployment for this image builds only on push of a tag formatted as `atlantis-gcp-*` to the repo. Please use the version of the atlantis image in the tag, e.g atlantis-gcp-v0.34.0, for the image to be tagged as us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-gcp:v0.34.0.
