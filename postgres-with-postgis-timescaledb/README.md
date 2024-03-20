This image contains:

* postgres 14
* postgis 3.4
* timescale
* pgaudit
* barman-cloud
* plpython3
* pgvector
* timescale_vector

# Usage
```bash
export _tag=`date +%Y%m%d`
export _patch=0
cd <postgres version e.g 14>
docker build -t gcr.io/cloudkite-public/docker-images/timescaledb-postgis:14-$_tag .
docker push gcr.io/cloudkite-public/docker-images/timescaledb-postgis:14-$_tag
```

gcloud auth configure-docker us-central1-docker.pkg.dev
gcloud builds --project cloudkite-public submit --tag us-central1-docker.pkg.dev/cloudkite-public/docker-images/timescaledb-postgis:14-$_tag-$_patch .