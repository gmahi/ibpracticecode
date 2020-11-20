@AbapCatalog.sqlViewName: 'ZDEMO_I_SOI_V'

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Sales Order Items - subnode BO view'

@Search.searchable:       true

@ObjectModel: { 

    semanticKey:  [ 'SalesOrderItem' ],

    writeActivePersistence: 'ZDEMO_SOI',

    createEnabled: true,
    deleteEnabled: true,
    updateEnabled: true,

    writeDraftPersistence: 'ZDEMO_SOID'      -- Draft persistence           
}

define view ZDEMO_I_SalesOrderItem_TP_D
    as select from zdemo_soi as SalesOrderItem

/* Compositional associations    */
association [1..1] to ZDEMO_I_SalesOrder_TP_D   as _SalesOrder on $projection.SalesOrderUUID = _SalesOrder.SalesOrderUUID

/* Cross BO associations         */
association [0..1] to SEPM_I_Product_E          as _Product    on $projection.Product = _Product.Product

/* Associations for value help   */
association [0..1] to SEPM_I_Currency           as _Currency   on $projection.CurrencyCode = _Currency.Currency
{

    @ObjectModel.readOnly: true
    key SalesOrderItem.salesorderitemuuid                   as SalesOrderItemUUID,

    @ObjectModel.readOnly: true
    SalesOrderItem.salesorderuuid                           as SalesOrderUUID,

    @Search.defaultSearchElement: true
    @ObjectModel.readOnly: true
    SalesOrderItem.salesorderitem                           as SalesOrderItem,

    @ObjectModel.foreignKey.association: '_Product'
    @ObjectModel.mandatory: true
    SalesOrderItem.product                                  as Product,

    @ObjectModel.foreignKey.association: '_Currency'
    @Semantics.currencyCode: true
    @ObjectModel.readOnly: true
     SalesOrderItem.currencycode                             as CurrencyCode,

    @Semantics.amount.currencyCode: 'CurrencyCode'
    @ObjectModel.readOnly: true
     SalesOrderItem.grossamount                              as GrossAmount,

    SalesOrderItem.quantity                                 as Quantity,

    /*  Exposed associations  */
    @ObjectModel.association.type: [#TO_COMPOSITION_PARENT, #TO_COMPOSITION_ROOT]
    _SalesOrder,

    _Product,

    _Currency
}
