FROM debian:bullseye-20220801-slim

## Image metadata ##

LABEL org.opencontainers.image.version=0.1.0
LABEL org.opencontainers.image.authors="Stuart Ellis <stuart@stuartellis.name>"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Toolbox Container" \ 
  org.opencontainers.image.description="Linux shell and tools"

WORKDIR /home/user

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove && \
    apt-get clean

# Packages that are required by installers
RUN apt-get install -y curl sudo postgresql-client

RUN groupadd --gid 1000 tbusers \
  && useradd --uid 1000 --gid tbusers --shell /bin/bash --create-home tbuser
  
RUN echo '%tbusers ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER tbuser
WORKDIR /home/tbuser
