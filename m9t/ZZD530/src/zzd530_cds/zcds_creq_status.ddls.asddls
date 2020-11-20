@AbapCatalog.sqlViewName: 'ZV_CREQ_STATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Change request status'
define view ZCDS_CREQ_STATUS as select from usmd120c cr inner join usmd130t st  on cr.usmd_creq_status = st.usmd_creq_status  {
key cr. usmd_crequest as crequest,
key st.langu  as langu,   
st.txtmi   as status 
}
