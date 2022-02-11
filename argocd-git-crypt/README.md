This image contains:

* git-crypt
* argocd


# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/argocd-git-crypt:$_tag .
docker push gcr.io/cloudkite-public/argocd-git-crypt:$_tag
```

NOTE: Since at the moment Argo CD does not provide the ability to describe any 
hooks for synchronizing the repository, we use a tricky shell script that wraps the git command:
```bash
#!/bin/sh
$(dirname $0)/git.bin "$@"
ec=$?
[ "$1" = fetch ] && [ -d .git-crypt ] || exit $ec
GNUPGHOME=/app/config/gpg/keys git-crypt unlock 2>/dev/null
exit $ec
```
Learn more about it [here](https://itnext.io/configure-custom-tooling-in-argo-cd-a4948d95626e).