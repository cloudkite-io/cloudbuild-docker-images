# postgresclient-with-awscli

This is a debian/ubuntu based image that contains:
* postgres client
* awscli

We use either debian or ubuntu, depending on which of the two has postgresql-client available in a stable release. References:

- https://packages.debian.org/search?keywords=postgresql-client
- https://launchpad.net/ubuntu/+search?text=postgresql-client

##  Usage
```bash
export _tag=15.5-bookworm
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/postgresclient-aws:$_tag .
docker push us-central1-docker.pkg.dev/cloudkite-public/docker-images/postgresclient-aws:$_tag
```

## CICD

The deployment for this image builds only on push of a tag formatted as `postgresclient-aws-*` to the repo. Please use the postgres and the debian/ubuntu version in the tag, e.g postgresclient-aws-15-5-bookworm, for the image to be tagged as us-central1-docker.pkg.dev/cloudkite-public/docker-images/postgresclient-aws:15-5-bookworm.
