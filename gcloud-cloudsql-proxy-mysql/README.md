This image contains:

* gcloud
* cloudsql-proxy
* jq

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/gcloud-cloudsql-proxy-mysql-jq:$_tag .
docker push gcr.io/cloudkite-public/gcloud-cloudsql-proxy-mysql-jq:$_tag
```

