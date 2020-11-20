
@AbapCatalog.sqlViewName: 'ZDEMO_SOI_VF'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item - Virtual Fields'
    
@Metadata.allowExtensions: true
    
@Search.searchable : true
    
@OData.publish: true
    
define view ZDEMO_C_SOrderItem_VF 
    as select from SEPM_I_SalesOrderItem_E as Item 
{
    
    @Search.defaultSearchElement: true    
    key Item.SalesOrder                         as SalesOrder, 
    
    key Item.SalesOrderItem                     as ItemPosition, 
    
    Item.Product                                as Product, 
    
    @Semantics.currencyCode: true
    Item.TransactionCurrency                    as TransactionCurrency,
    
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Item.GrossAmountInTransacCurrency           as GrossAmount, 
    
    -- Virtual element 
    @ObjectModel.readOnly: true
    @ObjectModel.virtualElement:true
    @ObjectModel.virtualElementCalculatedBy:    'ABAP:ZCL_CALCULATION_DISCOUNT'
    @ObjectModel.filter.transformedBy:          'ABAP:ZCL_FILTER_DISCOUNT'
    @ObjectModel.sort.transformedBy:            'ABAP:ZCL_SORT_DISCOUNT'
    
    cast(0 as abap.curr( 15, 2 ) )              as GrossAmountWithDiscount,  
    
    -- Currency conversion begin 
    @Semantics.currencyCode: true
    cast( 'EUR' as abap.cuky )                  as TargetCurrency,
    
    -- Gross Amount in EUR 
    @Semantics.amount.currencyCode: 'TargetCurrency'
    
    CURRENCY_CONVERSION(
    amount             => Item.GrossAmountInTransacCurrency,
    source_currency    => Item.TransactionCurrency,
    target_currency    => cast( 'EUR' as abap.cuky ),
    exchange_rate_date => cast( '20200901' as abap.dats ),
    error_handling     => 'SET_TO_NULL' )  as ConvertedGrossAmount 
    -- Currency conversion end 
}
