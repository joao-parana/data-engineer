
import org.apache.spark.sql._
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder
import org.apache.spark.sql.types._

case class Person(name: String, age: Long)

// This import is needed to use the $-notation
import spark.implicits._

def runBasicDataFrameExample(spark: SparkSession): Unit = {
  // $example on:create_df$
  val df = spark.read.json("/desenv/DATA/people.json")
  // cat   /desenv/DATA/people.json
  // {"name":"Michael"}
  // {"name":"Andy", "age":30}
  // {"name":"Justin", "age":19}
  // Displays the content of the DataFrame to stdout
  df.show()

  // import spark.implicits._
  // Print the schema in a tree format
  df.printSchema()

  // Select only the "name" column
  df.select("name").show()

  // Select everybody, but increment the age by 1
  df.select($"name", $"age" + 1).show()

  // Select people older than 21
  df.filter($"age" > 21).show()

  // Count people by age
  df.groupBy("age").count().show()

  // Register the DataFrame as a SQL temporary view
  df.createOrReplaceTempView("people")

  val sqlDF = spark.sql("SELECT * FROM people")
  sqlDF.show()

  // Register the DataFrame as a global temporary view
  df.createGlobalTempView("people")

  // Global temporary view is tied to a system preserved database `global_temp`
  spark.sql("SELECT * FROM global_temp.people").show()

  // Global temporary view is cross-session
  spark.newSession().sql("SELECT * FROM global_temp.people").show()
}
runBasicDataFrameExample(spark)

def runDatasetCreationExample(spark: SparkSession): Unit = {
  import spark.implicits._
  // Encoders are created for case classes
  val caseClassDS = Seq(Person("Andy", 32)).toDS()
  caseClassDS.show()

  // Encoders for most common types are automatically provided by importing spark.implicits._
  val primitiveDS = Seq(1, 2, 3).toDS()
  primitiveDS.map(_ + 1).collect() // Returns: Array(2, 3, 4)

  // DataFrames can be converted to a Dataset by providing a class. Mapping will be done by name
  val path = "/desenv/DATA/people.json"
  val peopleDS = spark.read.json(path).as[Person]
  peopleDS.show()
}

runDatasetCreationExample(spark)

def runInferSchemaExample(spark: SparkSession): Unit = {
  // For implicit conversions from RDDs to DataFrames
  import spark.implicits._

  // Create an RDD of Person objects from a text file, convert it to a Dataframe
  val peopleDF = spark.sparkContext
    .textFile("/desenv/DATA/people.txt")
    .map(_.split(","))
    .map(attributes => Person(attributes(0), attributes(1).trim.toInt))
    .toDF()
  // Register the DataFrame as a temporary view
  peopleDF.createOrReplaceTempView("people")

  // SQL statements can be run by using the sql methods provided by Spark
  val teenagersDF = spark.sql("SELECT name, age FROM people WHERE age BETWEEN 13 AND 19")

  // The columns of a row in the result can be accessed by field index
  teenagersDF.map(teenager => "Name: " + teenager(0)).show()

  // or by field name
  teenagersDF.map(teenager => "Name: " + teenager.getAs[String]("name")).show()

  // No pre-defined encoders for Dataset[Map[K,V]], define explicitly
  implicit val mapEncoder = org.apache.spark.sql.Encoders.kryo[Map[String, Any]]
  // Primitive types and case classes can be also defined as
  // implicit val stringIntMapEncoder: Encoder[Map[String, Any]] = ExpressionEncoder()

  // row.getValuesMap[T] retrieves multiple columns at once into a Map[String, T]
  teenagersDF.map(teenager => teenager.getValuesMap[Any](List("name", "age"))).collect()
  // Array(Map("name" -> "Justin", "age" -> 19))
}

runInferSchemaExample(spark)

def runProgrammaticSchemaExample(spark: SparkSession): Unit = {
  import spark.implicits._
  // $example on:programmatic_schema$
  // Create an RDD
  val peopleRDD = spark.sparkContext.textFile("/desenv/DATA/people.txt")

  // The schema is encoded in a string
  val schemaString = "name age"

  // Generate the schema based on the string of schema
  val fields = schemaString.split(" ")
    .map(fieldName => StructField(fieldName, StringType, nullable = true))
  val schema = StructType(fields)

  // Convert records of the RDD (people) to Rows
  val rowRDD = peopleRDD
    .map(_.split(","))
    .map(attributes => Row(attributes(0), attributes(1).trim))

  // Apply the schema to the RDD
  val peopleDF = spark.createDataFrame(rowRDD, schema)

  // Creates a temporary view using the DataFrame
  peopleDF.createOrReplaceTempView("people")

  // SQL can be run over a temporary view created using DataFrames
  val results = spark.sql("SELECT name FROM people")

  // The results of SQL queries are DataFrames and support all the normal RDD operations
  // The columns of a row in the result can be accessed by field index or by field name
  results.map(attributes => "Name: " + attributes(0)).show()
}

runProgrammaticSchemaExample(spark)


