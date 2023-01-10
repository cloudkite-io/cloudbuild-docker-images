FROM cloudflare/cloudflared:1315-645e22744c07

FROM alpine
COPY --from=0 /usr/local/bin/cloudflared /usr/local/bin/cloudflared