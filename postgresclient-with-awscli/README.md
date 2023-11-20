# postgresclient-with-awscli

This is a debian based image that contains:
* postgres client
* awscli

##  Usage
```bash
export _tag=15.5-bookworm
docker build -t gcr.io/cloudkite-public/postgresclient-aws:$_tag .
docker push gcr.io/cloudkite-public/postgresclient-aws:$_tag