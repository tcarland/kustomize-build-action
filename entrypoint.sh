#!/usr/bin/env bash
#
#  entrypoint.sh
cwd=$(dirname "$(readlink -f "$0")")

source "$cwd/kustomize_functions.sh"
alias kustomize="kustom"

parseInputs
kustomizeBuild

exit $?
