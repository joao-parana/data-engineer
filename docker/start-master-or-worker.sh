#!/bin/bash

set -e

echo "`date` - Iniciando o ENTRYPOINT" > /home/spark/logs/log.stdout
echo "`date` - Iniciando o ENTRYPOINT" > /usr/local/wff-gateway/logs/log.stdout
# O user spark é quem vai manipular o arquivo
chown -R spark:spark /home/spark/logs /usr/local/wff-gateway/logs
# $HOST_NAME pode ser algo como: spark-master, spark-worker1, spark-worker2, ...
HOST_NAME=`uname -n`

# Esta bash funciona como Entrypoint. O Master deve ser iniciado antes dos Workers

# Ela detecta se é Master ou Worker e faz o procedimento necessário 

# No Master habilita NFS server. Também invoca sbin/start-master.sh

# No worker abilita NFS client. Também invoca sbin/start-worker.sh

if [[ $HOST_NAME == *"master"* ]]; then
  echo "`date` - Este é o Master"  >> /home/spark/logs/log.stdout
fi
if [[ $HOST_NAME == *"worker"* ]]; then
  echo "`date` - Este é um dos Workers"  >> /home/spark/logs/log.stdout
fi
service spark start
service wffgateway start
# Copiando binários executáveis gerados à partir do $GOPATH/bin
# A cópia não é necessária pois o executável está no $PATH
cp $GOPATH/bin/fwd_cmd /spark/DATA
cp $GOPATH/bin/to_upper /spark/DATA
sleep 3
ps -ef | grep spark >> /home/spark/logs/log.stdout
sleep 10000000 # dorme 27.000 horas
