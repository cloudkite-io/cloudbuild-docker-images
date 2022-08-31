FROM alpine 
ARG HELM_VERSION=3.2.0
ARG AZURE_CLI_VERSION=2.39.0
ENV HELM_VERSION=$HELM_VERSION
ENV AZURE_CLI_VERSION=$AZURE_CLI_VERSION

RUN apk --no-cache --update add \
  bash \
  curl \
  yq \
  git \
  py3-pip

RUN apk add --virtual=build \
  gcc \
  libffi-dev \
  musl-dev \
  openssl-dev \
  python3-dev

RUN pip install azure-cli==${AZURE_CLI_VERSION} && apk del --purge build

RUN mkdir /tmp/helm                                      \
  && cd /tmp/helm                                        \
  && curl -s https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf - \
  && cp /tmp/helm/linux-amd64/helm /usr/local/bin/helm   \
  && chmod +x /usr/local/bin/helm                        \
  && rm -rf /tmp/helm