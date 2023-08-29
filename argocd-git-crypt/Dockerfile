FROM argoproj/argocd:v2.5.6

# Switch to root for the ability to perform install
USER root

ARG GIT_CRYPT_VERSION=0.6.0-1ubuntu1
ENV GIT_CRYPT_VERSION=$GIT_CRYPT_VERSION

RUN apt-get update \
 && apt-get install -y git-crypt=$GIT_CRYPT_VERSION curl\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mv /usr/bin/git /usr/bin/git.bin
COPY git /usr/bin/git

# install docker-credential-gcr
ENV VERSION=2.1.14
ENV OS=linux  
ENV ARCH=amd64

RUN curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" -o docker-credential-gcr \
    && tar xzf docker-credential-gcr && chmod +x docker-credential-gcr && mv docker-credential-gcr /usr/bin/

# Switch back to non-root user
USER 999
