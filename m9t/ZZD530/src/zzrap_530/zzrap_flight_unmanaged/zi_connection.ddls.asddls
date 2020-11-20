@AbapCatalog.sqlViewName: 'ZI_CONNECTION_U'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection View- CDS Data mdel'
define view ZI_CONNECTION
  as select from /dmo/connection as Connectiion
{
      //Connectiion
  key Connectiion.carrier_id      as AirlineID,
  key Connectiion.connection_id   as ConnectionID,
      Connectiion.airport_from_id as DepartureAirport,
      Connectiion.airport_to_id   as DestionationAirport,
      Connectiion.departure_time  as DepartureTime,
      Connectiion.arrival_time    as ArrivalTime,
      Connectiion.distance        as Distance,
      @Semantics.unitOfMeasure: true
      Connectiion.distance_unit   as DistanceUnit

}
