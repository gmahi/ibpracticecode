@AbapCatalog.sqlViewName: 'ZIUNIONPO_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Union po'
define view ZIUNIONPO
  as select from ZIPOHDR
{
  //ZIPOHDR
  ebeln                                                as Field1,
  case werks_allow when '' then 'ST'else 'DEFAULT' end as Field2,
  bukrs                                                as Field3

}

union  select from ZIPOITEM_530(p_matnr:'Schaltung-D593')
{
  //ZIPOITEM_530
  pono                             as Field1,
  unitdescription                  as Field2,
  cast(poitem  as abap.char( 4 ) ) as Field3


}
