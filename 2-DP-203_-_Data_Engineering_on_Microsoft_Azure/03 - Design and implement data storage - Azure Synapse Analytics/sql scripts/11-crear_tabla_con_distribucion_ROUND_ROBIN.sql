-- Lab - Crear tablas Round-robin

-- Primero vamos a asegurarnos de que tenemos las tablas definidas en el Dedicated SQL Pool
-- Esta tabla se creo en el Script 10
-- Si no definimos ninguna distribución, por defecto, se crean con una distribución ROUND-ROBIN
-- Se utilizó un pipeline ADF desde Azure Synapse para copiar los datos (Script 10)

CREATE TABLE [dbo].[SalesFact](
	[ProductID] [int] NOT NULL,
	[SalesOrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderQty] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[OrderDate] [datetime] NULL,
	[TaxAmt] [money] NULL
)


-- Para ver la distribución en la tabla
DBCC PDW_SHOWSPACEUSED('[dbo].[SalesFact]')

-- Si ejecuta la siguiente consulta
SELECT [CustomerID], COUNT([CustomerID]) as COUNT FROM [dbo].[SalesFact]
GROUP BY [CustomerID]
ORDER BY [CustomerID]
