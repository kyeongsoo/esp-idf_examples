#!/bin/bash
#
# ESP-IDF multi-target build helper
# Bash port of the PowerShell version
#

# Add 'tools' to PATH
export PATH="$PATH:$(dirname "$(realpath "${BASH_SOURCE[0]}")")/tools"

# Define build functions
idf_s3() {
    idf.py -B build_s3 -DSDKCONFIG="build_s3/sdkconfig.s3" "$@"
}

idf_c3() {
    idf.py -B build_c3 -DSDKCONFIG="build_c3/sdkconfig.c3" "$@"
}

idf_c6() {
    idf.py -B build_c6 -DSDKCONFIG="build_c6/sdkconfig.c6" "$@"
}

# Clean function with target validation
idf_clean() {
    local target="all"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            s3|c3|c6|all)
                target="$1"
                shift
                ;;
            *)
                echo "Error: Invalid target '$1'. Use: s3, c3, c6, or all" >&2
                return 1
                ;;
        esac
    done

    local targets_to_clean=()
    if [[ "$target" == "all" ]]; then
        targets_to_clean=(build_s3 build_c3 build_c6)
    else
        targets_to_clean=("build_$target")
    fi

    for folder in "${targets_to_clean[@]}"; do
        if [[ -d "$folder" ]]; then
            echo "Nuking directory: $folder..."
            rm -rf "$folder"
            echo "Successfully cleaned $folder."
        else
            echo "Folder $folder does not exist, skipping."
        fi
    done
}