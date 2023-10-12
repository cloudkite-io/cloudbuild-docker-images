This image contains:

* gcloud
* cloudsql-proxy
* mysql
* kubectl

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/gcloud-cloudsqlproxy-mysql-kubectl:$_tag .
docker push gcr.io/cloudkite-public/gcloud-cloudsqlproxy-mysql-kubectl:$_tag
```

