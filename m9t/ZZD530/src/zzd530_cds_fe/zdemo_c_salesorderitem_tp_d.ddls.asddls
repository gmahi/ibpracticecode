@AbapCatalog.sqlViewName: 'ZDEMO_C_SOI_V'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item - Consumption View'

@Metadata.allowExtensions: true

@Search.searchable: true

@ObjectModel: {
semanticKey: ['SalesOrder'],
    transactionalProcessingDelegated: true,
    createEnabled: true,
    deleteEnabled: true,
    updateEnabled: true
}


define view ZDEMO_C_SalesOrderItem_TP_D
  as select from ZDEMO_I_SalesOrderItem_TP_D as SalesOrderItem
  /* Composition and cross BO associations  */
  association [1..1] to ZDEMO_C_SalesOrder_TP_D as _SalesOrder on $projection.SalesOrderUUID = _SalesOrder.SalesOrderUUID
  association [0..1] to SEPM_I_Product_E        as _Product    on $projection.Product = _Product.Product

  /* Associations for value help            */
  association [0..1] to SEPM_I_Currency         as _Currency   on $projection.CurrencyCode = _Currency.Currency

{

      @ObjectModel.readOnly: true
  key SalesOrderItem.SalesOrderItemUUID,

      @ObjectModel.readOnly: true
      SalesOrderItem.SalesOrderUUID,

      @Search.defaultSearchElement: true
      _SalesOrder.SalesOrder,


      SalesOrderItem.SalesOrderItem,
      SalesOrderItem.Product,
      SalesOrderItem.CurrencyCode,
      SalesOrderItem.GrossAmount,
      SalesOrderItem.Quantity,

      /* Associations */
      //SalesOrderItem
      _Currency,
      _Product,
      @ObjectModel.association.type:  [ #TO_COMPOSITION_ROOT, #TO_COMPOSITION_PARENT ]
      _SalesOrder


}
