-- Lab - Cargar datos a una tabla dentro del Dedicated SQL Pool - COPY Command - Parquet

DROP TABLE [logdata]

-- Recrear la tabla
-- Aquí de nuevo estoy usando el tipo de datos con MAX porque así es como generé los archivos parquet cuando se trataba del tipo de datos
-- Aquí tenemos que especificar el clustered index basado en una columna, porque los índices no se pueden crear en varchar(MAX)

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

-- Conceda de nuevo los permisos. Porque cuando eliminas la tabla, también eliminas el permiso asociado

GRANT INSERT ON logdata TO user_load;
GRANT SELECT ON logdata TO user_load;

COPY INTO [logdata] FROM 'https://datalake2000.blob.core.windows.net/data/parquet/*.parquet' -- "datalake2000" es la cuenta de almacenamiento Data Lake 
WITH																					     -- "data" es el contenedor
(																							 -- "parquet" es un directorio	
FILE_TYPE='PARQUET',
CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='sv=2020-02-10&ss=b&srt=sco&sp=rl&se=2021-07-01T16:07:07Z&st=2021-07-01T08:07:07Z&spr=https&sig=j%2BtdThwbGU83Ol3LyyLHbFZQTMyGauCVtfKbUuUCkLM%3D')
)

SELECT * FROM [logdata]