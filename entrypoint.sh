#!/usr/bin/env bash
#
cwd=$(dirname "$(readlink -f "$0")")

source "$cwd/kustomize_functions.sh"

parseInputs
kustomizeBuild

exit $?