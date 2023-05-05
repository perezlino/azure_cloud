-- Lab - Creando una Fact Table
-- Creemos primeramente una Vista

  CREATE VIEW [Sales_Fact_View]
  AS
  SELECT dt.[ProductID],dt.[SalesOrderID],dt.[OrderQty],dt.[UnitPrice],hd.[OrderDate],hd.[CustomerID],hd.[TaxAmt]
  FROM [Sales].[SalesOrderDetail] dt
  LEFT JOIN [Sales].[SalesOrderHeader] hd
  ON dt.[SalesOrderID]=hd.[SalesOrderID]

-- Luego creamos la Sales Fact table a partir de la Vista
  
SELECT [ProductID],[SalesOrderID],[CustomerID],[OrderQty],[UnitPrice],[OrderDate],[TaxAmt]
INTO SalesFact
FROM Sales_Fact_View

SELECT * FROM SalesFact
 _______________________________________________________________________________________________
|ProductID	SalesOrderID	CustomerID	OrderQty	UnitPrice	  OrderDate	                TaxAmt    |
|760	      43663	        29565	      1	         419,4589	  2011-05-31 00:00:00.000	    40,2681 |
|710	      43670	        29566	      1	           5,70	    2011-05-31 00:00:00.000	   587,5603 |
|709	      43670	        29566	      2	           5,70	    2011-05-31 00:00:00.000	   587,5603 |
|773	      43670	        29566	      2	        2039,994	  2011-05-31 00:00:00.000	   587,5603 |
|776	      43670	        29566	      1	        2024,994	  2011-05-31 00:00:00.000	   587,5603 |
|715	      43681	        29661	      6	          28,8404	  2011-05-31 00:00:00.000	  1323,0668 |
|762	      43681	        29661	      5	         419,4589	  2011-05-31 00:00:00.000	  1323,0668 |  
|732	      43681	        29661	      1	         356,898	  2011-05-31 00:00:00.000	  1323,0668 |
|707	      43681	        29661	      1	          20,1865	  2011-05-31 00:00:00.000	  1323,0668 |
|729	      43681	        29661	      1	         183,9382	  2011-05-31 00:00:00.000	  1323,0668 |
|708	      43681	        29661	      2	          20,1865	  2011-05-31 00:00:00.000	  1323,0668 |
|...       ...           ...         ...         ...       ...                       ...        |
|_______________________________________________________________________________________________|