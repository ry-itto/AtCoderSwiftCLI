#! /bin/bash
format_files=$(git status --porcelain | 
    awk '{print $2}' | 
    grep -e ".swift$")

echo '=== Format these Swift files ==='
for file in ${format_files[@]};
do
    echo $file
done

echo $format_files |
    xargs mint run swift-format format -i
