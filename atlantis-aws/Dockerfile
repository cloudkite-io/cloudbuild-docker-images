FROM ghcr.io/runatlantis/atlantis:v0.28.1

USER root
RUN apk --no-cache --update add jq python3 py3-pip nodejs npm && \
    python3 -m venv etc/pyvenv && \
    source etc/pyvenv && \
    pip install awscli --upgrade && \
    deactivate
USER atlantis