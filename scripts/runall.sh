#!/bin/bash

LANGUAGES=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name data ! -name doc)

./runone.sh ../data/day5example.txt $LANGUAGES
