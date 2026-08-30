FROM debian:12.13-slim
ARG RELEASE_VERSION="v2.0.1"

# kustomize
ARG kustomize_url="https://github.com/kubernetes-sigs/kustomize/releases/download"
ARG kustomize_version="v5.8.1"
ARG kustomize_path="kustomize%2F${kustomize_version}"
# kubectl
ARG kubectl_url="https://storage.googleapis.com/kubernetes-release/release" 
ARG kubectl_version="v1.31.0"
# yq
ARG yq_url="https://github.com/mikefarah/yq/releases/download"
ARG yq_version="v4.53.6"
# helm
ARG helm_url="https://get.helm.sh"
ARG helm_version="v3.19.4"

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

# kustomize
RUN curl -L ${kustomize_url}/${kustomize_path}/kustomize_${kustomize_version}_linux_amd64.tar.gz | \
    tar xvz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/kustomize

# kubectl
RUN curl -L ${kubectl_url}/${kubectl_version}/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# yq
RUN curl -L ${yq_url}/${yq_version}/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# Helm
RUN curl -L ${helm_url}/helm-${helm_version}-linux-amd64.tar.gz | \
    tar xvz -C /tmp/ && \
    mv /tmp/linux-amd64/helm /usr/local/bin/ && \
    chmod +x /usr/local/bin/helm

RUN mkdir -p /action
COPY . /action

ENTRYPOINT [ "/action/entrypoint.sh" ]
