FROM alpine as deployment
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV DOCKER_COMPOSE_VERSION 1.24.1
ENV HELM_VERSION 3.0.0-rc.4
ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
  bash \
  curl \
  python \
  openssh-client \
  openssl \
  openssl-dev
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
