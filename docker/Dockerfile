FROM java:openjdk-8

#
# TODO: Avaliar a imagem frolvlad/alpine-oraclejdk8 que parece ser melhor
# pois trata o problema de java.net.InetAddress que não resolvia endereço IP
#

#
# Esta imagem da qual herdo as funcionalidades inclui Debian Jessie.
# Sobre ela instalo o Git, Maven, Python, R, Spark, GO, curl, gcc, wget, 
# mercurial e o cliente MySQL
#
# https://github.com/anapsix/docker-alpine-java/tree/master/8/jdk
#

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2017-04-22

RUN apt-get update && \  
    apt-get install -y lsof logrotate mysql-client git gcc make curl

# usar apt-get install -y  --no-cache no final.

ENV SPARK_HOME  /usr/local/spark

WORKDIR /desenv/DATA

# Para compilar fontes Java com encoding UTF-8
ENV JAVA_TOOL_OPTIONS "-Dfile.encoding=UTF8"

ENV WFF_JDBC_USER wff
ENV WFF_JDBC_PASS xyz_639
# URL para MySQL obedece a gamática abaixo:
# jdbc:mysql://[host1][:port1][,[host2][:port2]]...[/[database]] [?propertyName1=propertyValue1[&propertyName2=propertyValue2]...]
ENV WFF_JDBC_URL  jdbc:mysql://mysql:3306/wff

# RUN mkdir /jars
ADD shared /jars
ADD bin /tmp/install/bin 
ADD build-R-spark /tmp/install/build-R-spark

ENV WFF_CLASSPATH "$(echo /jars/*.jar | tr ' ' ':')"
COPY conf/.bash_profile /etc/profile.d/wff_profile

# RUN /tmp/install/bin/install-Python

RUN apt-get install -y python

