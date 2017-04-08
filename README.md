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

Uma sessão do Spark em Scala pode ser criada assim:

```bash
spark-shell --master local[4] --packages "br.cefet-rj.eic:wff:0.5.0"
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

Outro exemplo:

```bash

```


