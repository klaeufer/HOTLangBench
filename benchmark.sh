#!/bin/bash

LANGUAGES=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name data ! -name doc)

echo Running benchmarks for the full input - this will take various hours!

./runone.sh ../data/day5input.txt $LANGUAGES
