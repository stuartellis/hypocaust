ARG DOCKER_IMAGE_BASE=python:3.9-slim-bullseye

#===== BASE =====

FROM ${DOCKER_IMAGE_BASE} as base_python
LABEL org.opencontainers.image.authors="Stuart Ellis <stuart@stuartellis.name>"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove && \
    apt-get clean

#===== BUILDER =====

FROM base_python as builder
LABEL org.opencontainers.image.authors="Stuart Ellis <stuart@stuartellis.name>"

LABEL org.opencontainers.image.version=0.1.0
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Toolbox Container" \ 
  org.opencontainers.image.description="Linux shell and tools"

ENV PYTHONUNBUFFERED=1

RUN apt-get -y --no-install-recommends install \ 
    build-essential \
    apt-utils \
    python-dev && \
    apt-get clean

ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv /opt/venv
RUN pip install --upgrade --no-cache-dir \
    setuptools \
    wheel \
    pip-tools

COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

#===== APP =====

FROM base_python as app
LABEL org.opencontainers.image.authors="Stuart Ellis <stuart@stuartellis.name>"

LABEL org.opencontainers.image.version=0.1.0

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Toolbox Container" \ 
  org.opencontainers.image.description="Linux shell and tools"

RUN groupadd --gid 1000 appusers \
  && useradd --uid 1000 --gid appusers --shell /bin/bash --create-home appuser

RUN mkdir /app && chown -R appuser:appusers /app

RUN apt-get -y --no-install-recommends install \
    postgresql-client && \
    apt-get clean

COPY --from=builder --chown=appuser:appusers /opt/venv /opt/venv
COPY --chown=appuser:appusers ./makedb /app

WORKDIR /app
USER appuser
ENV PATH="/opt/venv/bin:/home/appuser/.local/bin:$PATH"
ENV PYTHONUNBUFFERED 1
