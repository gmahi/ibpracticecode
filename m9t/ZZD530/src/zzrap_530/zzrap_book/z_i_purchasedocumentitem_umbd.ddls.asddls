@AbapCatalog.sqlViewName: 'ZIPDOCITEM_BD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Document Item  for BD'
@VDM.viewType: #COMPOSITE
define view Z_I_PurchaseDocumentItem_UMBD
  as select from Z_I_PurchaseDocumentItem_UM
  association to parent Z_I_PurchaseDocument_UMBD as _PurchaseDocument  on
  $projection.PurchaseDocument = _PurchaseDocument.PruchaseDocument
{
      //Z_I_PurchaseDocumentItem_UM
  key PurchaseDocumentItem,
  key PurchaseDocument,
      Description,
      Price,
      Currency,
      Quantity,
      OverallItemPrice,
      QuantityUnit,
      Vendor,
      VendorType,
      purchasedocumentitemimageurl,
      crea_date_time,
      crea_uname,
      lchg_date_time,
      lchg_uname,
      /* Associations */
      //Z_I_PurchaseDocumentItem_UM
      _Currency,
      _PurchaseDocument,
      _QuantityUnitOfMeasure

}
