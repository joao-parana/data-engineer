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


