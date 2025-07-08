This image contains:
 * atlantis
 * jq 
 * aws_cli

# Usage
```sh
export _tag=v0.35.0  && \
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws:$_tag \
             -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws:latest . && \
docker push -a us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws
```

## CICD

The deployment for this image builds only on push of a tag formatted as `atlantis-aws-*` to the repo. Please use the version of the atlantis image in the tag, e.g v0.35.0, for the image to be tagged as us-central1-docker.pkg.dev/cloudkite-public/docker-images/atlantis-aws:v0.35.0.
