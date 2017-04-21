# Rodando em Contêiner Docker

## Baixando os binários

```bash
cd bin
# Executar uma única vez o comando abaixo
./get-binaries-and-sources
cd ..
```

## Criando a imagem Docker

```bash
./build-docker-image.sh
```

## Iniciando os Conteineres

### Iniciando os Conteineres dos Workers 3, 2 e 1 ...

**Para cada um dos Workers** abre-se uma janela de Terminal independente e executa-se em cada uma delas os comandos:

```bash
docker run --rm --name spark-worker1 -h spark-worker1 -p 8081:8081 \
            -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
```

```bash
docker run --rm --name spark-worker2 -h spark-worker2 -p 8082:8081 \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
```

```bash
docker run --rm --name spark-worker3 -h spark-worker3 -p 8083:8081 \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
```


### Iniciando o Contêiner do Master 

Abre-se uma janela de Terminal e executa-se:

```bash
docker run --rm --name spark-master -h spark-master \
           -p 9090:9090 \
           -p 7077:7077 -p 8080:8080 \
           -v $PWD/DATA:/spark/DATA -i -t parana/wff bash
```

### Listando os Contêineres

O comando abaixo mostra os contêineres carregados na memória.

```bash
docker ps
```


O comando abaixo mostra todos os contêineres incluindo os que não estão em execução.

```bash
docker ps -a
```

## Iniciando o Cluster

#### Configuração de DNS e Network

No computador Host (macOS, por exemplo), faça:

```bash
# limpando networks inúteis criadas anteriormente
docker network prune
# criando uma Network para o Spark usar entre os contêineres
docker network create spark 
# listando as Networks existentes
docker network ls
# conectando os contêineres a Network criada
docker network connect spark spark-master
docker network connect spark spark-worker1
docker network connect spark spark-worker2
docker network connect spark spark-worker3
# desconectando os contêineres da Network bridge criada pelo comando docker run
docker network disconnect bridge spark-master
docker network disconnect bridge spark-worker1
docker network disconnect bridge spark-worker2
docker network disconnect bridge spark-worker3
# inspecionando os contêineres
docker inspect --format='' spark-master | python -m json.tool | egrep "IPAddress\"|\"Gateway"
docker inspect --format='' spark-worker1 | python -m json.tool | egrep "IPAddress\"|\"Gateway"
docker inspect --format='' spark-worker2 | python -m json.tool | egrep "IPAddress\"|\"Gateway"
docker inspect --format='' spark-worker3 | python -m json.tool | egrep "IPAddress\"|\"Gateway"
```

Para testar podemos usar o `ping` dentro dos contêineres, pingando o Master.

```bash
ping spark-master -c 3
```

Caso não funcione, podemos sempre executar uma alternativa via o Work-around abaixo:

No conteiner spark-master faça:

```bash
cat /etc/hosts
```

Agora copie os ultimas linhas do arquivo `/etc/hosts` para os outros `/etc/hosts` dos Workers. Pode-se usar o comando `vi` para isso.

**Atenção:** este Work-around só é necessário se o procedimento com o comando `docker network` descrito anteriormente, não funcionar !


### Iniciando o Master

Na janela de Terminal do Contêiner Master, executa-se:

```bash
# Desabilitar a interface de rede 
/usr/local/spark/sbin/start-master.sh
```

ou simplesmente `start-master.sh` pois o path `/usr/local/spark/sbin/` está no `$PATH`

O Spark Master usa o arquivo de configuração de log `org/apache/spark/log4j-defaults.properties` por padrão.


### Iniciando o Worker 3, 2 e 1 ...


Na janela de **cada um dos Workers** executa-se:

```bash
ping spark-master -c 3 # deve responder corretamente.
/usr/local/spark/sbin/start-slave.sh spark://spark-master:7077
```

### Iniciando o Driver via `spark-shell`

Como temos um ALIAS definido no Contêiner:

```bash
alias wff='spark-shell --packages "br.cefet-rj.eic:wff:0.5.0" --master spark://spark-master:7077'
```

Podemos abrir o terminal do **Contêiner Master** e executar

```bash
wff
```

Agora podemos invocar tasks pois o arquivo `spark-defaults.conf` configura,
entre outras coisas, o  `spark.master` apontando para `spark://spark-master:7077`

```bash
cat /usr/local/spark/conf/spark-defaults.conf
# conf/spark-defaults.conf

spark.master                     spark://spark-master:7077
spark.serializer                 org.apache.spark.serializer.KryoSerializer
spark.driver.memory              2g
```

## Monitorando o Master e os Workers

```bash
open http://localhost:8080
open http://localhost:8081
open http://localhost:8082
open http://localhost:8083
```

Isso abrirá 4 páginas no Browser.


# Anexo I

## Dinâmica da Inicialização do Master 

A titulo de informação adicional: quando executamos `start-master.sh` a shell é expandida para:

```
/usr/local/spark/sbin/spark-daemon.sh start org.apache.spark.deploy.master.Master 1 --host spark-master --port 7077 --webui-port 8080
```

Esta shell **aguarda até o limite de 5 segundos** num loop de execução do código 
`ps -p "$newpid" -o comm=` testando o resultado contra a string `java` e em seguida
dorme por dois segundos. Ao final desse intervalo verifica se o processo morreu.
No caso do processo morrer ele mostra o final do arquivo de log como feedback ao usuário.

A shell `spark-daemon.sh` por sua vez invoca um comando tal como este abaixo:

```
 nohup -- nice -n 0 /usr/local/spark/bin/spark-class org.apache.spark.deploy.master.Master --host spark-master --port 7077 --webui-port 8080
```

`spark-class` do diretório `/usr/local/spark/bin` é uma shell que:

1. Verifica $SPARK_HOME 
2. Verifica $JAVA_HOME
3. Ajusta a variável `$LAUNCH_CLASSPATH`
4. Constroi o comando usando a classe `org.apache.spark.launcher.Main`

O fonte da classe `Main` pode ser vista em : [https://github.com/apache/spark/blob/master/launcher/src/main/java/org/apache/spark/launcher/Main.java](https://github.com/apache/spark/blob/master/launcher/src/main/java/org/apache/spark/launcher/Main.java) 
e faz parte de um pacote de funcionalidades [https://github.com/apache/spark/blob/master/launcher/src/main/java/org/apache/spark/launcher/package-info.java](https://github.com/apache/spark/blob/master/launcher/src/main/java/org/apache/spark/launcher/package-info.java)
que permite invocar o Spark programaticamente.

O comando `ps -ef --width 250` mostra o comando final executado com todos os parâmetros. Veja abaixo:

```
$JAVA_HOME/bin/java -cp /usr/local/spark/conf/:/usr/local/spark/jars/* -Xmx1g org.apache.spark.deploy.master.Master --host spark-master --port 7077 --webui-port 8080
```
