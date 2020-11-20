@AbapCatalog.sqlViewName: 'ZI_AIRPORT_RE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Read only:E2E Data model Airport'
define view ZI_AIRPORT as select from /dmo/airport as Airport {

//Airport
key Airport.airport_id as AirportID,
Airport.name as Name,
Airport.city as City,
Airport.country as CountryCode
    
}
