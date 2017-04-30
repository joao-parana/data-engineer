#!/bin/bash

set -e

# Esta bash inicia os conteineres Master e 3 Workers
echo "`date` - Esta bash inicia 4 conteiners: o Master e 3 Workers"
echo "`date` - Os conteineres são iniciados no modo background."
echo "`date` - Use o comando 'docker exec <contêiner-id> bash' para entrar no bash do contêiner"

echo "`date` - Criando a network spark"
# limpando networks inúteis criadas anteriormente
docker network prune -f
# criando uma Network para o Spark usar entre os contêineres
docker network create spark 
# listando as Networks existentes
echo "`date` - listando as Networks existentes"
docker network ls

echo "`date` - Iniciando o Contêiner do Master"
docker run --rm --name spark-master -h spark-master \
           --network=spark \
           -p 19092:19092 \
           -p 7077:7077 -p 8080:8080 \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash

echo "`date` - Iniciando os contêineres Workers"
docker run --rm --name spark-worker1 -h spark-worker1 -p 8081:8081 \
           --network=spark \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
docker run --rm --name spark-worker2 -h spark-worker2 -p 8082:8081 \
           --network=spark \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
docker run --rm --name spark-worker3 -h spark-worker3 -p 8083:8081 \
           --network=spark \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash

echo "`date` - Listando os contêineres em execução e os parados"
docker ps -a 

