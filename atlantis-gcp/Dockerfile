FROM ghcr.io/runatlantis/atlantis:v0.34.0

USER root
ENV ARCH="x86_64"
ENV cloud_sdk_version="455.0.0"
RUN apk --no-cache upgrade && apk --no-cache add \
      jq \
      curl \
      python3 \
      py3-crcmod \
      py3-openssl \
      bash \
      libc6-compat \
      openssh-client \
      git \
      gnupg \
  && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${cloud_sdk_version}-linux-${ARCH}.tar.gz && \
  tar xzf google-cloud-cli-${cloud_sdk_version}-linux-${ARCH}.tar.gz && \
  rm google-cloud-cli-${cloud_sdk_version}-linux-${ARCH}.tar.gz

ENV PATH=$PATH:/google-cloud-sdk/bin

USER atlantis
