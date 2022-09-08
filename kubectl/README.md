This image contains:

* kubectl

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/kubectl:$_tag .
docker push gcr.io/cloudkite-public/kubectl:$_tag
```

