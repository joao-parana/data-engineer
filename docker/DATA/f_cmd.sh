#!/bin/sh
while read LINE; do
  echo ${LINE}
  echo ${LINE} | curl telnet://127.0.0.1:9090
done
