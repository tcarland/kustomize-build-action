#!/usr/bin/env bash
#

kustomize_dir="."


function parseInputs()
{
    if [ -n "$INPUT_KUSTOMIZE_DIR" ]; then
        kustomize_dir="$INPUT_KUSTOMIZE_DIR"
    fi
    if [ -n "$INPUT_KUSTOMIZE_OUTPUT_FILE" ]; then
        kustomize_output_file="$INPUT_KUSTOMIZE_OUTPUT_FILE"
    fi
}


function kustomizeBuild()
{
    echo "build: info: kustomize build ${kustomize_dir}"

    output=$( kustomize build "${kustomize_dir}" )

    build_exit_code=$?

    if [ $build_exit_code -ne 0 ]; then
        echo "build: error: kustomize build failed with exit code $build_exit_code"
    else
        echo "build: info: kustomize build succeeded"
        echo "kustomize_build_output=$output" >> $GITHUB_OUTPUT
    fi

    return $build_exit_code
}
