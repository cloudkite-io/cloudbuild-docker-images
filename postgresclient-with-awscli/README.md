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