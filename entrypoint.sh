#!/usr/bin/env bash
#  entrypoint
cwd=$(dirname "$(readlink -f "$0")")

source "$cwd/kustomize_functions.sh"
alias kustomize="kustom"

parseInputs
kustomizeBuild
kubectlBuild

exit $?
