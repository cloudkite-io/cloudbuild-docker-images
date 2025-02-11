# postgresclient-with-awscli

This is a debian based image that contains:
* postgres client
* awscli

##  Usage
```bash
export _tag=15.5-bookworm
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/postgresclient-aws:$_tag .
docker push us-central1-docker.pkg.dev/cloudkite-public/docker-images/postgresclient-aws:$_tag
```

## CICD

The deployment for this image builds only on push of a tag formatted as `postgresclient-aws-*` to the repo. Please use the postgres and the debian version in the tag, e.g postgresclient-aws-15-5-bookworm, for the image to be tagged as us-central1-docker.pkg.dev/cloudkite-public/docker-images/postgresclient-aws:15-5-bookworm.
