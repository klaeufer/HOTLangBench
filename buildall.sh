#!/bin/bash

LANGUAGES=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name data ! -name doc)

echo Building examples in $LANGUAGES

for d in */
do
pushd $d
./build.sh
popd
done
