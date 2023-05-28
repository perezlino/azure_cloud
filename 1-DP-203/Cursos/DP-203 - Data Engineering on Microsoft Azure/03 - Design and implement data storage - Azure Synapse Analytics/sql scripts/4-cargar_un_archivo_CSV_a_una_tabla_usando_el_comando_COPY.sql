-- Lab - Cargar datos a una tabla dentro del Dedicated SQL Pool - COPY Command - CSV

-- Nunca uses la admin account para operaciones de carga de datos.
-- Crear un usuario por separado para las operaciones de carga


-- Debe ejecutarse sobre la base de datos "master"
CREATE LOGIN user_load WITH PASSWORD = 'Azure@123';

-- Privilegios que tendrá el usuario que estamos creando 
-- Esto debe ejecutarse sobre la base de datos propia del Dedicated SQL Pool, en este caso sobre "newpool" que 
-- es el nombre que le dimos
CREATE USER user_load FOR LOGIN user_load;
GRANT ADMINISTER DATABASE BULK OPERATIONS TO user_load;
GRANT CREATE TABLE TO user_load;
GRANT ALTER ON SCHEMA::dbo TO user_load;

-- Podemos definir los recursos que queremos asignar al grupo.
-- Esto debe ejecutarse sobre la base de datos propia del Dedicated SQL Pool, en este caso sobre "newpool" que 
-- es el nombre que le dimos
CREATE WORKLOAD GROUP DataLoads
WITH ( 
    MIN_PERCENTAGE_RESOURCE = 100
    ,CAP_PERCENTAGE_RESOURCE = 100
    ,REQUEST_MIN_RESOURCE_GRANT_PERCENT = 100
    );

-- En el "Classifier" estoy diciendo que para este "Workload group" en particular, asigne este nuevo usuario.
-- Esto debe ejecutarse sobre la base de datos propia del Dedicated SQL Pool, en este caso sobre "newpool" que 
-- es el nombre que le dimos
CREATE WORKLOAD CLASSIFIER [ELTLogin]
WITH (
        WORKLOAD_GROUP = 'DataLoads'
    ,MEMBERNAME = 'user_load'
);

-- Eliminar la tabla externa si existe
DROP EXTERNAL TABLE logdata

-- Crear una tabla normal
-- Inicie sesión con el nuevo usuario y cree la tabla
-- Aqui agregue más constraints cuando se trata de la amplitud del tipo de datos

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

-- Conceder los privilegios necesarios al nuevo usuario
-- Esto lo ejecutamos desde la sesión del admin

GRANT INSERT ON logdata TO user_load;
GRANT SELECT ON logdata TO user_load;

-- Ahora inicie sesión como el nuevo usuario
-- La opción FIRSTROW ayuda a garantizar que la primera fila del encabezado no forme parte de la implementación de COPY.
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest&preserve-view=true


SELECT * FROM [logdata]

-- Aquí no hay autenticación/autorización, por lo que debe permitir el acceso público al contenedor.
COPY INTO logdata FROM 'https://datalake2000.blob.core.windows.net/data/raw/Log.csv' -- "datalake2000" es la cuenta de almacenamiento Data Lake
WITH 																			     -- "data" es el contenedor
(																					 -- "raw" es el directorio
FIRSTROW=2
)