-- Lab - Leer archivos JSON en el Serverless SQL Pool

-- Desde Azure Synapse Studio --> Data --> Debemos crear un "Linked" hacia la cuenta de almacenamiento donde
-- se encuentra el archivo, nuestra cuenta es un Azure Data Lake Storage Gen2 --> Navegamos entre contenedores 
-- y directorios y pulsando sobre el archivo --> New SQL Script --> Select TOP 100 rows 

-- Aquí utilizamos la función OPENROWSET

SELECT TOP 100
    jsonContent
FROM
    OPENROWSET(
        BULK 'https://appdatalake7000.dfs.core.windows.net/data/log.json',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    )
    WITH (
        jsonContent varchar(MAX)
    ) AS [rows]


-- La sentencia anterior sólo devuelve todo como una sola cadena línea por línea
 ______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
|jsonContent                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |                                             
|--------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                            |                                         
|{"Id":35858,"Correlationid":"7104e9d9-944e-4195-a312-2240dcb9de9d","Operationname":"Delete VirtualNetworkGatewayConnection","Status":"Succeeded","Eventcategory":"Administrative","Level":"Informational","Time":"2021-03-22T19:04:18.069","Subscription":"20c6eec9-2d80-4700-b0f6-4fde579a8783","Eventinitiatedby":"techsup1000@gmail.com","Resourcetype":"Microsoft.Resources/subscriptions/resourceGroups","Resourcegroup":"vpn-grp"}                                      | 
|{"Id":17934,"Correlationid":"541734f1-e2a7-441b-87e8-88b4a540e88e","Operationname":"Delete database accounts","Status":"Succeeded","Eventcategory":"Administrative","Level":"Informational","Time":"2021-05-01T18:24:17.175","Subscription":"20c6eec9-2d80-4700-b0f6-4fde579a8783","Eventinitiatedby":"techsup1000@gmail.com","Resourcetype":"Microsoft.DocumentDB/databaseAccounts","Resourcegroup":"new-grp"}                                                               |         
|{"Id":1,"Correlationid":"66641e13-d19f-4ce5-aafd-9d5d7befa557","Operationname":"Delete SQL database","Status":"Succeeded","Eventcategory":"Administrative","Level":"Informational","Time":"2021-06-15T04:44:38.223","Subscription":"20c6eec9-2d80-4700-b0f6-4fde579a8783","Eventinitiatedby":"Microsoft Azure Synapse Resource Provider","Resourcetype":"Microsoft.Sql/servers/databases","Resourcegroup":"synapseworkspace-managedrg-bd2eb25e-aba7-4f43-a25e-d8757194930d"}  | 
|{"Id":35859,"Correlationid":"7104e9d9-944e-4195-a312-2240dcb9de9d","Operationname":"Delete Virtual Machine","Status":"Succeeded","Eventcategory":"Administrative","Level":"Informational","Time":"2021-03-22T19:04:18.761","Subscription":"20c6eec9-2d80-4700-b0f6-4fde579a8783","Eventinitiatedby":"techsup1000@gmail.com","Resourcetype":"Microsoft.Resources/subscriptions/resourceGroups","Resourcegroup":"vpn-grp"}                                                      | 
|{"Id":35860,"Correlationid":"7104e9d9-944e-4195-a312-2240dcb9de9d","Operationname":"Delete Virtual Machine","Status":"Succeeded","Eventcategory":"Administrative","Level":"Informational","Time":"2021-03-22T19:04:19.473","Subscription":"20c6eec9-2d80-4700-b0f6-4fde579a8783","Eventinitiatedby":"techsup1000@gmail.com","Resourcetype":"Microsoft.Resources/subscriptions/resourceGroups","Resourcegroup":"vpn-grp"}                                                      |
|...                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |                      
|______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|


-- A continuación podemos convertir a columnas separadas


SELECT 
   CAST(JSON_VALUE(jsonContent,'$.Id') AS INT) AS Id,
   JSON_VALUE(jsonContent,'$.Correlationid') As Correlationid,
   JSON_VALUE(jsonContent,'$.Operationname') AS Operationname,
   JSON_VALUE(jsonContent,'$.Status') AS Status,
   JSON_VALUE(jsonContent,'$.Eventcategory') AS Eventcategory,
   JSON_VALUE(jsonContent,'$.Level') AS Level,
   CAST(JSON_VALUE(jsonContent,'$.Time') AS datetimeoffset) AS Time,
   JSON_VALUE(jsonContent,'$.Subscription') AS Subscription,
   JSON_VALUE(jsonContent,'$.Eventinitiatedby') AS Eventinitiatedby,
   JSON_VALUE(jsonContent,'$.Resourcetype') AS Resourcetype,
   JSON_VALUE(jsonContent,'$.Resourcegroup') AS Resourcegroup
FROM
    OPENROWSET(
        BULK 'https://appdatalake7000.dfs.core.windows.net/data/log.json',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    )
    WITH (
        jsonContent varchar(MAX)
    ) AS [rows]
