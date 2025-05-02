#!/bin/bash

# Create webp directory if it doesn't exist
mkdir -p img/webp

# Find all jpg files in img directory and convert them
for file in img/*.jpg; do
    if [ -f "$file" ]; then
        filename=$(basename -- "$file")
        filename_noext="${filename%.*}"
        cwebp -q 50 -quiet "$file" -o "img/webp/${filename_noext}.webp"
        echo "Converted $filename to ${filename_noext}.webp"
    fi
done