FROM ghcr.io/runatlantis/atlantis:v0.33.0

USER root
RUN apk --no-cache --update add jq python3 py3-pip pipx nodejs npm && \
  pipx install awscli
USER atlantis
