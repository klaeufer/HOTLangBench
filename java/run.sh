#!/bin/bash

ts=$(date +%s%N)
mvn exec:java -Dexec.mainClass=Day5
tt=$((($(date +%s%N) - $ts)/1000000))
echo "Wall time: $tt milliseconds"
