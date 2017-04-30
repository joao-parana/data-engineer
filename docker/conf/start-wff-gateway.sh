#!/bin/bash

set -e

cd /usr/local/wff-gateway/bin
echo "`date` - Iniciando o Gateway do WfF em `pwd`" >> ../logs/log.stdout
env >> ../logs/log.stdout
java -cp . -jar wff-gateway.jar go  >> ../logs/log.stdout 2> ../logs/log.stderr &
echo "`date` - Gateway do WfF iniciado em background. Não dá pra saber se ficou OK." >> ../logs/log.stdout
echo "`date` - Use ps -ef | grep wff-gateway.jar para verificar o processo" >> ../logs/log.stdout