RUN apt-get update \ 
  && apt-get install -y --no-install-recommends \
    ed \
    less \
    locales \
    vim-tiny \
    wget \
    ca-certificates \
    fonts-texgyre \
  && rm -rf /var/lib/apt/lists/*

# Instala o GO para criar um Web Server para testes de download distribuido
RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    mercurial \
    git-core

RUN curl -s https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz | tar -C /usr/local -xz

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN echo "••••• `date` - Verificando se existe debian-unstable.list : ls /etc/apt/sources.list.d/" && \
    ls -lat /etc/apt/sources.list.d/ && \
    echo "••••• `date` - Verificando se existe default:  ls /etc/apt/apt.conf.d/" && \
    ls -lat /etc/apt/apt.conf.d/

# Instalando o sudo
RUN apt-get update && apt-get install -y sudo

# Instalando NFS
RUN apt-get update && apt-get install -y nfs-kernel-server nfs-common

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
  && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default

ENV R_BASE_VERSION 3.3.3

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too

RUN apt-get update \
  && apt-get install -t unstable -y --no-install-recommends \
    littler \
    r-cran-littler \
    r-base=${R_BASE_VERSION}* \
    r-base-dev=${R_BASE_VERSION}* \
    r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
        && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
  && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
  && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
  && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
  && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
  && install.r docopt \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds 

RUN ls -la /usr/bin/R

# RUN /tmp/install/bin/install-Spark

RUN cd /tmp/install/build-R-spark/spark && ls && \
    tar xzf spark-2.1.0-bin-hadoop2.7.tgz && \
    echo "••• `date` - ls -la /usr/local/" && \
    ls -la /usr/local/ && \
    mv spark-2.1.0-bin-hadoop2.7 /usr/local/spark && \
    mkdir -p /usr/local/spark/tmp && \
    echo "••• `date` - ls -la /usr/local/spark" && \
    ls -la /usr/local/spark

ADD conf/spark-defaults.conf /usr/local/spark/conf/
ADD conf/spark-env.sh /usr/local/spark/conf/

ENV MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /usr/local/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

# http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN curl -O http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/local/mvn

ADD maven /desenv/maven

ADD gateway /tmp/gateway
RUN ls -la /tmp/gateway/ && \
    echo "`date` - tar -tvf /tmp/gateway/wff-gateway-install.tar" && \
    tar -tvf /tmp/gateway/wff-gateway-install.tar

RUN mkdir -p /usr/local/wff-gateway/bin && \
    mkdir -p /usr/local/wff-gateway/logs && \
    cd /usr/local/wff-gateway/bin && \
    tar -xf /tmp/gateway/wff-gateway-install.tar

ENV PATH /usr/local/wff-gateway/bin:$PATH


RUN cd /desenv/maven && \
    grep -B 2 -A 2 artifactId pom.xml && \
    echo "••• `date` - Instalando o WfF localmente" && \
    mvn -q install:install-file \
        -Dfile=wff-0.5.0.jar \
        -DgroupId=br.cefet-rj.eic \
        -DartifactId=wff \
        -Dversion=0.5.0 \
        -Dpackaging=jar && \
    echo "••• `date` - WfF instalado localmente com sucesso." 

RUN cd ~/.m2/ && \
    tar -xzf /desenv/maven/m2-repository/org-without-scala.tar.gz && \
    tar -xzf /desenv/maven/m2-repository/some-org-apache.tar.gz && \
    tar -xzf /desenv/maven/m2-repository/scala.tar.gz && \
    tar -xzf /desenv/maven/m2-repository/outros.tar.gz

RUN cd /desenv/maven && \
    echo "••• `date` - Fazendo o build de projeto simples." && \
    echo "••• `date` - O Download dos artefatos pode demorar vários minutos, por favor aguarede !" && \
    mvn -q -Dmaven.test.skip=true clean install && \
    echo "••• `date` - Terminou o Download dos artefatos do maven !"

ADD conf/slaves /usr/local/spark/conf/

ADD conf/etc/init.d /etc/init.d
ADD conf/start-wff-gateway.sh /usr/local/wff-gateway/bin/start-wff-gateway.sh

RUN echo "#" >> /etc/profile && \
    echo "# Suporte ao WfF" >> /etc/profile &&\
    echo "#" >> /etc/profile && \
    echo ". /etc/profile.d/wff_profile" >> /etc/profile && \
    echo "#" >> /etc/profile

ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

# Spark
EXPOSE 7077
# WEB UI para Master
EXPOSE 8080
# WEB UI para Slave
EXPOSE 8081

ENV GOPATH /desenv/maven
ENV GOROOT /usr/local/go
ENV PATH /usr/local/go/bin:/desenv/maven/bin:/usr/local/bin:$PATH

# Fazendo o build dos programas GO
RUN cd /desenv/maven && echo $GOPATH && \
    go get github.com/constabulary/gb/... && \
    $GOPATH/bin/gb build main/go/cmd/to_upper && \
    echo "••• `date` - Testando o programa compilado em GO" && \
    cat pom.xml | $GOPATH/bin/to_upper && \
    cd /desenv/maven/src && \
    $GOPATH/bin/gb build all

# flags possíveis para o comando 'test' podem ser vistos no link abaixo: 
# http://wiki.bash-hackers.org/commands/classictest
#
RUN if test -e $GOPATH/bin/fwd_cmd && \
       test -e /etc/init.d/wffgateway && \
       test -e /usr/local/wff-gateway/bin/wff-gateway.jar ; \
    then \
      echo "••• `date` - Forward de Comando para o Gateway habilitado"; \
    fi

VOLUME /spark/DATA

RUN groupadd spark && useradd -u 2017 -ms /bin/bash -r -g spark spark && usermod -aG root,mail spark

RUN MY_UID=`grep spark /etc/passwd | cut -d: -f3` && echo "`date` - Usuário spark criado e adicionando no grupo root. UID = $MY_UID"

RUN mkdir -p /home/spark/bin && mkdir -p /home/spark/logs && \
    chown -R spark:spark /usr/local/wff-gateway && \
    chown -R spark:spark /usr/local/spark && \
    chown -R spark:spark /home/spark
    
ADD conf/start-spark-cluster.sh /home/spark/bin/start-spark-cluster.sh
ADD conf/start-worker-number /home/spark/bin/start-worker-number

# RUN showmount -e mulder 

ADD start-master-or-worker.sh /bin/start-master-or-worker.sh

RUN chown -R spark:spark /home/spark/bin && \
    cat /home/spark/bin/start-spark-cluster.sh && \
    ls -lat /home/spark && \
    ls -lat /home/spark/bin && \
    ls -lat /home/spark/logs && \
    echo "`date` - Conteúdo de /spark/DATA em tempo de build" && \
    ls -lat /spark/DATA

# WEB UI para outros Slaves (limite de seis no total)
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084
EXPOSE 8085
EXPOSE 8086

ENTRYPOINT [ "/bin/start-master-or-worker.sh" ]
# CMD ["/bin/bash"]
