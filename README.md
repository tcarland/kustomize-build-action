kustomize-build-action
======================
Author: Timothy C. Arland <tcarland at gmail dot com>
Action Version: v1.3.0
Kustomize Version: v5.7.0

A custom GitHub Action for building [kustomize](https://github.com/kubernetes-sigs/kustomize) 
projects via a GitHub workflow.  

Note the version of this action matches the exact version of *kustomize*
being used by the action.

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
