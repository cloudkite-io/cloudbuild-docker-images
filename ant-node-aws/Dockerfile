# Start with the Node.js 11 Alpine base image
FROM node:18-alpine

# Set environment variables for Ant
ENV ANT_VERSION 1.10.11
ENV ANT_HOME /opt/ant

RUN apk --no-cache add git openssh-client rsync bash python2 make g++ jq

# Install OpenJDK, Wget and AWS CLI dependencies
RUN apk --no-cache add openjdk8 wget python3 py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install awscli

# Download and install Ant
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar xvfvz apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt \
    && ln -sfn /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && sh -c 'echo ANT_HOME=/opt/ant >> /etc/environment' \
    && ln -sfn /opt/ant/bin/ant /usr/bin/ant \
    && rm apache-ant-${ANT_VERSION}-bin.tar.gz

# Provide a default command to execute the build
CMD ["ant"]
