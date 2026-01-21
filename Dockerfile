FROM debian:12.13-slim
ARG RELEASE_VERSION=""

# kustomize
ARG kustomize_url="https://github.com/kubernetes-sigs/kustomize/releases/download"
ARG kustomize_version="v5.8.0"
ARG kustomize_path="kustomize%2F${kustomize_version}"
# helm
ARG helm_url="https://get.helm.sh"
ARG helm_version="v3.18.6"

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


# kustomize
RUN curl -L ${kustomize_url}/${kustomize_path}/kustomize_${kustomize_version}_linux_amd64.tar.gz | \
    tar xvz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/kustomize

# Helm
RUN curl -L ${helm_url}/helm-${helm_version}-linux-amd64.tar.gz | \
    tar xvz -C /tmp/ && \
    mv /tmp/linux-amd64/helm /usr/local/bin/ && \
    chmod +x /usr/local/bin/helm

RUN mkdir -p /action
COPY . /action

ENTRYPOINT [ "/action/entrypoint.sh" ]

