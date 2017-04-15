#!/bin/bash

set -e

echo "Execute os comandos abaixo, um em cada janela de Terminal diferente"
echo "docker run --rm --name spark-worker1 -h spark-worker1.local -p 8081:8081  -v \$PWD/DATA:/spark/DATA -i -t parana/wff bash"
echo "docker run --rm --name spark-worker2 -h spark-worker2.local -p 8082:8081  -v \$PWD/DATA:/spark/DATA -i -t parana/wff bash"
echo "docker run --rm --name spark-worker3 -h spark-worker3.local -p 8083:8081  -v \$PWD/DATA:/spark/DATA -i -t parana/wff bash"
echo "docker run --rm --name spark-master  -h spark-master.local --link spark-worker1 --link spark-worker2  --link spark-worker3 -p 7077:7077 -p 8080:8080 -v \$PWD/DATA:/spark/DATA -i -t parana/wff bash"
echo "No conteiner spark-master.local faça:\ncat /etc/hosts\nAgora copie os ultimas linhas para os outros /et/chosts"
