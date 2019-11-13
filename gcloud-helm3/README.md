This image contains:

* helm version 3
* gcloud
* docker-compose
* kubectl

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/gcloud-helm3:$_tag .
docker push gcr.io/cloudkite-public/gcloud-helm3:$_tag
```

