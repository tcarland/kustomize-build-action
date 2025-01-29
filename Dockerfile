FROM ubuntu:22.04
ARG kustomize_version=v5.6.0

LABEL description="kustomize-build-action"
LABEL version="1.2.0"
LABEL author="Timothy C. Arland <tcarland at gmail dot com>"

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
