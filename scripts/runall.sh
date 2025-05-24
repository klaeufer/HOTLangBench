#!/bin/bash

LANGUAGES=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name data ! -name doc ! -name scripts)

./scripts/runone.sh dryrun-results.csv ../data/day5example.txt $LANGUAGES
