@AbapCatalog.sqlViewName: 'ZCDS_INVDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for invoice data'
define view ZCDS_INVOICE_DATA
  as select from vbrk as a
    join         vbrp as b on a.vbeln = b.vbeln
{
  key a.vbeln,
  key b.posnr,
  a.fkart,
  a.vbtyp,
  @Semantics.currencyCode: true
  a.waerk,
  a.vkorg,
  a.fkdat,
  @Semantics.amount.currencyCode: 'waerk' 
  @DefaultAggregation: #SUM
  a.netwr,
  a.kunag as kunag,
  b.fkimg,
  b.vrkme,
  b.meins,
  b.matnr
  
}
