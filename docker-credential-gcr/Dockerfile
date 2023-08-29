FROM alpine:3.18.3
ENV VERSION=2.1.14
ENV OS=linux  
ENV ARCH=amd64
RUN apk add 
RUN apk add --no-cache --update curl \
    && curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" -o docker-credential-gcr \
    && tar xzf docker-credential-gcr && chmod +x docker-credential-gcr && mv docker-credential-gcr /usr/bin/

ENTRYPOINT ["sh", "-c", "docker-credential-gcr configure-docker --registries us-central1-docker.pkg.dev"]