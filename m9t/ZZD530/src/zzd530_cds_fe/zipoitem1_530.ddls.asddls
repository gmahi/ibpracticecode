@AbapCatalog:{sqlViewName: 'ZIPOITEM15301',
compiler.compareFilter: true,
preserveKey: true }
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS: PO Items1'
@OData.publish: true
define view ZIPOITEM1_530
  as select from ekpo
{
      @EndUserText.label: 'Purchase order'
  key ebeln                    as pono,
      @EndUserText.label: 'Purchase order Item'
  key ebelp                    as poitem,
    @EndUserText.label: 'Purchase order material'
      matnr                    as material,
        @EndUserText.label: 'Purchase quantity'     
      menge                    as qty,
      meins,
      cast(case meins when 'ST' then 'Pieces' else 'Default'
      end as abap.char( 5 ))   as unitdescription,
      $session.client          as client,
      $session.system_date     as zdate,
      $session.system_language as zlang,
      $session.user            as zuser


}
