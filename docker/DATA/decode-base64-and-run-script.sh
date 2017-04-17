#!/bin/sh
SCRIPT=$SCRIPT_TO_RUN
MY_SCRIPT=${SCRIPT:-$(echo "/spark/DATA/print-msg.sh")}
# Se SCRIPT_TO_RUN não for informado emite mensagem de erro na saida 
while read LINE; do
   DECODED=`echo ${LINE} | base64 --decode`
   echo $DECODED | $MY_SCRIPT
done
