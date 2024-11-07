FROM ghcr.io/runatlantis/atlantis:v0.30.0

USER root

RUN apk --no-cache --update add py3-pip jq git-crypt
RUN apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev
RUN python3 -m venv azure && . azure/bin/activate && pip install azure-cli && apk del --purge build && deactivate

USER atlantis
