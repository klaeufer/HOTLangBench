#!/bin/bash

LANGUAGES=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name data ! -name doc ! -name scripts)

echo Building examples in $LANGUAGES

for d in $LANGUAGES
do
pushd $d
./build.sh
popd
done
