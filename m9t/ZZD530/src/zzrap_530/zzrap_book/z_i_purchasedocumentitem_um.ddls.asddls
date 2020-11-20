@AbapCatalog.sqlViewName: 'ZIPURCHDOCITEMUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Document Item'
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'PurchaseDocumentItem'
@ObjectModel.semanticKey: ['PurchaseDocumentItem','PurchaseDocument']

define view Z_I_PurchaseDocumentItem_UM
  as select from zpurchdocitem
  association [1..1] to Z_I_PurchaseDocument_UM as _PurchaseDocument      on $projection.PurchaseDocument = _PurchaseDocument.PruchaseDocument
  association [0..1] to I_UnitOfMeasure         as _QuantityUnitOfMeasure on $projection.QuantityUnit = _QuantityUnitOfMeasure.UnitOfMeasure
  association [0..1] to I_Currency              as _Currency              on $projection.Currency = _Currency.Currency
{

      //zpurchdocitem
      @ObjectModel.text.element: ['Description']
  key purchasedocumentitem as PurchaseDocumentItem,

      @ObjectModel.foreignKey.association: '_PurchaseDocument'
  key purchasedocument     as PurchaseDocument,
      @Semantics.text: true
      description          as Description,

      @Semantics.amount.currencyCode: 'Currency'
      price                as Price,

      @Semantics.currencyCode: true
      currency             as Currency,

      @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
      @DefaultAggregation: #NONE
      quantity             as Quantity,
      
      @Semantics.amount.currencyCode: 'Currency'
      @DefaultAggregation: #NONE
      quantity * price as OverallItemPrice,

      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_QuantityUnitOfMeasure'
      quantityunit         as QuantityUnit,

      vendor               as Vendor,
      vendortype           as VendorType,

      @Semantics.imageUrl: true
      purchasedocumentitemimageurl,
      crea_date_time,
      crea_uname,
      lchg_date_time,
      lchg_uname,

      // Make association public
      _PurchaseDocument,
      _Currency,
      _QuantityUnitOfMeasure

}
