@AbapCatalog.sqlViewName: 'ZDEM_SOI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'List Reporting for sales orders'
@OData.publish: true

define view ZDEMO_DDL_SALES_ORDER_ITEM
  as select from SEPM_I_SalesOrderItem_E as Item
{
       //Item

  key  Item.SalesOrder                        as SalesOrderID,
  key  Item.SalesOrderItem                    as ItemPosition,
       Item._SalesOrder._Customer.CompanyName as CompanyName,
       Item.Product                           as Product,
       @Semantics.currencyCode: true
       Item.TransactionCurrency               as CurrencyCode,
       @Semantics.amount.currencyCode: 'CurrencyCode'
       Item.GrossAmountInTransacCurrency      as GrossAmount,
       @Semantics.amount.currencyCode: 'CurrencyCode'
       Item.NetAmountInTransactionCurrency    as NetAmount,
       @Semantics.amount.currencyCode: 'CurrencyCode'
       Item.TaxAmountInTransactionCurrency    as TaxAmount,
       Item.ProductAvailabilityStatus         as ProductAvailabilityStatus




}
