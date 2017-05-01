#!/bin/sh
while read LINE; do
   ret_value=`echo ${LINE}`
   echo "Worker on `uname -n`,$ret_value"
done

