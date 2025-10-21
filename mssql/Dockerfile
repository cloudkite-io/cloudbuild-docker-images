# Use the base image from xrow-public helm-mssql which uses mssql 2022
FROM registry.gitlab.com/xrow-public/helm-mssql/mssql:1.2.0

USER root

RUN yum install -y \
        curl \
        jq \
        ca-certificates && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN mkdir -p /opt/mssql/scripts

COPY --chmod=755 scripts/*.sh /opt/mssql/scripts/

ENV PATH="/opt/mssql/scripts:${PATH}"

# Switch back to mssql user for security
USER mssql

