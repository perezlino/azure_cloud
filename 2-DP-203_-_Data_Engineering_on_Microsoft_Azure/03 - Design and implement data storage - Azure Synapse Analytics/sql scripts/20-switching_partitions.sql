-- Lab - Switching partitions

-- Crear una nueva tabla con particiones
-- Switch partitions
-- Esto se puede hacer con el comando Alter. 
-- Pero el comando alter no funcionará si la tabla tiene un clustered column store index
-- Cuando usamos el comando CREATE TABLE AS, necesitamos mencionar un tipo de distribución


CREATE TABLE [logdata_new]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
PARTITION ( [Time] RANGE RIGHT FOR VALUES
            ('2021-05-01','2021-06-01')

   ) ) 
AS
SELECT * 
FROM logdata
WHERE 1=2 -- Nos permite copiar solo la estructura de la tabla logdata

-- Transferimos la particion 2 de la tabla 'logdata' a la tabla 'logdata_new' y aqui será la particion 1
-- La particion 2 en la tabla 'logdata' ya no existe en dicha tabla, ni los datos que se encontraban en esa particion
-- Es como un 'cortar y pegar' la particion en otra tabla
-- Obviamente ambas particiones coinciden, ambas tienen el valor '2021-05-01'

ALTER TABLE [logdata] SWITCH PARTITION 2 TO [logdata_new] PARTITION 1;

SELECT count(*) FROM [logdata_new]

-- Ver los datos en la nueva tabla
-- Contendrá solo los datos de la particion que se le transfirio

SELECT 
   FORMAT(Time,'yyyy-MM-dd') AS dt,
   COUNT(*) 
FROM 
   logdata_new
GROUP BY 
   FORMAT(Time,'yyyy-MM-dd')

-- Ver los datos en la tabla original

SELECT 
   FORMAT(Time,'yyyy-MM-dd') AS dt,
   COUNT(*) 
FROM 
   logdata
GROUP BY 
   FORMAT(Time,'yyyy-MM-dd')