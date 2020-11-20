@AbapCatalog.sqlViewName: 'ZUPURCHADOCOP_C'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption Purchase document'
@VDM.viewType: #CONSUMPTION
define view Z_C_PurchaseDocumentLrp_UM
  as select from Z_I_PurchDocOverallPrice_UM
{
      //Z_I_PurchDocOverallPrice_UM
  key PruchaseDocument,
      OverallPrice,
      case when OverallPrice >= 0 and OverallPrice < 1000 then 3
           when OverallPrice >= 1000 and OverallPrice <= 10000 then 2
           when OverallPrice > 10000 then 1
           else 0 end                                      as OverallPriceCriticality,
      case when OverallPrice > 1000 then 'X'  else ''  end as IsApprovalRequired,
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
