#!/bin/bash

ts=$(date +%s%N)
go run .
tt=$((($(date +%s%N) - $ts)/1000000))
echo "Wall time: $tt milliseconds"
