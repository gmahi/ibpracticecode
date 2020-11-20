@AbapCatalog.sqlViewName: 'ZIPOASSO_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS: Assocition'
define view ZIPOAsso as select from ZIPOHDR
association [1] to ZIPOITEM1_530 as _poitems
    on $projection.ebeln = _poitems.pono {
    ZIPOHDR.ebeln,
    ZIPOHDR.bukrs,
    
    
     // Make association public
     _poitems,
     _poitems.pono,
     _poitems.material
}
