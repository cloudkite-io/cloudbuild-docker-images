FROM alpine

RUN apk --no-cache --update add curl python3 wget py3-pip mysql-client jq
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN gcloud components install gke-gcloud-auth-plugin
