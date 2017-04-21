FROM java:openjdk-8

#
# TODO: Avaliar a imagem frolvlad/alpine-oraclejdk8 que parece ser melhor
# pois trata o problema de java.net.InetAddress que não resolvia endereço IP
#

#
# Esta imagem da qual herdo as funcionalidades inclui Debian Jessie.
# Sobre ela instalo o Git, o Maven, o Python, o R, o Spark e o cliente MySQL
#
# https://github.com/anapsix/docker-alpine-java/tree/master/8/jdk
#

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2017-04-14

# apk search gpg && \
# apk add -y  gpgme
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

# RUN export CLASSPATH=$(find /jars -name '*.jar' -printf '%p:' | sed 's/:$//')
# RUN export CLASSPATH=$(find /jars -name '*.jar' -printf '%p:').
# RUN export CLASSPATH=$(JARS=(/jars/*.jar); IFS=:; echo "${JARS[*]}")
# RUN export CLASSPATH=$(echo /jars/*.jar | tr ' ' ':')
ENV WFF_CLASSPATH "$(echo /jars/*.jar | tr ' ' ':')"
COPY conf/.bash_profile /etc/profile.d/wff_profile

# RUN /tmp/install/bin/install-Python

RUN apt-get install -y python
# RUN python -m ensurepip
# RUN rm -r /usr/lib/python*/ensurepip
# RUN pip install --upgrade pip setuptools

# RUN /tmp/install/bin/install-R

# RUN cd /tmp/install/build-R-spark/R && ls && \
#     tar xzf R-3.3.3.tar.gz && \
#     cd R-3.3.3 && echo "Instalando o R no diretório /usr/local/R"
# RUN apt-get install -y  gcc gfortran
# RUN cp /tmp/install/build-R-spark/R/R-3.3.1-r0.apk .
# wget https://github.com/sgerrand/alpine-pkg-R/releases/download/3.3.1-r0/R-3.3.1-r0.apk && \
# RUN apt-get install -y  ca-certificates wget && \
#     wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-R/releases/download/3.3.1-r0/sgerrand.rsa.pub && \
#     apt-get install -y  R-3.3.1-r0.apk
# # RUN apt-get install -y  R R-dev
# RUN cd /tmp/install/build-R-spark/R/R-3.3.3 && \
#     ./configure --prefix=/usr/local/R --with-readline=no --with-x=no && \
#     make && make install

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
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && rm -rf /var/lib/apt/lists/*
  

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

ADD maven/pom.xml /desenv/maven/pom.xml
ADD maven/wff-0.5.0.jar /desenv/maven/wff-0.5.0.jar

ADD gateway /tmp/gateway
RUN ls -la /tmp/gateway/ && \
    echo "`date` - tar -tvf /tmp/gateway/wff-gateway-install.tar" && \
    tar -tvf /tmp/gateway/wff-gateway-install.tar && \
    mkdir -p /usr/local/wff-gateway/bin && \
    cd /usr/local/wff-gateway/bin && \
    tar -xzf /tmp/gateway/wff-gateway-install.tar

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
    echo "••• `date` - WfF instalado localmente com sucesso." && \
    echo "••• `date` - Fazendo o build de projeto simples." && \
    echo "••• `date` - O Download dos artefatos pode demorar vários minutos, por favor aguarede !" && \
    mvn -q -Dmaven.test.skip=true clean install && \
    echo "••• `date` - Terminou o Download dos artefatos do maven !"

ADD conf/slaves /usr/local/spark/conf/

ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

# Spark
EXPOSE 7077
# WEB UI para Master
EXPOSE 8080
# WEB UI para Slave
EXPOSE 8081

VOLUME /spark/DATA

# Devido a este erro abaixo, temos que instalar procps
# BusyBox v1.24.2 - ps: unrecognized option: p
# RUN apt-get install -y  procps

CMD ["/bin/bash"]




