-- Lab - Crear una dimension table
-- Esto lo hacemos en Azure SQL Server
-- Creemos una view para los customers

-- Recordar que una dimension table no debe tener registros nulos

CREATE VIEW Customer_view 
AS
  SELECT ct.[CustomerID],ct.[StoreID],st.[BusinessEntityID],st.[Name]  as StoreName
  FROM [Sales].[Customer] as ct
  LEFT JOIN [Sales].[Store] as st 
  ON ct.[StoreID]=st.[BusinessEntityID]
  WHERE  st.[BusinessEntityID] IS NOT NULL

-- Creemos una customer dimension table

SELECT [CustomerID],[StoreID],[BusinessEntityID],StoreName
INTO DimCustomer
FROM Customer_view 

SELECT * FROM DimCustomer
 _________________________________________________________________
|CustomerID	StoreID	BusinessEntityID	StoreName                   |
|1	        934	    934	              A Bike Store                |
|2	        1028	  1028	            Progressive Sports          |
|3	        642	    642	              Advanced Bike Components    |
|4	        932	    932	              Modular Cycle Systems       |
|5	        1026	  1026	            Metropolitan Sports Supply  |
|6	        644	    644	              Aerobic Exercise Company    |
|7	        930	    930	              Associated Bikes            |
|8	        1024	  1024	            Exemplary Cycles            |
|9	        620	    620	              Tandem Bicycle Store        |
|10	        928	    928	              Rural Cycle Emporium        |
|...        ...     ...               ...                         |
|_________________________________________________________________|

-- Creemos una view para los products

CREATE VIEW Product_view 
AS
SELECT prod.[ProductID],prod.[Name] as ProductName,prod.[SafetyStockLevel],model.[ProductModelID],model.[Name] as ProductModelName,category.[ProductSubcategoryID],category.[Name] AS ProductSubCategoryName
FROM [Production].[Product] prod
LEFT JOIN [Production].[ProductModel] model ON prod.[ProductModelID] = model.[ProductModelID]
LEFT JOIN [Production].[ProductSubcategory] category ON prod.[ProductSubcategoryID]=category.[ProductSubcategoryID]
WHERE prod.[ProductModelID] IS NOT NULL

-- Creemos una product dimension table

SELECT [ProductID],[ProductModelID],[ProductSubcategoryID],ProductName,[SafetyStockLevel],ProductModelName,ProductSubCategoryName
INTO DimProduct
FROM Product_view 

SELECT * FROM DimProduct
 ___________________________________________________________________________________________________________________________________________________
|ProductID	ProductModelID	ProductSubcategoryID	ProductName	                SafetyStockLevel	ProductModelName	          ProductSubCategoryName  |
|680	      6	              14	                  HL Road Frame - Black, 58	  500	              HL Road Frame	              Road Frames             |
|706	      6	              14	                  HL Road Frame - Red, 58	    500	              HL Road Frame	              Road Frames             |
|707	      33	            31	                  Sport-100 Helmet, Red	      4	                Sport-100	                  Helmets                 |
|708	      33	            31	                  Sport-100 Helmet, Black	    4	                Sport-100	                  Helmets                 |
|709	      18	            23	                  Mountain Bike Socks, M	    4	                Mountain Bike Socks	        Socks                   |  
|710	      18	            23	                  Mountain Bike Socks, L	    4	                Mountain Bike Socks	        Socks                   |
|711	      33	            31	                  Sport-100 Helmet, Blue	    4	                Sport-100	                  Helmets                 |  
|712	      2	              19	                  AWC Logo Cap	              4	                Cycling Cap	                Caps                    |  
|713	      11	            21	                  Long-Sleeve Logo Jersey, S	4	                Long-Sleeve Logo Jersey	    Jerseys                 |
|714	      11	            21	                  Long-Sleeve Logo Jersey, M	4	                Long-Sleeve Logo Jersey	    Jerseys                 |  
|...        ...             ...                   ...                         ...               ...                         ...                     |
|___________________________________________________________________________________________________________________________________________________|


-- Si quieres eliminar las views y las tables

DROP VIEW Customer_view 

DROP TABLE DimCustomer

DROP VIEW Product_view 

DROP TABLE DimProduct