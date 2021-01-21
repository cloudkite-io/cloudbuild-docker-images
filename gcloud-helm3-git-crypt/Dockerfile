FROM alpine
ENV GIT_CRYPT_VERSION 0.6.0
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV DOCKER_COMPOSE_VERSION 1.25.4
ENV HELM_VERSION 3.5.0
ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN apk add --no-cache --update \
  bash \
  curl \
  g++ \
  git \
  gnupg \
  make \
  python3 \
  openssh-client \
  openssl \
  openssl-dev
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
ADD helm.bash /helm.bash
ENTRYPOINT ["/helm.bash"]
