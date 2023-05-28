-- Lab - Crear Hash-distributed Tables

-- Primero, eliminemos la tabla

DROP TABLE [dbo].[SalesFact]

-- Ahora, queremos crear una hash-distributed table y establecer la hash-based column sobre Customer ID

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
    DISTRIBUTION = HASH (CustomerID)
)

-- Para ver la distribución en la tabla
DBCC PDW_SHOWSPACEUSED('[dbo].[SalesFact]')

-- Si ejecuta la siguiente consulta
SELECT [CustomerID], COUNT([CustomerID]) as COUNT FROM [dbo].[SalesFact]
GROUP BY [CustomerID]
ORDER BY [CustomerID]