@AbapCatalog.sqlViewName: 'ZIINNERJOIN_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Inner join'
define view ZIINNERJOIN as select from ZIPOHDR as hdr
inner join ZIPOITEM_530( p_matnr: 'SCHALTUNG-D593') as item
    on hdr.ebeln = item.pono {
    hdr.ebeln,
    item.material,
    item.poitem    
}
