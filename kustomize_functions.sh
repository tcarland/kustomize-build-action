#!/usr/bin/env bash
#
version="v1"
kustomize_dir="."


function parseInputs()
{
    if [ -n "$INPUT_KUSTOMIZE_DIR" ]; then
        kustomize_dir="$INPUT_KUSTOMIZE_DIR"
    fi
}


function kustomizeBuild()
{
    echo "build: info: kustomize build ${kustomize_dir}"

    if [ -z "${kustomize_dir}" ]; then
        echo "build: error: kustomize directory not specified"
        return 1
    fi

    output=$( kustomize build "${kustomize_dir}" )

    build_exit_code=$?

    if [ $build_exit_code -ne 0 ]; then
        echo "build: error: kustomize build failed with exit code $build_exit_code"
    else
        echo "build: info: kustomize build succeeded"
    fi

    return $build_exit_code
}
