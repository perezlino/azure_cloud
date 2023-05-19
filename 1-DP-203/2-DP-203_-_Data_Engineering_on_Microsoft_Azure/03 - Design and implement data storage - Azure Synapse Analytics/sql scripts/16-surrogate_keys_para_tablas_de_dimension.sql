-- Lab - Surrogate keys para tablas de dimension

-- Primero asegurémonos de que tenemos las tablas definidas en el Dedicated SQL Pool
-- Hagamos esto para una tabla de dimensiones

-- Primero elimine la tabla si la tiene en su lugar

DROP TABLE [dbo].[DimProduct]

CREATE TABLE [dbo].[DimProduct](
	[ProductSK] [int] IDENTITY(1,1) NOT NULL,    -- Se agegó este campo
	[ProductID] [int] NOT NULL,
	[ProductModelID] [int] NOT NULL,
	[ProductSubcategoryID] [int] NOT NULL,
	[ProductName] varchar(50) NOT NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ProductModelName] varchar(50) NULL,
	[ProductSubCategoryName] varchar(50) NULL
)