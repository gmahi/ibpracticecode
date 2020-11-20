@AbapCatalog.sqlViewName: 'ZIPURCHDOCPRIUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Document Price'
@VDM.viewType: #COMPOSITE
define view Z_I_PurchDocOverallPrice_UM as select from Z_I_PurchaseDocument_UM
association [0..1] to I_Currency  as _Currency
  on $projection.currency = _Currency.Currency {
    //Z_I_PurchaseDocument_UM
    key PruchaseDocument,
    @Semantics.amount.currencyCode: 'Currency'
    @DefaultAggregation: #NONE
    sum(_PurchasedocumentItem.OverallItemPrice)  as OverallPrice,

    PurchaseOrganization,
    
    @Semantics.currencyCode: true
    _PurchasedocumentItem.Currency,
    Description,
    Status,
    Priority,
    
    
    PurchaseDocumentImageURL,
    
    crea_date_time,
    crea_uname,
    lchg_date_time,
    lchg_uname,
    /* Associations */
    //Z_I_PurchaseDocument_UM
    _PurchasedocumentItem,
    _Priority,
    _PurchaseOrgnization,
    _Status,
    _Currency
    
    // Make association public
} 
group by PruchaseDocument,
          _PurchasedocumentItem.Currency,
          PurchaseOrganization,
          Description,
          Status,
          Priority,
          PurchaseDocumentImageURL,
          crea_date_time,
          crea_uname,
          lchg_date_time,
          lchg_uname
          
