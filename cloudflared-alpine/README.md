This image contains:
* cloudflared on alpine


Cloudflared binary on apline image

Start script is used to start cloudflared processes that are then exposed locally within the container.

required env vars:
* INSTANCES (comma separated string)
* CF_SERVICE_AUTH_ID
* CF_SERVICE_AUTH_SECRET
* BASE_PORT
* TUNNEL_ADDRESS


# building
```bash
export _tag=`date +%Y%m%d`
docker build -t gcr.io/cloudkite-public/cloudflared-alpine:$_tag .
docker push gcr.io/cloudkite-public/cloudflared-alpine:$_tag
```

# usage

This container would be useful if using cloudflared to access tcp services using cloudflared service tokens.
An example is having cloudflared access a list of db instances within a private network and expose those via various ports within 
the container.

In the case of exposing multiple db instances we would have the following env vars

```bash
INSTANCES="instance1-example.com,instance2-example.com"  #(cloudflared proxied url's)
BASE_PORT=5432
CF_SERVICE_AUTH_ID=XXXXXXX.access
CF_SERVICE_AUTH_SECRET=XXXXXXXXXXX
```
