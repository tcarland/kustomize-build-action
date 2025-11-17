#!/usr/bin/env bash
#
version="v1"
kustomize_dir="."


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "$0  is being executed directly."
    echo " It is intended to be sourced by the shell"
    exit 1
fi


function parseInputs()
{
    if [ -n "$INPUT_KUSTOMIZE_DIR" ]; then
        kustomize_dir="$INPUT_KUSTOMIZE_DIR"
    fi
}

function kustomizeBuild()
{
    echo "kustomizeBuild() info: 'kustomize build ${kustomize_dir}'"

    if [ -z "${kustomize_dir}" ]; then
        echo "kustomizeBuild() error: kustomize directory not specified"
        return 1
    fi

    output=$( kustomize build "${kustomize_dir}" )

    build_exit_code=$?

    if [ $build_exit_code -ne 0 ]; then
        echo "kustomizeBuild() error: build failed with exit code $build_exit_code"
    else
        echo "kustomizeBuild() info: build succeeded"
    fi

    return $build_exit_code
}
