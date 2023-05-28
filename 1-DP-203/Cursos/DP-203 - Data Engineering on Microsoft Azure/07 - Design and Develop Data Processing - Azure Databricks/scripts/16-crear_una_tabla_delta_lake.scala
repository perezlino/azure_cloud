// Lab - Creando una tabla Delta Lake

// Así que el Databricks Runtime 8.X en adelante utiliza automáticamente "delta lake" como formato de 
// tabla por defecto. Así que creando una tabla, no necesariamente tienes que decirle que sea una tabla 
// delta. Este es el formato de tabla por defecto que se utilizará.

import org.apache.spark.sql.functions._

spark.conf.set(
    "fs.azure.account.key.datalake2000.dfs.core.windows.net",
    dbutils.secrets.get(scope="data-lake-key",key="datalake2000"))

val df = spark.read.format("json")
.options(Map("inferSchema"->"true","header"->"true"))
.load("abfss://data@datalake2000.dfs.core.windows.net/raw/PT1H.json")

// Crear una tabla delta lake

df.write.format("delta").mode("overwrite").saveAsTable("metrics")

%sql

SELECT * FROM metrics

// Si desea acelerar las consultas que hacen uso de predicados que implican columnas de partición
// Si utiliza, por ejemplo, 'metricName' en la condición WHERE

df.write.partitionBy("metricName").format("delta").mode("overwrite").saveAsTable("partitionedmetrics")

%sql

SELECT metricName,count(*) FROM partitionedmetrics
GROUP BY metricName
