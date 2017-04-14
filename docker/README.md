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
docker build -t parana/wff .
```

## Iniciando o Contêiner

```bash
docker run -i -t parana/wff bash
```

O contêiner vai entrar executando a shell Bash onde podemos inspecionar

```bash
find  /tmp/install/build-R-spark
env | egrep "JAVA|HOME|WFF" | sort
```

que mostra o seguinte:

```bash
HOME=/root
JAVA_HOME=/opt/jdk
JAVA_JCE=standard
JAVA_PACKAGE=jdk
JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
JAVA_VERSION_BUILD=13
JAVA_VERSION_MAJOR=8
JAVA_VERSION_MINOR=121
SPARK_HOME=/usr/local/spark
WFF_CLASSPATH=$(echo /jars/*.jar | tr :)
WFF_JDBC_PASS=xyz_639
WFF_JDBC_URL=jdbc:mysql://mysql:3306/wff
WFF_JDBC_USER=wff
```

Observe que `WFF_CLASSPATH` não foi expandida mantendo ainda o código bash.
É preciso descobrir como fazer com que o Docker expanda a expressão `echo /jars/*.jar | tr :` no momento do Build.

```bash
pwd
ls -lat
```
