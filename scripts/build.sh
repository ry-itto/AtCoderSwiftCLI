#! /bin/bash

swift build -c release
if [ $? -gt 0 ]; then
    echo 'Build failed. Clean .build and re-run.'
    rm -rf .build
    swift build -c release
fi
