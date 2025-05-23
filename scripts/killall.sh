#!/bin/sh

pkill java
kill $(ps -ef | grep ay5 | cut -c10-17)
