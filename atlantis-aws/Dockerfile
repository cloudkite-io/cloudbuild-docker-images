FROM ghcr.io/runatlantis/atlantis:v0.28.1

USER root
RUN apk --no-cache --update add jq python3 py3-pip nodejs npm
RUN python3 -m venv etc/pyvenv
RUN source etc/pyvenv
RUN pip install awscli --upgrade
RUN deactivate
USER atlantis