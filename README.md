# data-engineer

## Instalação : R, Python e Spark

* R Versão 3.3.3
* Python Versão 2.7.13
* Spark Versão 2.1.0 com suporte a Hadoop 2.7 usando Scala 2.11.8

Após clonar veja os maiores arquivos usando:

```bash
find  . -printf '%s %p\n'| sort -nr | head -20
```

ou no macOS

```bash
for i in G M K; do du -ah | grep [0-9]$i | sort -nr -k 1; done | head -n 11
```

## Iniciando o Master

```bash
spark/sbin/start-master.sh
```

Você verá algo como mostrado abaixo indicando onde fica o arquivo de LOG

```
starting org.apache.spark.deploy.master.Master, logging to /home/spark/spark/logs/spark-spark-org.apache.spark.deploy.master.Master-1-my-host-master.out
```




## Iniciando os Workers

```bash
spark/sbin/start-slaves.sh 
```

Você verá algo como mostrado abaixo indicando onde fica o arquivo de LOG

```
my-worker-01.acme.com: starting org.apache.spark.deploy.worker.Worker, logging to /home/spark/spark/logs/spark-spark-org.apache.spark.deploy.worker.Worker-1-my-worker-01.out

. . .

```

Este arquivo de LOG especificado fica na máquina `my-worker-01` e é um dos Slaves.

## Usando o Spark

O diretório `/tmp/spark-events` deve existir

```bash
mkdir /tmp/spark-events
```


Uma sessão do Spark em Scala pode ser criada assim:

```bash
spark-shell --master spark://meu-master.acme.com:7077 --packages "br.cefet-rj.eic:wff:0.5.0"  --num-executors 2
```

Esta chamada acima carrega também a dependência definida como mostrado abaixo.

```xml
<groupId>br.cefet-rj.eic</groupId>
<artifactId>wff</artifactId>
<version>0.5.0</version>
```

As dependências são resolvidas pelo **Apache Ivy**. Os artefatos de meta informação e os JARS ficam repectivamente em `$HOME/.ivy2/cache` e `$HOME/.ivy2/jars`.

Os JARs podem ficar também em `$HOME/.m2/repository` quando tiver o Maven instalado na máquina e o Ivy copia para a área citada acima.

Você pode verificar usando:

```
find $HOME/.ivy2/cache
find $HOME/.ivy2/jars
find $HOME/.m2/repository -name "wff*.jar"
```

### Parâmetros úteis para o spark-shell

Veja esta seção da documentação: [http://spark.apache.org/docs/2.1.0/configuration.html#dynamically-loading-spark-properties](http://spark.apache.org/docs/2.1.0/configuration.html#dynamically-loading-spark-properties)

`spark-submit`  lê as configurações no arquivo `conf/spark-defaults.conf` que consiste de chave/valor separados por brancos e cada linha é uma propriedade. Por exemplo, no meu caso:

```bash
cat ~/spark/conf/spark-defaults.conf
# substitua meu-master.acme.com pelo endereço do seu servidor
spark.master                     spark://meu-master.acme.com:7077
spark.eventLog.enabled           true
# spark.eventLog.dir             hdfs://namenode:8021/directory
spark.serializer                 org.apache.spark.serializer.KryoSerializer
spark.driver.memory              2g
# spark.executor.extraJavaOptions  -XX:+PrintGCDetails -Dkey=value -Dnumbers="one two three"
```

Linhas com `#` no início são comentários


Outro exemplo:

```bash

```


