# Configurando Spark

## Instalando

```
cd ~/spark
echo "#" >> ~/.profile 
echo "export SPARK_HOME=~/spark" >> ~/.profile 
echo "export PATH=\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$PATH" >> ~/.profile
echo "#" >> ~/.profile 
export SPARK_HOME=~/spark
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
cp conf/spark-defaults.conf.template conf/spark-defaults.conf
cp conf/spark-env.sh.template conf/spark-env.sh
```

Devemos então descomentar as linhas em `conf/spark-defaults.conf`. Podemos usar o comando `vi` para isso.

Devemos descomentar também as linhas `conf/spark-env.sh`.

Iniciando o Cluster

```

cd ~/spark/sbin
start-master.sh # Starts a master instance on the machine the script is executed on (The master machine).
start-slaves.sh # Starts a slave instance on each machine specified in the conf/slaves file.
```

O arquivo `$SPARK_HOME/conf/slaves` deve conter o seguinte a lista de hosts que servirão de **Workers** para o Spark:
