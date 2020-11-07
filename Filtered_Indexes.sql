use AdventureWorks2016

--Percentage of Null values in our column
--Used to represent how much we will save with a filtered index in place

SELECT ((COUNT(*)-COUNT(EndDate)) * 100.0/COUNT(*)) 
FROM Production.BillOfMaterials

--Create a Non Clustered Filtered Index
CREATE NONCLUSTERED INDEX BillOfMaterialsWithEndDate_Filtrado
ON Production.BillOfMaterials (ComponentID, StartDate)  
WHERE EndDate IS NOT NULL ;  
GO  

--Creare a Non Clustered Un-Filtered Index
CREATE NONCLUSTERED INDEX BillOfMaterialsWithEndDate_SinFiltro 
ON Production.BillOfMaterials (ComponentID, StartDate)  
GO  

--Comparing sizes between them
SELECT i.[name] AS IndexName
    ,SUM(s.[used_page_count]) * 8 AS IndexSizeKB
FROM sys.dm_db_partition_stats AS s
INNER JOIN sys.indexes AS i ON s.[object_id] = i.[object_id]
    AND s.[index_id] = i.[index_id]
WHERE i.name LIKE 'BillOfMaterialsWithEndDate%'
GROUP BY i.[name]
ORDER BY i.[name]
GO

--Issuing a query that uses our Filtered Index
USE AdventureWorks2016;  
GO  
SELECT ProductAssemblyID, ComponentID, StartDate   
FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL   
    AND ComponentID = 5   
    AND StartDate > '01/01/2008' ;  
GO  