FROM alpine:3.21.1

ARG AZURE_CLI_VERSION=2.67.0

RUN apk --no-cache --update add bash

RUN apk add --virtual=build \
  gcc \
  libffi-dev \
  musl-dev \
  openssl-dev \
  python3-dev

RUN python3 -m venv azure && . azure/bin/activate && pip3 install azure-cli==${AZURE_CLI_VERSION} && deactivate

COPY db-export-restore.sh .

RUN chmod +x db-export-restore.sh
