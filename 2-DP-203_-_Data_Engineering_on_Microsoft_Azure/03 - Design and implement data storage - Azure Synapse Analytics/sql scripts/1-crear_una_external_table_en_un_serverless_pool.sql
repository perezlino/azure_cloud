-- Laboratorio - Usar External tables
-- Desde la interfaz de Azure Synapse --> Develop --> SQL Script
-- En el menu horizontal superior --> Connect to --> Built-in (corresponde al Serverless pool)

-- Primero tenemos que crear una base de datos en el "serverless pool"
CREATE DATABASE [appdb]

-- Aquí creamos una database master key. Esta key se utilizará para proteger el Shared Access Signature el cual 
-- se especifica en el siguiente paso
-- Asegúrese de cambiar primero el contexto a la nueva base de datos (Utilizar y trabajar dentro de la nueva BBDD)

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd@123';

-- Aquí estamos utilizando el Shared Access Signature para autorizar el uso del Azure Data Lake Storage account

CREATE DATABASE SCOPED CREDENTIAL SasToken
WITH IDENTITY='SHARED ACCESS SIGNATURE'
, SECRET = 'sv=2020-02-10&ss=b&srt=sco&sp=rl&se=2021-06-26T14:34:27Z&st=2021-06-26T06:34:27Z&spr=https&sig=7nxID0JFYuddBCnNTsPoeyY%2BRZokkcgdSUSsrfmAkRc%3D';

-- Esto define el "source" de la data. 

CREATE EXTERNAL DATA SOURCE log_data
WITH (    LOCATION   = 'https://appdatalake7000.dfs.core.windows.net/data', -- "data" es el contenedor
          CREDENTIAL = SasToken
)

/* Esto crea un objeto External File Format que define los datos externos que pueden estar
presentes en Hadoop, Azure Blob storage o Azure Data Lake Store

Aqui con FIRST_ROW, estamos diciendo que por favor omita la primera fila porque contiene información de cabecera
*/

CREATE EXTERNAL FILE FORMAT TextFileFormat WITH (  
      FORMAT_TYPE = DELIMITEDTEXT,  
    FORMAT_OPTIONS (  
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2))

-- Aquí definimos la external table

CREATE EXTERNAL TABLE [logdata]
(
    [Id] [int] NULL,
	[Correlationid] [varchar](200) NULL,
	[Operationname] [varchar](200) NULL,
	[Status] [varchar](100) NULL,
	[Eventcategory] [varchar](100) NULL,
	[Level] [varchar](100) NULL,
	[Time] [datetime] NULL,
	[Subscription] [varchar](200) NULL,
	[Eventinitiatedby] [varchar](1000) NULL,
	[Resourcetype] [varchar](1000) NULL,
	[Resourcegroup] [varchar](1000) NULL)
WITH (
 LOCATION = '/raw/Log.csv', -- "raw" es un directorio que se encuentra dentro del contenedor "data"
    DATA_SOURCE = log_data,  
    FILE_FORMAT = TextFileFormat
)

-- Si te has equivocado con la tabla, puedes eliminarla y volver a crearla.
DROP EXTERNAL TABLE [logdata]

/*
Errores comunes

1. External table 'logdata' is not accessible because location does not exist or it is used by another process. 
Aqui tu Shared Access Siganture es un problema. Asegúrese de crear la Shared Access Siganture correcta

2. Msg 16544, Level 16, State 3, Line 34
The maximum reject threshold is reached.
Esto ocurre cuando se intenta seleccionar las filas de datos de la tabla. Esto puede ocurrir si las filas no coinciden con el esquema definido para la tabla.


*/

SELECT * FROM [logdata]


SELECT [Operation name] , COUNT([Operation name]) as [Operation Count]
FROM [logdata]
GROUP BY [Operation name]
ORDER BY [Operation Count]