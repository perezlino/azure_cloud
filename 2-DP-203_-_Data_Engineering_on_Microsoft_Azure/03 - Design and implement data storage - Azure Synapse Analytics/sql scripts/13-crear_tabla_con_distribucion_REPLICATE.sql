-- Lab - Crear Replicated Tables

-- Primero, eliminemos la tabla

DROP TABLE [dbo].[SalesFact]

-- Ahora, queremos crear una replicate-distributed table

CREATE TABLE [dbo].[SalesFact](
	[ProductID] [int] NOT NULL,
	[SalesOrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderQty] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[OrderDate] [datetime] NULL,
	[TaxAmt] [money] NULL
)
WITH  
(   
    DISTRIBUTION = REPLICATE
)

-- Para ver la distribución en la tabla
DBCC PDW_SHOWSPACEUSED('[dbo].[SalesFact]')

-- Si ejecuta la siguiente consulta
SELECT [CustomerID], COUNT([CustomerID]) as COUNT FROM [dbo].[SalesFact]
GROUP BY [CustomerID]
ORDER BY [CustomerID]