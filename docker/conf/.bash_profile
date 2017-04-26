#!/bin/bash

alias wff_classpath="$(echo /jars/*.jar | tr ' ' ':')"
export WFF_CLASSPATH=$(echo /jars/*.jar | tr ' ' ':')
# export PATH=/usr/local/wff-gateway/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
# alias wff='spark-shell --packages "br.cefet-rj.eic:wff:0.5.0" --master spark://spark-master.:7077' 
alias wff='spark-shell --master spark://spark-master.:7077' 
# alias wff-gateway='cd /usr/local/wff-gateway/bin && java -cp . -jar wff-gateway.jar go'
alias gateway='ps -ef | grep wff-gateway.jar'
alias start-gw='su - spark --command "/usr/local/wff-gateway/bin/start-wff-gateway.sh"'
