#!/bin/bash

INPUT=../data/day5input.txt
LANGUAGES=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name data ! -name doc)

echo Running examples in $LANGUAGES on input $INPUT - this will take various hours!

for d in $LANGUAGES
do
    LANG=$(basename $d)
    ./runone.sh $INPUT $LANG > day5-$LANG.log &
done
