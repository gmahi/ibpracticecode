@AbapCatalog.sqlViewName: 'ZITRAVEL_U'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel view -CDS data model'

@UI:{
   headerInfo:{typeName: 'Travel', typeNamePlural: 'Travels', title:{type: #STANDARD, value: 'TravelID' } }
}

@Search.searchable: true


define root view ZI_TRAVEL_U
  as select from /dmo/travel as Travel --the trevel is the data source for view

  composition [0..*] of ZI_BOOKING_U  as _Booking
  association [0..1] to ZI_AGENCY_U   as _Agency   on $projection.AgencyID = _Agency.AgencyID
  association [0..1] to ZI_CUSTOMER_U as _Customer on $projection.CustomerID = _Customer.CustomerID
  association [0..1] to I_Currency    as _Currency on $projection.CurrencyCode = _Currency.Currency

{
      //Travel
      @UI.facet: [{id : 'Travel' ,
                   purpose: #STANDARD,
                   type: #IDENTIFICATION_REFERENCE,
                   label: 'Travel',
                   position: 10
                   },

                   {
                   id:'Booking',
                   purpose: #STANDARD,
                   type: #LINEITEM_REFERENCE,
                   label: 'Booking',
                   position: 20,
                   targetElement: '_Booking'
                   }
                                  ]
                                  
                                  


      @UI:{
           lineItem: [{position: 10, importance: #HIGH }], identification:[ { position: 10 } ], selectionField: [{position: 10 }]
      }
      @Search.defaultSearchElement: true
  key travel_id            as TravelID,

      @UI:{
           lineItem: [{position: 20, importance: #HIGH }], identification:[ { position: 20 } ], selectionField: [{position: 20 }]
      }
      @Consumption.valueHelpDefinition: [{entity:{name:'ZI_AGENCY_U', element: 'AgencyID'} }]
      @ObjectModel.text.association: '_Agency'
      @Search.defaultSearchElement: true
      Travel.agency_id     as AgencyID,

      @UI:{
      lineItem: [{position: 30, importance: #HIGH }], identification:[ { position: 30 } ], selectionField: [{position: 30 }]
      }
      @Consumption.valueHelpDefinition: [{entity:{name:'ZI_CUSTOMER_U', element: 'CustomerID'} }]
      @ObjectModel.text.association: '_Customer'
      @Search.defaultSearchElement: true
      Travel.customer_id   as CustomerID,

      @UI: {
        lineItem: [ { position: 40, importance: #MEDIUM } ], identification:[ { position: 40 } ] }
      Travel.begin_date    as BeginDate,
      @UI: {
        lineItem: [ { position: 41, importance: #MEDIUM } ], identification:[ { position: 41 } ] }
      Travel.end_date      as EndDate,

      @UI:{identification: [{position: 42 }]}
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.booking_fee   as BookingFee,

      @UI:{identification: [{position: 43, label: 'Total Price' }]}
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.total_price   as TotalPrice,

      @Semantics.currencyCode: true
      @Consumption.valueHelpDefinition: [{entity:{name: 'I_Currency', element: 'Currency'} }]
      Travel.currency_code as CurrencyCode,

      @UI:{identification: [{position: 45, label: 'Comment' }]}
      Travel.description   as Memo,

      @UI.lineItem: [{position: 50 , importance: #HIGH},
      {type: #FOR_ACTION, dataAction: 'set_status_booked', label: 'Set to Booked' }]
      Travel.status        as Status,
      Travel.lastchangedat as LastChangedAt,

      //Associtations
      _Booking,
      _Agency,
      _Customer,
      _Currency



}
