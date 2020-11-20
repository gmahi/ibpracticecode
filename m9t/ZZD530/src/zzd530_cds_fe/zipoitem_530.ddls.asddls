@AbapCatalog.sqlViewName: 'ZIPOITEM530_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS: PO Items'
define view ZIPOITEM_530
 with parameters
 p_matnr:matnr
  as select from ekpo
{
  key ebeln                  as pono,
  key ebelp                  as poitem,
      matnr                  as material,
      menge                  as qty,
      meins,
      cast(case meins when 'ST' then 'Pieces' else 'Default'
      end as abap.char( 5 )) as unitdescription,
      $session.client as client,
      $session.system_date as zdate,
      $session.system_language as zlang,
      $session.user as zuser


} where matnr = $parameters.p_matnr;
