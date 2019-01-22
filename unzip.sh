#!/bin/sh

ZIPFILES=$(find . -name "*.zip")
echo ${ZIPFILES}

for ZIP in ${ZIPFILES} ; do
    unzip ${ZIP}
done
