# data-engineer

## Instalação : R, Python e Spark

* R Versão 3.3.3
* Python Versão 2.7.13
* Spark Versão 2.1.0 com suporte a Hadoop 2.7 usando Scala 2.11.8

Após clonar veja os maiores arquivos usando:

```
find  . -printf '%s %p\n'| sort -nr | head -20
```

ou no macOS

```
for i in G M K; do du -ah | grep [0-9]$i | sort -nr -k 1; done | head -n 11
```

