This image contains:

* git-crypt
* helm3
* gcloud
* docker-compose
* kubectl

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/gcloud-helm3-git-crypt:$_tag .
docker push gcr.io/cloudkite-public/gcloud-helm3-git-crypt:$_tag
```
