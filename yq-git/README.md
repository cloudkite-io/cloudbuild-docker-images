This image contains:

* yq
* git
* curl
* openssh-client

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/yq-git:$_tag .
docker push gcr.io/cloudkite-public/yq-git:$_tag
```
