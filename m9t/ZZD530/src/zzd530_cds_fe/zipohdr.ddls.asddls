@AbapCatalog.sqlViewName: 'ZIPOHDR_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PO HDR'
define view ZIPOHDR as select from ekko {
key ebeln,
    werks_allow,
    bukrs

    
}
