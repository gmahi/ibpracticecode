@AbapCatalog.sqlViewName: 'ZCDS_530_CUST_VW'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Demo'
define view Zcds_scust_sbook as select from scustom 
 join sbook
    on scustom.id = sbook.customid {
    scustom.id,
    scustom.name,
    sbook.bookid,
    sbook.agencynum,
    sbook.carrid,
    sbook.connid
}
