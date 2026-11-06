FROM alpine:3.24.4
ARG HELM_VERSION=3.22.1
ARG AZURE_CLI_VERSION=2.92.0
ENV HELM_VERSION=$HELM_VERSION
ENV AZURE_CLI_VERSION=$AZURE_CLI_VERSION
ENV PATH="/opt/az/bin:$PATH"

RUN apk upgrade --no-cache && apk --no-cache add \
  bash \
  curl \
  yq \
  git \
  python3

# Alpine's Python is externally managed (PEP 668), so azure-cli goes in a venv
RUN apk add --no-cache --virtual=build \
  gcc \
  libffi-dev \
  musl-dev \
  openssl-dev \
  python3-dev \
  && python3 -m venv /opt/az \
  && /opt/az/bin/pip install --no-cache-dir azure-cli==${AZURE_CLI_VERSION} \
  && apk del --purge build

RUN mkdir /tmp/helm                                      \
  && cd /tmp/helm                                        \
  && curl -s https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf - \
  && cp /tmp/helm/linux-amd64/helm /usr/local/bin/helm   \
  && chmod +x /usr/local/bin/helm                        \
  && rm -rf /tmp/helm