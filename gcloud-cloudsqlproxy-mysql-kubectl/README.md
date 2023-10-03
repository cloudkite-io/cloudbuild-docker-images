This image contains:

* gcloud
* mysql
* kubectl

# Usage
```bash
export _tag=`date +%Y%m%d`
gcloud builds submit . --tag=gcr.io/cloudkite-public/gcloud-mysql-kubectl:$_tag --project=cloudkite-public
```

