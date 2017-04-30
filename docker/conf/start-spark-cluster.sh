#!/bin/bash

set -e

cd /usr/local/spark
echo "`date` - Iniciando o Spark em `pwd`" >> /home/spark/logs/log.stdout
# $HOST_NAME pode ser algo como: spark-master, spark-worker1, spark-worker2, ...
HOST_NAME=`uname -n`
echo "`date` - hostname = $HOST_NAME" >> /home/spark/logs/log.stdout
env >> /home/spark/logs/log.stdout
if [[ $HOST_NAME == *"master"* ]]; then
  sbin/start-master.sh
fi
if [[ $HOST_NAME == *"worker"* ]]; then
  echo "`date` - Este é um dos Workers. É obrigado passar o identificador do master"
  sbin/start-slave.sh spark://spark-master:7077
fi
echo "`date` - Spark iniciado em background. Não dá pra saber se ficou OK." >> /home/spark/logs/log.stdout
echo "`date` - Use ps -ef | grep spark para verificar o processo" >> /home/spark/logs/log.stdout
