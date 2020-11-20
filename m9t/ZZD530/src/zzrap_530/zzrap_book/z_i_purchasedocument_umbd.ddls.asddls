@AbapCatalog.sqlViewName: 'ZIPDOCUMBD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Document IInterface view for BD'
@VDM.viewType: #COMPOSITE
define root view Z_I_PurchaseDocument_UMBD as select from Z_I_PurchDocOverallPrice_UM
composition [0..*] of Z_I_PurchaseDocumentItem_UMBD as _PurchaseDocumentItem
   
    {
    
    //Z_I_PurchDocOverallPrice_UM
    key PruchaseDocument,
    OverallPrice,
    PurchaseOrganization,
    Currency,
    Description,
    Status,
    Priority,
    PurchaseDocumentImageURL,
    crea_date_time,
    crea_uname,
    lchg_date_time,
    lchg_uname,
    /* Associations */
    //Z_I_PurchDocOverallPrice_UM
    _Currency,
    _Priority,
    _PurchasedocumentItem,
    _PurchaseOrgnization,
    _Status
    }
