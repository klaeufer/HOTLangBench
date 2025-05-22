#!/bin/bash

ts=$(date +%s%N)
./day5
tt=$((($(date +%s%N) - $ts)/1000000))
echo "Wall time: $tt milliseconds"
