@AbapCatalog.sqlViewName: 'ZI_CARRIERU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier View- CDS Data mdel'
define view ZI_CARRIER_U
  as select from /dmo/carrier as Airiline
{
      //Airiline
  key Airiline.carrier_id    as AirilineID,

      @Semantics.text: true
      Airiline.name          as Name,

      @Semantics.currencyCode: true
      Airiline.currency_code as CurrencyCode

}
