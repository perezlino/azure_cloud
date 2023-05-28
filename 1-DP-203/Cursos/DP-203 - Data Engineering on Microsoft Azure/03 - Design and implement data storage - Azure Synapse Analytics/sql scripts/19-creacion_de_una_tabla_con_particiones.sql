-- Lab - Creación de una tabla con particiones

DROP TABLE [logdata]

CREATE TABLE [logdata]
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

COPY INTO logdata FROM 'https://datalake2000.blob.core.windows.net/data/cleaned/Log.csv'
WITH
(
FIRSTROW=2
)

-- Primero inspeccionemos nuestra tabla para ver el rango de fechas

SELECT 
	FORMAT(Time,'yyyy-MM-dd') AS dt,
	COUNT(*) 
FROM 
	logdata
GROUP BY 
	FORMAT(Time,'yyyy-MM-dd')

-- Vamos a eliminar la tabla existente si existe
DROP TABLE logdata


-- Vamos a crear una nueva tabla con particiones
CREATE TABLE [logdata]
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
WITH
(
PARTITION ( [Time] RANGE RIGHT FOR VALUES
            ('2021-04-01','2021-05-01','2021-06-01')

   )  
)

-- Asi se distribuyen las particiones

Particion 1: Todas las fechas < 2021-04-01
Particion 2: 2021-04-01 a 2021-04-30
Particion 3: 2021-05-01 a 2021-05-31
Particion 4: 2021-06-01 a 2021-06-30


-- Copiar datos en la tabla
COPY INTO logdata FROM 'https://datalake2000.blob.core.windows.net/data/cleaned/Log.csv'
WITH
(
FIRSTROW=2
)

-- Visualizar las particiones
SELECT  QUOTENAME(s.[name])+'.'+QUOTENAME(t.[name]) as Table_name
,       i.[name] as Index_name
,       p.partition_number as Partition_nmbr
,       p.[rows] as Row_count
,       p.[data_compression_desc] as Data_Compression_desc
FROM    sys.partitions p
JOIN    sys.tables     t    ON    p.[object_id]   = t.[object_id]
JOIN    sys.schemas    s    ON    t.[schema_id]   = s.[schema_id]
JOIN    sys.indexes    i    ON    p.[object_id]   = i.[object_Id]
                            AND   p.[index_Id]    = i.[index_Id]
WHERE t.[name] = 'logdata'

SELECT o.name, pnp.index_id, pnp.partition_id, pnp.rows,   
    pnp.data_compression_desc, pnp.pdw_node_id  
FROM sys.pdw_nodes_partitions AS pnp  
JOIN sys.pdw_nodes_tables AS NTables  
    ON pnp.object_id = NTables.object_id  
AND pnp.pdw_node_id = NTables.pdw_node_id  
JOIN sys.pdw_table_mappings AS TMap  
    ON NTables.name = TMap.physical_name 
    AND substring(TMap.physical_name,40, 10) = pnp.distribution_id 
JOIN sys.objects AS o  
    ON TMap.object_id = o.object_id  
WHERE o.name = 'logdata'  
ORDER BY o.name, pnp.index_id, pnp.partition_id;  