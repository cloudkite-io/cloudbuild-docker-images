FROM node:lts-slim

RUN apt-get update && apt-get install -y \
    jq \
    git \
    zip \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    # Install AWS CLI
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws


CMD ["node"]