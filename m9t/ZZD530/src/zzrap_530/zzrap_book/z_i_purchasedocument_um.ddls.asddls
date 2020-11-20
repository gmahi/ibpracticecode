@AbapCatalog.sqlViewName: 'ZIPURCHDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Document'
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'PruchaseDocument'
@ObjectModel.semanticKey: ['PruchaseDocument']
define view Z_I_PurchaseDocument_UM as select from zpurchdocument 
association [1..*] to Z_I_PurchaseDocumentItem_UM as _PurchasedocumentItem on $projection.PruchaseDocument = _PurchasedocumentItem.PurchaseDocument
association[0..1] to Z_I_PurchaseDocumentPriority as _Priority on $projection.Priority = _Priority.Priority
association[0..1] to Z_I_PurchaseDocumentStatus as _Status on $projection.Status = _Status.Status
association[0..1] to Z_I_PurchasingOrganization as _PurchaseOrgnization on $projection.PurchaseOrganization = _PurchaseOrgnization.PurchasingOrganization

 {
 //zpurchdocument
 @ObjectModel.text.element: ['Description']
 key purchasedocument as PruchaseDocument,
 @Semantics.text: true
 description as Description,
 @ObjectModel.foreignKey.association: '_Status'
 status as Status,
 
  @ObjectModel.foreignKey.association: '_Priority'
 priority as Priority ,
  @ObjectModel.foreignKey.association: '_PurchaseOrgnization'
 purchasingorganization as PurchaseOrganization,
 @Semantics.imageUrl: true
 purchasedocumentimageurl as PurchaseDocumentImageURL,
 crea_date_time,
 crea_uname,
 lchg_date_time,
 lchg_uname,
 
 // Asscitions
 _Priority,
 _PurchaseOrgnization,
 _Status,
 _PurchasedocumentItem
 
    
}
