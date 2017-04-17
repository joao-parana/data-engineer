# Usando o método pipe do RDD

## Codificando em Base64

Nos exemplos abaixo cada linha é decodificada de base64 e passada adiante via pipe do BASH para o script 

```scala
// Forçando ocorrencia de erro na váriável de ambiente
// TODO: Falta tratar erro de script não existe dentro da shell decode-base64-and-run-script.sh
val dataRRDD = sc.makeRDD(List("QWxhZGRpbjpvcGVuIHNlc2FtZQ=="))
val piped = dataRRDD.pipe("/spark/DATA/decode-base64-and-run-script.sh", Map("XXX" -> "/spark/DATA/to-upper.sh"))
val result = piped.collect()
result.foreach(println)
```

Executando uma shell bash que faz **apenas um echo** para stdout.
Neste echo a shell coloca como prefixo o nome do HOST do cluster onde ela foi executada.
Lembre-se: Cada tupla do RDD pode rodar em _hosts_ diferentes. 

```scala
val dataRRDD = sc.makeRDD(List("QWxhZGRpbjpvcGVuIHNlc2FtZQ=="))
val env = Map("ENCODING" -> "Base64", SCRIPT_TO_RUN" -> "/spark/DATA/echo-only.sh")
val piped = dataRRDD.pipe("/spark/DATA/decode-base64-and-run-script.sh", env)
val result = piped.collect()
result.foreach(println)
```

Executando uma shell bash que faz apenas uma **conversão para maíusculos** e ecoa para stdout.
Neste echo a shell coloca como prefixo o nome do HOST do cluster onde ela foi executada.

```scala
val dataRRDD = sc.makeRDD(List("QWxhZGRpbjpvcGVuIHNlc2FtZQ=="))
val env = Map("ENCODING" -> "Base64", "SCRIPT_TO_RUN" -> "/spark/DATA/to-upper.sh")
val piped = dataRRDD.pipe("/spark/DATA/decode-base64-and-run-script.sh", env)
val result = piped.collect()
result.foreach(println)
```

![diagram-01](docs/images/diagram-01.png)

Outros esquemas de codificaçãopodem ser vistos a seguir

## Codificando com encodeURI

Este [site](http://meyerweb.com/eric/tools/dencoder/) permite converter de e para URLencode

Em Python temos esse exemplo:

```python
s = u"João Antônio 2017-04-01 12:37.0890 Ação"
print urllib.quote(s.encode("utf-8"))
Jo%C3%A3o%20Ant%C3%B4nio%202017-04-01%2012%3A37.0890%20A%C3%A7%C3%A3o
```

Podemos então invocar dessa forma:

```scala
val dataRRDD = sc.makeRDD(List("Aladdin%3Aopen%20sesame"))
val env = Map("ENCODING" -> "encodeURI", "SCRIPT_TO_RUN" -> "/spark/DATA/to-upper.sh")
val piped = dataRRDD.pipe("/spark/DATA/decodeURI-and-run-script.sh", env)
val result = piped.collect()
result.foreach(println)
```

## Abordagem gerando CSV na saida 

Nesta abordagem gera-se um CSV na saida com prefixo contendo nome do host
onde foi processado a atividade. Informa-se o nome do arquivo de entrada
`my-input.csv` e o sufixo para o nome de arquivo de saida `my-output.csv`.

Como não é conhecido a priori em qual host o processo Bash/R/Python seria
executado, coloca-se no nome do arquivo gerado um prefixo com o `$HOSTNAME`.
No caso deste host se chamar, por exemplo, `arietis` teremos como nome do arquivo de 
saida `arietis_my-output.csv`

val dataRRDD = sc.makeRDD(List("my-input.csv, my-output.csv"))
val piped = dataRRDD.pipe("/desenv/DATA/echo-only.sh")
val result = piped.collect()
result.foreach(println)


```scala
val dataRRDD = sc.makeRDD(List(
    "my-input-1.csv, my-output-1.csv",
    "my-input-2.csv, my-output-2.csv",
    "my-input-3.csv, my-output-3.csv",
    "my-input-4.csv, my-output-4.csv",
    "my-input-5.csv, my-output-5.csv",
    "my-input-6.csv, my-output-6.csv"
))
val piped = dataRRDD.pipe("/desenv/DATA/echo-only.sh")
val result = piped.collect()
result.foreach(println)
```

Veja um exemplo de execução 


```
Worker on aldebaran,my-input-1.csv, my-output-1.csv
Worker on arietis,my-input-2.csv, my-output-2.csv
Worker on aldebaran,my-input-3.csv, my-output-3.csv
Worker on arietis,my-input-4.csv, my-output-4.csv
Worker on aldebaran,my-input-5.csv, my-output-5.csv
Worker on aldebaran,my-input-6.csv, my-output-6.csv
```


