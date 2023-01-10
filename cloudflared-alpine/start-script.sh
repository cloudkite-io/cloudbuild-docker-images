#!/bin/sh
IFS=","
ITER=0
for instance in $INSTANCES
do
   cloudflared access tcp --id $CF_SERVICE_AUTH_ID --secret $CF_SERVICE_AUTH_SECRET  --hostname $instance --url "tcp://127.0.0.1:$(expr $BASE_PORT + $ITER)"&
   ITER=$(expr $ITER + 1)
done