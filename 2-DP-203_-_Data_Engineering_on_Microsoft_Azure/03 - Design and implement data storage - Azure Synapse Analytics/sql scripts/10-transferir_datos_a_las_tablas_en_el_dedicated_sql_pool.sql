-- Lab - Transferir datos a nuestro Dedicated SQL Pool
-- Se transfiere los datos desde Azure SQL Server a estas nuevas tablas en el Dedicated SQL Pool
-- Se utilizó un pipeline ADF desde Azure Synapse para copiar los datos
-- El desarrollo se explica en la clase "028 Lab - Transfer data to our SQL Pool"

-- Primero asegurémonos de que tenemos las tablas definidas en el Dedicated SQL Pool

CREATE TABLE [dbo].[SalesFact](
	[ProductID] [int] NOT NULL,
	[SalesOrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderQty] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[OrderDate] [datetime] NULL,
	[TaxAmt] [money] NULL
)


CREATE TABLE [dbo].[DimCustomer](
	[CustomerID] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[BusinessEntityID] [int] NOT NULL,
	[StoreName] varchar(50) NOT NULL
)


CREATE TABLE [dbo].[DimProduct](
	[ProductID] [int] NOT NULL,
	[ProductModelID] [int] NOT NULL,
	[ProductSubcategoryID] [int] NOT NULL,
	[ProductName] varchar(50) NOT NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ProductModelName] varchar(50) NULL,
	[ProductSubCategoryName] varchar(50) NULL
)

SELECT * FROM [dbo].[SalesFact]
SELECT COUNT(*) FROM [dbo].[SalesFact]

SELECT * FROM [dbo].[DimCustomer]
SELECT COUNT(*) FROM [dbo].[DimCustomer]

SELECT * FROM [dbo].[DimProduct]
SELECT COUNT(*) FROM [dbo].[DimProduct]

-- Si necesitamos eliminar las tablas

DROP TABLE [dbo].[SalesFact]

DROP TABLE [dbo].[DimCustomer]

DROP TABLE [dbo].[DimProduct]


