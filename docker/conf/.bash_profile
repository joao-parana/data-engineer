#!/bin/bash
alias wff_classpath="$(echo /jars/*.jar | tr ' ' ':')"
export WFF_CLASSPATH=$(echo /jars/*.jar | tr ' ' ':')
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
alias wff='spark-shell --packages "br.cefet-rj.eic:wff:0.5.0"' 