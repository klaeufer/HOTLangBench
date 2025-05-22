#!/bin/bash

INPUT=$1
LANGUAGES=${@:2}

echo Running examples in $LANGUAGES on input $INPUT

for d in $LANGUAGES
do

    pushd $d

    ts=$(date +%s%N)

    ./run.sh < $INPUT

    tt=$((($(date +%s%N) - $ts)/1000000))
    echo "walltime,$(basename $d),$tt,ms"

popd
done
