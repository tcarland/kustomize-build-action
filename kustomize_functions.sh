#!/usr/bin/env bash
#
version="v1"
kustomize_dir="."


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "$0  is being executed directly."
    echo " It is intended to be sourced by the shell"
    exit 1
fi


# kustomize wrapper for auto-detecting helm charts
function kustom()
{
    local action=
    local target=
    local yml=
    local helm="false"
    local args=()

    args+=("$@")
    if [ ${#args[@]} -eq 2 ]; then
        action=${args[0]}
        target=${args[1]}
        args=("${args[@]:2}")
    fi

    if [ -r $target/base/kustomization.yaml ]; then
        yml=$target/base/kustomization.yaml
    elif [ -r $target/../../base/kustomization.yaml ]; then
        yml=$target/../../base/kustomization.yaml
    elif [ -r $target/kustomization.yaml ]; then
        yml=$target/kustomization.yaml
    fi

    if [[ $(yq e 'has("helmCharts")' $yml) == "true" ]]; then
        action="$action --enable-helm"
    fi

    ( \kustomize $action $target ${args[@]} )

    return $?
}


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

    output=$( kustom build "${kustomize_dir}" )

    build_exit_code=$?

    if [ $build_exit_code -ne 0 ]; then
        echo "kustomizeBuild() error: build failed with exit code $build_exit_code"
    else
        echo "kustomizeBuild() info: build succeeded"
    fi

    return $build_exit_code
}
