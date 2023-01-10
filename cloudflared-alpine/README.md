This image contains:
* cloudflared on alpine


Cloudflared binary on apline image

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/cloudflare-alpine:$_tag .
docker push gcr.io/cloudkite-public/cloudflare-alpine:$_tag