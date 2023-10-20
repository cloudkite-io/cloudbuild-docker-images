FROM ubuntu:18.04
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV DOCKER_COMPOSE_VERSION 2.23.0
ARG GIT_CRYPT_VERSION=0.7.0
ENV GIT_CRYPT_VERSION=$GIT_CRYPT_VERSION
ARG HELM_VERSION=3.13.1
ENV HELM_VERSION=$HELM_VERSION
ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN apt-get update && apt-get install -y \
  bash \
  curl \
  g++ \
  git \
  gnupg \
  make \
  python3 \
  openssh-client \
  openssl \
  libssl-dev
## Install git-crypt
RUN curl -L https://github.com/AGWA/git-crypt/archive/$GIT_CRYPT_VERSION.tar.gz | tar zxv -C /var/tmp && \
  cd /var/tmp/git-crypt-$GIT_CRYPT_VERSION && make && cp /var/tmp/git-crypt-$GIT_CRYPT_VERSION/git-crypt /usr/local/bin/git-crypt
# Install gcloud & kubectl
RUN curl https://sdk.cloud.google.com | bash            \
  && mkdir -p /opt                                      \
  && mv /root/google-cloud-sdk /opt                     \
  && gcloud components install beta kubectl
## Install helm
RUN mkdir /tmp/helm                                      \
  && cd /tmp/helm                                        \
  && curl -s https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf - \
  && cp /tmp/helm/linux-amd64/helm /usr/local/bin/helm   \
  && chmod +x /usr/local/bin/helm                        \
  && rm -rf /tmp/helm
ADD helm-rollback.bash /helm-rollback.bash
ADD helm.bash /helm.bash
ENTRYPOINT ["/helm.bash"]
