# Use

Docker image that is used to export Azure SQL DB to ABS and import to desired server

# Building and pushing Image
```bash
export _tag=`date +%Y%m%d`
docker build -t us-central1-docker.pkg.dev/cloudkite-public/docker-images/az-sql-db-export-restore:$_tag .
docker push us-central1-docker.pkg.dev/cloudkite-public/docker-images/az-sql-db-export-restore:$_tag
