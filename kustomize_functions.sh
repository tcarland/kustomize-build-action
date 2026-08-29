#!/usr/bin/env bash
#
version="v2"
kustomize_dir="."


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "$0  is being executed directly."
    echo " It is intended to be sourced by the shell"
    exit 1
fi


function hasHelm()
{
    local target="$1"
    local yml=

    if [ -r $target/base/kustomization.yaml ]; then
        yml=$target/base/kustomization.yaml
    elif [ -r $target/../../base/kustomization.yaml ]; then
        yml=$target/../../base/kustomization.yaml
    elif [ -r $target/kustomization.yaml ]; then
        yml=$target/kustomization.yaml
    fi

    if [[ $(yq e 'has("helmCharts")' $yml) == "true" ]]; then
        return 0
    fi

    return 0
}


function parseInputs()
{
    if [ -n "$INPUT_KUSTOMIZE_DIR" ]; then
        kustomize_dir="$INPUT_KUSTOMIZE_DIR"
    fi
}


function kustomizeBuild()
{
    local args=("build")
    local build_exit_code=
    
    if [ -z "${kustomize_dir}" ]; then
        echo "kustomizeBuild() error: kustomize directory not specified"
        return 1
    fi

    if hasHelm "$kustomize_dir"; then
        args+=("--enable-helm")
    fi

    echo "kustomizeBuild() info: 'kustomize ${args[@]} ${kustomize_dir}'"

    output=$( kustomize ${args[@]} "${kustomize_dir}" )
    build_exit_code=$?

    if [ $build_exit_code -ne 0 ]; then
        echo "kustomizeBuild() error: build failed with exit code $build_exit_code"
    else
        echo "kustomizeBuild() info: build succeeded"
    fi

    return $build_exit_code
}


function kubectlBuild()
{
    local args=("kustomize")
    local build_exit_code=
    
    if [ -z "${kustomize_dir}" ]; then
        echo "kustomizeBuild() error: kustomize directory not specified"
        return 1
    fi

    if hasHelm "$kustomize_dir"; then
        args+=("--enable-helm")
    fi

    echo "kubectlBuild() info: 'kubectl ${args[@]} ${kustomize_dir}'"
   
    output=$(kubectl ${args[@]} ${kustomize_dir})
    
    if [ $build_exit_code -ne 0 ]; then
        echo "kubectlBuild() error: build failed with exit code $build_exit_code"
    else
        echo "kubectlBuild() info: build succeeded"
    fi

    return $build_exit_code
}
