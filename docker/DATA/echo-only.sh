#!/bin/sh
while read LINE; do
   echo "Worker on $HOSTNAME,${LINE}"
done

