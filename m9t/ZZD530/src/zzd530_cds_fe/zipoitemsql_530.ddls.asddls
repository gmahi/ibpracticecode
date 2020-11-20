@AbapCatalog.sqlViewName: 'ZIPOITEMSSQL_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PO Item sql'
define view ZIPOITEMSQL_530 as select from ekpo {
count(*) as totalRows,
count( distinct ebeln ) as uniqueebeln,
min(brtwr) as mingrossprice,
max(brtwr) as maxgrossprice,
avg(brtwr) as avggrossprice
   
} group by mandt
