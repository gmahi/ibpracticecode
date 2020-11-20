@AbapCatalog.sqlViewName: 'ZDEMO_C_SO'
  @AccessControl.authorizationCheck: #NOT_REQUIRED
  @EndUserText.label: 'Sales Order for transactional app'
                
  @ObjectModel.semanticKey: 'SalesOrder'
                
  @ObjectModel.transactionalProcessingDelegated: true
                
  @ObjectModel.createEnabled: true
  @ObjectModel.deleteEnabled: true
  @ObjectModel.updateEnabled: true
                
  @UI.headerInfo: { typeName: 'Sales Order', typeNamePlural: 'Sales Orders' }
                
  @OData.publish: true
                
  define view ZDEMO_C_SalesOrder_TX
                
        as select from ZDEMO_I_SalesOrder_TX as Document
  {
                
        @UI.lineItem.position: 10
        @UI.lineItem: [{type: #FOR_ACTION, position:1, dataAction: 'BOPF:SET_TO_PAID', label: 'Set to Paid' }]
        @UI.identification.position: 10
        key Document.SalesOrder,
                
        @UI.lineItem.position: 20
                
        @UI.identification.position: 20
        Document.BusinessPartner,
                
        Document.CurrencyCode,
                
        @UI.lineItem.position: 50
                
        @UI.identification.position: 50
        Document.GrossAmount,
                
        @UI.lineItem.position: 60
                
        @UI.identification.position: 60
        Document.NetAmount,
                
        @UI.lineItem.position: 30
        @UI.selectionField.position: 30
        @UI.identification.position: 30
        Document.BillingStatus,
                
        @UI.lineItem.position: 40
        @UI.selectionField.position: 40
        @UI.identification.position: 40
        Document.OverallStatus,
                
        /* Exposing value via associations */ 
        @UI.lineItem:  { value: '.CompanyName', position: 15 }
        Document._BusinessPartner,
                
        Document._Currency,   
        Document._BillingStatus, 
        Document._OverallStatus   
                
  }                
