#!/bin/bash

set -e

docker run --rm --name spark-master.local -p 7077:7077 -p 8080:8080 -v $PWD/DATA:/spark/DATA -i -t parana/wff bash

docker run --rm --name spark-worker1.local -p 8081:8081  -v $PWD/DATA:/spark/DATA -i -t parana/wff bash

docker run --rm --name spark-worker2.local -p 8081:8082  -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
