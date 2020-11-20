@AbapCatalog.sqlViewName: 'ZV530_WO_STATUS'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for work order status'
define view Z530_WO_STATUS as select from jcds {
key objnr,
stat,
chgnr,
inact
    
}
