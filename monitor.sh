#!/bin/bash

echo The jobs corresponding to the following log files are still running:

lsof | egrep "day5-.*\.log" | cut -c114- | sort | uniq
