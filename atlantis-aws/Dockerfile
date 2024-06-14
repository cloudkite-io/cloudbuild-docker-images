FROM ghcr.io/runatlantis/atlantis:v0.28.1

USER root
RUN apk --no-cache --update add jq python3 py3-pip nodejs npm && \
  pip3 install pipx && \
  pipx install awscli --upgrade
USER atlantis