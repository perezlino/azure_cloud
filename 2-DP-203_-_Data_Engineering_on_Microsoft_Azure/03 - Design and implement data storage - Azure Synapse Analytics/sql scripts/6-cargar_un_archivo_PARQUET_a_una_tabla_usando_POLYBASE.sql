-- Lab - Cargar datos usando PolyBase en un Dedicated SQL Pool

-- Estos pasos no son necesarios volver a recrearlos, dado que ya los indicamos en un script anterior.
-- En el caso de que no lo hayamos hecho, debemos hacerlo.
-- Para verificar, utilizamos las sentencias SELECT indicadas en algunos pasos: SELECT * FROM sys. ....
 ______________________________________________________________________________________________________________
|                                                                                                              | 
|  CREATE LOGIN user_load WITH PASSWORD = 'Azure@123';                                                         | 
|                                                                                                              |   
| CREATE USER user_load FOR LOGIN user_load;                                                                   | 
|  GRANT ADMINISTER DATABASE BULK OPERATIONS TO user_load;                                                     | 
|  GRANT CREATE TABLE TO user_load;                                                                            | 
|  GRANT ALTER ON SCHEMA::dbo TO user_load;                                                                    |  
|                                                                                                              | 
|  CREATE WORKLOAD GROUP DataLoads                                                                             | 
|  WITH (                                                                                                      | 
|      MIN_PERCENTAGE_RESOURCE = 100                                                                           |   
|      ,CAP_PERCENTAGE_RESOURCE = 100                                                                          | 
|      ,REQUEST_MIN_RESOURCE_GRANT_PERCENT = 100                                                               | 
|      );                                                                                                      |  
|                                                                                                              | 
|  CREATE WORKLOAD CLASSIFIER [ELTLogin]                                                                       |   
|  WITH (                                                                                                      | 
|          WORKLOAD_GROUP = 'DataLoads'                                                                        | 
|      ,MEMBERNAME = 'user_load'                                                                               |     
|  );                                                                                                          | 
|                                                                                                              | 
|  -- Aquí estamos siguiendo el mismo proceso de creación de una tabla externa                                 |   
|                                                                                                              | 
|  CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd@123' ;                                                 |  
|                                                                                                              |  
|  -- Si deseas ver las database scoped credentials existentes                                                 |   
|  SELECT * FROM sys.database_scoped_credentials                                                               | 
|                                                                                                              | 
|  CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential                                                    |   
|  WITH                                                                                                        | 
|    IDENTITY = 'datalake2000',                                                                                |   
|    SECRET = 'VqJnhlUibasTfhSuAxkgIgY97GjRzHL9VNOPkjD8y+KYzl1LSDCflF6LXlrezAYKL3Mf1buLdZoJXa/38BXLYA==';      | 
|                                                                                                              | 
|  -- Si deseas ver las external data sources                                                                  | 
|  SELECT * FROM sys.external_data_sources                                                                     |   
|                                                                                                              |   
|                                                                                                              | 
|  CREATE EXTERNAL DATA SOURCE log_data                                                                        |   
|  WITH (    LOCATION   = 'abfss://data@datalake2000.dfs.core.windows.net',                                    |   
|            CREDENTIAL = AzureStorageCredential,                                                              | 
|            TYPE = HADOOP                                                                                     | 
|  )                                                                                                           | 
|                                                                                                              |       
|  -- Si deseas ver los external file formats                                                                  | 
|                                                                                                              |   
|  SELECT * FROM sys.external_file_formats                                                                     | 
|                                                                                                              | 
|  CREATE EXTERNAL FILE FORMAT parquetfile                                                                     | 
|  WITH (                                                                                                      |   
|      FORMAT_TYPE = PARQUET,                                                                                  | 
|      DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'                                          | 
|  );                                                                                                          | 
|                                                                                                              | 
|______________________________________________________________________________________________________________| 

-- Eliminar la tabla logdata
DROP TABLE [logdata]

-- Crear la tabla externa con el usuario admin

CREATE EXTERNAL TABLE [logdata_external]
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
 LOCATION = '/parquet/',
    DATA_SOURCE = log_data,  
    FILE_FORMAT = parquetfile
)

-- Ahora cree una tabla normal seleccionando todos los datos de la tabla externa
-- Así que usando Polybase, usted puede tomar ahora los datos de una tabla externa y empujarlos a una tabla interna 
-- en su Dedicated SQL Pool.

CREATE TABLE [logdata]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
CLUSTERED INDEX (id)   
)
AS
SELECT  *
FROM  [logdata_external];