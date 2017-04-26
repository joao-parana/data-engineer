#!/bin/bash

set -e

cd /usr/local/wff-gateway/bin
echo "`date` - Iniciando o Gateway do WfF em `pwd`" > ../log.stdout
env >> ../log.stdout
java -cp . -jar wff-gateway.jar go  >> ../log.stdout 2> ../log.stderr &
echo "`date` - Gateway do WfF iniciado em background. Não dá pra saber se ficou OK." >> ../log.stdout
echo "`date` - Use ps -ef | grep wff-gateway.jar para verificar o processo" >> ../log.stdout
