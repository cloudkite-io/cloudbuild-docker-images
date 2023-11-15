This image contains:
 * apache ant


# Usage
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/ant-node-aws:$_tag .
docker push gcr.io/cloudkite-public/ant-node-aws:$_tag
```