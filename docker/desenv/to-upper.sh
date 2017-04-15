#!/bin/sh
# touch to-upper.sh
while read LINE; do
   toupper=`echo ${LINE} | awk '{print toupper($0)}'`
   echo "Worker on $HOSTNAME,$toupper"
done