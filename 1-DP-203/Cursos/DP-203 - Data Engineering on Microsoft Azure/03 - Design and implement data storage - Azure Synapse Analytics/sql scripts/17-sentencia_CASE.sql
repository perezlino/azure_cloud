-- Lab - Sentencia CASE

-- Se utilizó un pipeline ADF desde Azure Synapse para copiar los datos a esta tabla
-- Desde Azure Data Lake Storage Gen2 a esta tabla en Azure Synapse
-- Se utilizó el archivo 'product.csv'
-- El archivo no tiene encabezados.

CREATE TABLE [ProductDetails]
(
   [productid] int,
   [productname] varchar(20),
   [productstatus] varchar(1),
   [quantity] int
)


SELECT [productid],[productname], status = CASE [productstatus]
                                                WHEN 'W' THEN 'Warehouse'
                                                WHEN 'S' THEN 'Store'
                                                WHEN 'T' THEN 'Transit'
                                           END
FROM [ProductDetails]