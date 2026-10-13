FROM ubuntu:26.04
# Rebuild once the critical vulnerabilities are resolved
# CVE-2026-56857 & CVE-2026-78663

RUN apt update && apt install postgresql-client-18 awscli \ 
    nano telnet apt-transport-https ca-certificates curl \
    gnupg-agent software-properties-common unzip less -y
