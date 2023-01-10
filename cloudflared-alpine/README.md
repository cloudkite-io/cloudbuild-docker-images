This image contains:
* cloudflared on alpine


Cloudflared binary on apline image

Start script is used to start cloudflared processes that are then exposed locally within the container.

required env vars:

* ATLANTIS_CF_SERVICE_AUTH_ID 
* ATLANTIS_CF_SERVICE_AUTH_SECRET
* BASE_PORT


# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/cloudflared-alpine:$_tag .
docker push gcr.io/cloudkite-public/cloudflared-alpine:$_tag