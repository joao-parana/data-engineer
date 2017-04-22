tar -czf some-org-apache.tar.gz repository/org/apache/spark repository/org/apache/hadoop repository/org/apache/commons repository/org/apache/maven repository/org/apache/parquet repository/org/apache/ivy 

tar -czf org-without-scala.tar.gz repository/org --exclude=repository/org/apache/spark --exclude=repository/org/apache/hadoop --exclude=repository/org/apache/commons --exclude=repository/org/apache/maven --exclude=repository/org/apache/parquet --exclude=repository/org/apache/ivy   --exclude=repository/org/scala-lang

tar -czf scala.tar.gz repository/org/scala-lang repository/com repository/io repository/net repository/br

rm -rf repository/org repository/com repository/io repository/net repository/br

tar -czf outros.tar.gz repository/*
