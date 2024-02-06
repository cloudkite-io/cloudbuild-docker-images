#!/bin/sh
IFS=","
ITER=0
for instance in ${INSTANCES}
do
  if [[ $instance == *":"* ]]; then
    cloudflared access tcp --id "${CF_SERVICE_AUTH_ID}" --secret "${CF_SERVICE_AUTH_SECRET}"  --hostname "${instance%:*}" --url "tcp://${TUNNEL_ADDRESS:-127.0.0.1}:${instance#*:}"&
  else
    cloudflared access tcp --id "${CF_SERVICE_AUTH_ID}" --secret "${CF_SERVICE_AUTH_SECRET}"  --hostname "${instance}" --url "tcp://${TUNNEL_ADDRESS:-127.0.0.1}:$(expr ${BASE_PORT} + ${ITER})"&
    ITER=$(expr ${ITER} + 1)
  fi
done
sleep infinity
