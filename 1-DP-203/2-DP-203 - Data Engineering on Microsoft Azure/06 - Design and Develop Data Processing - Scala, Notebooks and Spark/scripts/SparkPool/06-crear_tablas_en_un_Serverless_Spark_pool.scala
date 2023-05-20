
// Spark Pool - Creación de tablas
// Aquí estamos creando una tabla en el metastore del Spark pool

// Ahora, recuerda, no vas a almacenar tus datos en estas tablas. Esto sólo significa, ya sabes, tener tablas 
// temporales en su lugar si quieres realizar un análisis. Pero el beneficio de crear una tabla aquí, una tabla 
// Spark aquí, es que el metastore es compartido no sólo entre tu Spark Pool, sino también entre el Serverless SQL Pool.

%%spark
val df = spark.read.sqlanalytics("newpool.dbo.logdata") 
df.write.mode("overwrite").saveAsTable("logdatainternal")

// A continuación, podemos hacer referencia a la tabla mediante comandos SQL

%%sql

SELECT * FROM logdatainternal