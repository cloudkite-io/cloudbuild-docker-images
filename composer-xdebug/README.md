This image contains composer and xdebug mainly used for running php tests with coverage reports

# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/composer-xdebug:$_tag .
docker push gcr.io/cloudkite-public/composer-xdebug:$_tag
```