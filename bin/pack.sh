#!/usr/bin/env bash
# This file is distributed under the terms of the MIT license, (c) the KSLib team

# The purpose of this file is to decrease size of .ks files for the final flight. However, please upload 
# UNPACKED versions of programs to KSLib.

# This version works in Unix environments.

# Run this file while being in your scripts directory. Please make a separate directory called "packed" - this
# is where your modified scripts will go.
set -ex
find boot m p -type f | while read file; do
    echo "$file"
    dir=$(dirname "$file")
    mkdir -p "packed/$dir"
    if [[ "${file##*.}" = "ks" ]]; then
        # the first line strips comments
        # the second line strips leading whitespace
        # the third line strips trailing whitespace
        sed \
            -e 's/^\(\([^"]*\)\("[^"]*"[^"]*\)*\)\/\/.*/\1/g' \
            -e 's/^\( \|\t\)*//g' \
            -e 's/\( \|\t\)*$//g' \
            "$file" > "packed/$file"
    else
        cp "$file" "packed/$file"
    fi
done
