# Start with the OpenJDK 8 base image
FROM openjdk:8-jdk

# Set environment variables for Ant
ENV ANT_VERSION 1.10.11
ENV ANT_HOME /opt/ant

# Download and install Ant
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar xvfvz apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt \
    && ln -sfn /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && sh -c 'echo ANT_HOME=/opt/ant >> /etc/environment' \
    && ln -sfn /opt/ant/bin/ant /usr/bin/ant \
    && rm apache-ant-${ANT_VERSION}-bin.tar.gz

# Install Node.js
RUN apt-get update \
    && apt-get install -y nodejs npm \
    && apt-get clean

# Install AWS CLI
RUN apt-get update \
    && apt-get install -y awscli \
    && apt-get clean

# Check versions of installed software
RUN ant -version \
    && node -v \
    && aws --version

# Provide a default command to execute the build
CMD ["ant"]