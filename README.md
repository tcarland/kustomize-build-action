kustomize-build-action
======================
Author: Timothy C. Arland <tcarland at gmail dot com>


A custom GitHub Action for building [kustomize](https://github.com/kubernetes-sigs/kustomize) 
projects via a GitHub workflow.  

Kustomize Version: v5.7.1


## Inputs

- `kustomize_dir` - The action's only input; the target directory to build.

## Example Usage

A typical workflow yaml might look as follows:
```yaml
name: 'Kustomize Build Action'

on:
  push:
    tags: [ 'v*' ]
    branches: [ 'develop' ]
  pull_request:
    branches: [ 'master', 'main' ]

env:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Build
        uses: tcarland/kustomize-build-action@v1
        with:
          kustomize_dir: './manifests'
```
