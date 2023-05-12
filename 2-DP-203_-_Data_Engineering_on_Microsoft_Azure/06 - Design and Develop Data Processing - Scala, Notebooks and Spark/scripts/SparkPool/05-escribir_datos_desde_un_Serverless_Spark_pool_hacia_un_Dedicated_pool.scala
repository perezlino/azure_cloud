// Lab - Spark Pool - Escribir datos en Azure Synapse

// Hay un conector entre Azure Synapse Spark Pool y Azure Synapse Dedicated SQL Pool
// Puedes escribir datos directamente en el Dedicated SQL Pool

// Aquí estamos indicando usar Spark Scala porque esta funcionalidad sólo funciona en Scala
%%Spark

// Es necesario importar las siguientes librerías
import com.microsoft.spark.sqlanalytics.utils.Constants
import org.apache.spark.sql.SqlAnalyticsConnector._


/* Primero leemos los datos del archivo Log.csv

Definimos primero el esquema para los datos del archivo

 Esto es porque la tabla va a ser creada automáticamente por nuestro comando write

 Y para ello queremos que los tipos de datos de las columnas reflejen correctamente los datos.

También puedes inferir el esquema

 */

import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._


val dataSchema = StructType(Array(
    StructField("Id", IntegerType, true),
    StructField("Correlationid", StringType, true),
    StructField("Operationname", StringType, true),
    StructField("Status", StringType, true),
    StructField("Eventcategory", StringType, true),
    StructField("Level", StringType, true),
    StructField("Time", TimestampType, true),
    StructField("Subscription", StringType, true),
    StructField("Eventinitiatedby", StringType, true),
    StructField("Resourcetype", StringType, true),
    StructField("Resourcegroup", StringType, true)))


val df = spark.read.format("csv").option("header","true").schema(dataSchema).load("abfss://data@datalake2000.dfs.core.windows.net/raw/Log.csv")

df.printSchema()

/* 

-- Aqui no indicamos ningun tipo de KEY dado que en Azure Synapse se genero un Linked service hacia Azure Data Lake Storage


1. Aquí la tabla no debe existir

2. Aquí vamos a transferir datos en el contexto del usuario Azure Admin - techsup1000@gmail.com
Este usuario debe ser agregado como un usuario Azure AD en Azure Synapse
Tambien el mismo usuario debe tener el 'Storage Blob Contributor Role' en la cuenta de almacenamiento adjunta al Synapse workspace

*/
/*Se puede utilizar lo siguiente para leer datos de una tabla del dedicated SQL pool
spark.read.sqlanalytics("<DBName>.<Schema>.<TableName>")

DBName: el nombre de la base de datos.
Schema: la definición del esquema, por ejemplo dbo.
TableName: el nombre de la tabla de la que se quieren leer los datos.
*/

/*Se puede utilizar lo siguiente para escribir datos en una tabla del dedicated SQL pool
df.write.sqlanalytics("<DBName>.<Schema>.<TableName>", <TableType>)

DBName: el nombre de la base de datos.
Schema: la definición del esquema, por ejemplo dbo.
TableName: nombre de la tabla de la que se quieren leer los datos.
TableType: especificación del tipo de tabla, que puede tener dos valores.
Constants.INTERNAL - Tabla gestionada (Managed table) en el dedicated SQL pool
Constantes.EXTERNAL - External table en el dedicated SQL pool

*/

import com.microsoft.spark.sqlanalytics.utils.Constants
import org.apache.spark.sql.SqlAnalyticsConnector._
df.write.
sqlanalytics("newpool.dbo.logdata", Constants.INTERNAL)