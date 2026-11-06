FROM cloudflare/cloudflared:1315-645e22744c07

FROM alpine:3.24.4
RUN apk upgrade --no-cache
COPY --from=0 /usr/local/bin/cloudflared /usr/local/bin/cloudflared
COPY start-script.sh .
RUN  chmod +x start-script.sh
CMD ./start-script.sh