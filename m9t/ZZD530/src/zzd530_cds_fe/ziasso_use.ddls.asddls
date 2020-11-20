@AbapCatalog.sqlViewName: 'ZIASSO_USEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS: Use association view'
define view ZIASSO_USE
  as select from ZIPOAsso
{
ebeln,
  bukrs,
  ZIPOAsso._poitems[1:poitem='00010'].poitem
  

}
