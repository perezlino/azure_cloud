// Lab - Spark Pool - Creación de tablas

// Las tablas son básicamente tablas basadas en Parquet
// Esto se puede hacer con el comando SQL
// El formato datetime no está disponible
// Tipos de datos - https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/table#expose-a-spark-table-in-sql
%%sql
CREATE DATABASE internaldb
CREATE TABLE internaldb.customer(Id int,name varchar(200)) USING Parquet

%%sql
INSERT INTO internaldb.customer VALUES(1,'UserA')

%%sql
SELECT * FROM internaldb.customer


// Si desea cargar los datos del archivo log.csv y luego guardarlos en una tabla
%%pyspark
df = spark.read.load('abfss://data@datalake2000.dfs.core.windows.net/raw/Log.csv', format='csv'
, header=True
)
df.write.mode("overwrite").saveAsTable("internaldb.logdatanew")

%%sql
SELECT * FROM internaldb.logdatanew
