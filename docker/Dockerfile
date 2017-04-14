FROM anapsix/alpine-java:8_jdk
#
# TODO: Avaliar a imagem frolvlad/alpine-oraclejdk8 que parece ser melhor
# pois trata o problema de java.net.InetAddress que não resolvia endereço IP
#

#
# Esta imagem da qual herdo as funcionalidades inclui Java JDK 8 da Oracle,
# e glibc-2.21. Sobre ela instalo o Bash, o Git e o cliente MySQL
#
# https://github.com/anapsix/docker-alpine-java/tree/master/8/jdk
#
MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2017-04-14

RUN apk upgrade --update && \
    apk add --update bash && \
    apk search gpg && \
    apk add gpgme && \
    apk add lsof logrotate mysql-client git curl

# usar apk add --no-cache no final.

ENV SPARK_HOME  /usr/local/spark

WORKDIR /desenv/DATA

RUN mkdir -p $SPARK_HOME/bin

# Para compilar fontes Java com encoding UTF-8
ENV JAVA_TOOL_OPTIONS "-Dfile.encoding=UTF8"

ENV WFF_JDBC_USER wff
ENV WFF_JDBC_PASS xyz_639
# URL para MySQL obedece a gamática abaixo:
# jdbc:mysql://[host1][:port1][,[host2][:port2]]...[/[database]] [?propertyName1=propertyValue1[&propertyName2=propertyValue2]...]
ENV WFF_JDBC_URL  jdbc:mysql://mysql:3306/wff

RUN mkdir /jars
ADD shared /jars
ADD bin /tmp/install/bin 
ADD build-R-spark /tmp/install/build-R-spark

# RUN export CLASSPATH=$(find /jars -name '*.jar' -printf '%p:' | sed 's/:$//')
# RUN export CLASSPATH=$(find /jars -name '*.jar' -printf '%p:').
# RUN export CLASSPATH=$(JARS=(/jars/*.jar); IFS=:; echo "${JARS[*]}")
# RUN export CLASSPATH=$(echo /jars/*.jar | tr ' ' ':')
ENV WFF_CLASSPATH "$(echo /jars/*.jar | tr ' ' ':')"
COPY conf/.bash_profile /etc/profile.d/wff_profile

# RUN /tmp/install/bin/install-R

# RUN cd /tmp/install/build-R-spark/R && ls && \
#     tar xzf R-3.3.3.tar.gz && \
#     cd R-3.3.3 && echo "Instalando o R no diretório /usr/local/R"
# RUN apk add gcc gfortran
RUN cp /tmp/install/build-R-spark/R/R-3.3.1-r0.apk .
# wget https://github.com/sgerrand/alpine-pkg-R/releases/download/3.3.1-r0/R-3.3.1-r0.apk && \
RUN apk add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-R/releases/download/3.3.1-r0/sgerrand.rsa.pub && \
    apk add R-3.3.1-r0.apk
# RUN apk add R R-dev
# RUN cd /tmp/install/build-R-spark/R/R-3.3.3 && \
#     ./configure --prefix=/usr/local/R --with-readline=no --with-x=no && \
#     make && make install
RUN ls -la /usr/bin/R

# RUN /tmp/install/bin/install-Python

RUN apk add python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools

# RUN /tmp/install/bin/install-Spark

RUN cd /tmp/install/build-R-spark/spark && ls && \
    tar xzf spark-2.1.0-bin-hadoop2.7.tgz && \
    ls -la /usr/local/ && \
    mv spark-2.1.0-bin-hadoop2.7 spark && \
    mv spark /usr/local/ &&\
    mkdir -p /usr/local/spark/tmp

ADD conf/spark-defaults.conf /usr/local/spark/conf/
ADD conf/spark-env.sh /usr/local/spark/conf

# Spark
EXPOSE 7077
# WEB UI para Master
EXPOSE 8080
# WEB UI para Slave
EXPOSE 8081

CMD ["/bin/bash"]




