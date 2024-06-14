FROM ghcr.io/runatlantis/atlantis:v0.28.1

USER root
RUN apk --no-cache --update add jq python3 py3-pip pipx nodejs npm && \
  pipx install awscli --upgrade
USER atlantis