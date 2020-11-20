@AbapCatalog.sqlViewName: 'ZI_BOOKINGU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking View- CDS Data mdel'

@UI:{
   headerInfo:{
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title:{type: #STANDARD, value: 'BookingID'}
   }
}

@Search.searchable: true
define view ZI_BOOKING_U
  as select from /dmo/booking as Booking
  association        to parent ZI_TRAVEL_U as _Travel     on  $projection.TravelID = _Travel.TravelID

  association [1..1] to ZI_CUSTOMER_U      as _Customer   on  $projection.CustomerID = _Customer.CustomerID
  association [1..1] to ZI_CARRIER_U       as _Carrier    on  $projection.AirlineID = _Carrier.AirilineID
  association [1..1] to ZI_CONNECTION      as _Connection on  $projection.AirlineID    = _Connection.AirlineID
                                                          and $projection.ConnectionID = _Connection.ConnectionID


{

      @UI.facet: [{id :'Booking',
                    purpose: #STANDARD,
                    type: #IDENTIFICATION_REFERENCE,
                    label: 'Booking',
                    position: 10
                     }]

      @Search.defaultSearchElement: true
  key Booking.travel_id     as TravelID,

      @UI:{
              lineItem: [{position: 20 , importance: #HIGH}]
         }
      @Search.defaultSearchElement: true

  key Booking.booking_id    as BookingID,

      @UI:{
                lineItem: [{position: 30 , importance: #HIGH}],
                identification: [{position: 30 }]
           }
      Booking.booking_date  as BookingDate,

      @UI:{
            lineItem: [{position: 40 , importance: #HIGH}],
                          identification: [{position: 40 }]
       }
      @Consumption.valueHelpDefinition: [{entity:{name: 'ZI_CUSTOMER_U', element: 'CustomerID'} }]
      @Search.defaultSearchElement: true
      Booking.customer_id   as CustomerID,

      @Consumption.valueHelpDefinition: [{entity:{name: 'ZI_CARRIER', element: 'AirlineID'} }]
      @UI:{
            lineItem: [{position: 50 , importance: #HIGH}],
                          identification: [{position: 50 }]
       }
      @ObjectModel.text.association: '_Carrier'

      Booking.carrier_id    as AirlineID,

      @UI:{
            lineItem: [{position: 60 , importance: #HIGH}],
                          identification: [{position: 60 }]
       }
      @Consumption.valueHelpDefinition: [{entity:{name: 'ZI_FLIGHT_U', element: 'ConnectionID'},
       additionalBinding: [
                           {localElement: 'ConnectionID', element: 'ConnectionID' },
                            {localElement: 'AirlineID', element: 'AirlineID' },
                             {localElement: 'FlightPrice', element: 'Price' },
                              {localElement: 'CurrencyCode', element: 'CurrencyCode' }
       ]
        }]
      @ObjectModel.text.association: '_Connection'
      Booking.connection_id as ConnectionID,


      @UI:{
         lineItem: [{position: 70 , importance: #HIGH}],
                       identification: [{position: 70 }]
      }
      @Consumption.valueHelpDefinition: [{entity:{name: 'ZI_FLIGHT_U', element: 'ConnectionID'},
       additionalBinding: [
                           {localElement: 'ConnectionID', element: 'ConnectionID' },
                            {localElement: 'AirlineID', element: 'AirlineID' },
                             {localElement: 'FlightPrice', element: 'Price' },
                              {localElement: 'CurrencyCode', element: 'CurrencyCode' }
       ]
        }]
      @ObjectModel.text.association: '_Connection'
      Booking.flight_date   as FlightDate,
      @UI:{
          lineItem: [{position: 80 , importance: #HIGH}],
                        identification: [{position: 80 }]
      }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Booking.flight_price  as FlightPrice,

      @Semantics.currencyCode: true
      @Consumption.valueHelpDefinition: [{entity : {name: 'I_Currency', element: 'Currency'} }]
      Booking.currency_code as CurrencyCode,
      _Travel.LastChangedAt, --Take over Etag from Parent

      //Associtations
      _Travel,
      _Customer,
      _Carrier,
      _Connection


}
