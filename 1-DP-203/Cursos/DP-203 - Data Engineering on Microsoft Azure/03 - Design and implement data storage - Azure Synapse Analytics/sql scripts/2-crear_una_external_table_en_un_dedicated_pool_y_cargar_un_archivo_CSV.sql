-- Laboratorio - Dedicated SQL Pool - External Tables - CSV

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd@123';

-- Aqui estamos usando la Storage account key (Access key) para la autorización

CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
  IDENTITY = 'datalake2000',
  SECRET = 'VqJnhlUibasTfhSuAxkgIgY97GjRzHL9VNOPkjD8y+KYzl1LSDCflF6LXlrezAYKL3Mf1buLdZoJXa/38BXLYA==';

-- En el Dedicated SQL pool, podemos utilizar drivers Hadoop para mencionar la source

CREATE EXTERNAL DATA SOURCE log_data
WITH (    LOCATION   = 'abfss://data@datalake2000.dfs.core.windows.net', -- abfss: Utilizando el protocolo que se va a utilizar para acceder a la cuenta de almacenamiento Data Lake Gen2
          CREDENTIAL = AzureStorageCredential,                           -- data: es el nombre del contenedor
          TYPE = HADOOP                                                  -- datalake200: es el nombre de la cuenta de almacenamiento Data Lake Gen2
)

CREATE EXTERNAL FILE FORMAT TextFileFormat WITH (  
      FORMAT_TYPE = DELIMITEDTEXT,  
      FORMAT_OPTIONS (  
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2))


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
	[Resourcegroup] [varchar](1000) NULL
)
WITH (
 LOCATION = '/raw/Log.csv',          --> En la carpeta 'material' tengo dos archivos "Log.csv" 
    DATA_SOURCE = log_data,          --> Ahi dos archivos para explicar un error que nos devuelve el campo 'Time' 
    FILE_FORMAT = TextFileFormat     --> Son los archivos 'Log1.csv' y 'Log2.csv'
)

SELECT * FROM logdata --> Al utilizar el archivo 'Log1.csv' nos devuelve el siguiente error:

-- Msg 107090, Level 16, State 1, Line 49
-- HdfsBridge::RecordReaderFillBuffer - Unexpected error encountered filling record reader buffer: HadoopSqlException: Error converting data type VARCHAR to DATETIME

--> Al utilizar el archivo 'Log2.csv' (donde se realizo un 'Data cleansing' o 'Data cleaning' de ese campo en particular con ADF) ya no devuelve el error.

SELECT [Operation name] , COUNT([Operation name]) as [Operation Count]
FROM logdata
GROUP BY [Operation name]
ORDER BY [Operation Count]