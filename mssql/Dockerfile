# Use the base image from xrow-public helm-mssql which uses mssql 2022
FROM registry.gitlab.com/xrow-public/helm-mssql/mssql:1.2.0

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        jq \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/mssql/scripts

COPY --chmod=755 scripts/*.sh /opt/mssql/scripts/

ENV PATH="/opt/mssql/scripts:${PATH}"

# Switch back to mssql user for security
USER mssql

