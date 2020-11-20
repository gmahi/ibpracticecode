@AbapCatalog.sqlViewName: 'ZI_FLIGHTU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight View- CDS Data mdel'
define view ZI_FLIGHT_U
  as select from /dmo/flight as Flight
{
      //Flight
  key Flight.carrier_id     as AilrlinrID,
  key Flight.connection_id  as ConnectionID,
  key Flight.flight_date    as FlightDate,
      Flight.price          as Price,
      @Semantics.currencyCode: true
      Flight.currency_code  as CurrencyCode,
      Flight.plane_type_id  as PlaneType,
      Flight.seats_max      as MaximumSeats,
      Flight.seats_occupied as OccupiedSeats

}
