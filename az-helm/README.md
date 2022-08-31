This image contains:
 * azure cli 
 * helm
 * yq
 * git


# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/az-helm:$_tag .
docker push gcr.io/cloudkite-public/az-helm:$_tag