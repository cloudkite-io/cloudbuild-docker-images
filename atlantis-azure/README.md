This image contains:
 * atlantis
 * jq 
 * azure cli 

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/atlantis-azure:$_tag .
docker push gcr.io/cloudkite-public/atlantis-azure:$_tag