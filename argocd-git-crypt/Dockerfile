FROM argoproj/argocd:v2.3.4

# Switch to root for the ability to perform install
USER root

ARG GIT_CRYPT_VERSION=0.6.0-1build2
ENV GIT_CRYPT_VERSION=$GIT_CRYPT_VERSION

RUN apt-get update \
 && apt-get install -y git-crypt=$GIT_CRYPT_VERSION \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mv /usr/bin/git /usr/bin/git.bin
COPY git /usr/bin/git

# Switch back to non-root user
USER 999
