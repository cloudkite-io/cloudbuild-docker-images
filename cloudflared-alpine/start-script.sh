#!/bin/sh
IFS=","
ITER=0
for instance in $INSTANCES
do
   cloudflared access tcp --id $ATLANTIS_CF_SERVICE_AUTH_ID --secret $ATLANTIS_CF_SERVICE_AUTH_ID  --hostname $instance --url "http://127.0.0.1:$(expr $BASE_PORT + $ITER)"&
done