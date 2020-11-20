@AbapCatalog.sqlViewName: 'ZI_CARRIER_RE'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Read only:E2E Data model Carrier'
@Search.searchable: true
define view ZI_CARRIER
  as select from /dmo/carrier as Airline
{
      ///dmo/carrier
  key Airline.carrier_id    as AirlineID,
     @Semantics.text: true
      Airline.name          as Name,
      
      @Semantics.currencyCode: true     
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Airline.currency_code as CurrencyCode


}
