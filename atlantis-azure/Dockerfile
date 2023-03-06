FROM ghcr.io/runatlantis/atlantis:v0.23.2

RUN apk --no-cache --update add py3-pip jq git-crypt
RUN apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev
RUN pip install azure-cli && apk del --purge build
