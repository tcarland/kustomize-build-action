FROM debian:12.12-slim
ARG kustomize_version=v5.8.0
ARG RELEASE_VERSION=

LABEL org.opencontainers.image.authors="Timothy C. Arland <tcarland at gmail dot com>" \
      org.opencontainers.image.description="Kustomize GitHub Action" \
      org.opencontainers.image.source="https://github.com/tcarland/kustomize-build-action" \
      org.opencontainers.image.title="kustomize-build-action" \
      org.opencontainers.image.version="${RELEASE_VERSION}"
      
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    tini

RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${kustomize_version}/kustomize_${kustomize_version}_linux_amd64.tar.gz \
    | tar xz -C /usr/local/bin

RUN mkdir -p /action
COPY . /action

ENTRYPOINT [ "/action/entrypoint.sh" ]

