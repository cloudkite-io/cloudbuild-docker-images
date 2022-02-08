This image contains:

* git-crypt
* argocd


# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/argocd-git-crypt:$_tag .
docker push gcr.io/cloudkite-public/argocd-git-crypt:$_tag
```

