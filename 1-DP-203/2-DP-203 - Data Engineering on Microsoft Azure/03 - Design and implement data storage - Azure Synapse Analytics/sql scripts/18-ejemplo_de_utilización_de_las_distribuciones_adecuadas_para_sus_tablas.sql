-- Lab - Ejemplo de utilización de las distribuciones adecuadas para sus tablas

DROP TABLE [dbo].[SalesFact]


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
    DISTRIBUTION = HASH (ProductID)
)

-- Crear la tabla de dimensiones con round-robin distribution

DROP TABLE [dbo].[DimProduct]

CREATE TABLE [dbo].[DimProduct](
	[ProductID] [int] NOT NULL,
	[ProductModelID] [int] NOT NULL,
	[ProductSubcategoryID] [int] NOT NULL,
	[ProductName] varchar(50) NOT NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ProductModelName] varchar(50) NULL,
	[ProductSubCategoryName] varchar(50) NULL
)

-- Realice un JOIN en la tabla de hechos y dimensiones

SELECT ft.[ProductID],pd.[ProductName]
FROM [dbo].[SalesFact] ft JOIN [dbo].[DimProduct] pd
ON  ft.[ProductID]=pd.[ProductID]


-- Crear la tabla de dimensiones con replicated distribution

DROP TABLE [dbo].[DimProduct]

CREATE TABLE [dbo].[DimProduct](
	[ProductID] [int] NOT NULL,
	[ProductModelID] [int] NOT NULL,
	[ProductSubcategoryID] [int] NOT NULL,
	[ProductName] varchar(50) NOT NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ProductModelName] varchar(50) NULL,
	[ProductSubCategoryName] varchar(50) NULL
)
WITH  
(   
    DISTRIBUTION = REPLICATE
)