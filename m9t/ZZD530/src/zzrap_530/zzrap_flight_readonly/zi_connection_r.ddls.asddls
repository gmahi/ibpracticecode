@AbapCatalog.sqlViewName: 'ZI_CONNECTIONR_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Read only:E2E Data model connection'

@UI.headerInfo.typeNamePlural: 'Connections'
@UI.headerInfo.typeName: 'Connection'
@Search.searchable: true //*** exposes a standard search field on the UI
define view ZI_CONNECTION_R
  as select from /dmo/connection
  association [1..*] to ZI_Flight_R as _Flight  on  $projection.AirlineID    = _Flight.AirlineID
                                                and $projection.ConnectionID = _Flight.ConnectionID
  association [1]    to ZI_CARRIER  as _Airline on  $projection.AirlineID = _Airline.AirlineID
{
      ///dmo/connection
      @UI.facet: [{
      id: 'Connection',
      purpose: #STANDARD,
      type:#IDENTIFICATION_REFERENCE,
      label: 'Connection' ,
      position: 10 },
      {
      id: 'Flight',
      purpose: #STANDARD,
      type: #LINEITEM_REFERENCE,
      label: 'Flight',
      position: 20,
      targetElement: '_Flight'
      }
      ]



      @UI.lineItem: [{position: 10, label: 'Airline' }]
      @UI.identification: [{position: 10, label: 'Airline' }]
      @EndUserText.quickInfo: 'Airline that operates the flight'
      @ObjectModel.text.association: '_Airline'
      @Search.defaultSearchElement: true
  key carrier_id      as AirlineID,

      @UI.lineItem: [{position: 20, label: 'Connection Number' }]
      @UI.identification: [{position: 20, label: 'Connection Number' }]
  key connection_id   as ConnectionID,

      @UI.lineItem: [{position: 30, label: 'Departure Airport Code' }]
      @UI.selectionField: [{position: 10 }]
      @UI.identification: [{position: 30, label: 'Departure Airport Code' }]
      @EndUserText.label: 'Departure Airport Code'
      @Consumption.valueHelpDefinition: [{entity:{name: 'ZI_AIRPORT', element: 'AirportID' } }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      airport_from_id as DepartureAirport,

      @UI.lineItem: [{position: 40, label: 'Destination Airport Code' }]
      @UI.selectionField: [{position: 20 }]
      @UI.identification: [{position: 40, label: 'Destination Airport Code' }]
      @EndUserText.label: 'Destination Airport Code'
      @Consumption.valueHelpDefinition: [{entity:{name: 'ZI_AIRPORT', element: 'AirportID' } }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      airport_to_id   as DestinationAirport,

      @UI.lineItem: [{position: 50, label: 'Departure Time' }]
      @UI.identification: [{position: 50, label: 'Departure Time' }]

      departure_time  as DepartureTime,
      @UI.lineItem: [{position: 60, label: 'Arrival Time' }]
      @UI.identification: [{position: 60, label: 'Arrival Time' }]

      arrival_time    as ArrivalTime,
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      @UI.identification: [{position: 70, label: 'Distance' }]

      distance        as Distance, //** secondary information, not to be displayed on list report entry page
      @Semantics.unitOfMeasure: true
      distance_unit   as DistanceUnit, //** secondary information, not to be displayed on list report entry page

      // Associtations
      @Search.defaultSearchElement: true
      _Flight,
      _Airline
}
