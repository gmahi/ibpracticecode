@AbapCatalog.sqlViewName: 'ZV_CR_STA_PAR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Change request status with parameters'
define view ZCDS_CREQ_STATUS_PARA
    with parameters P_CREQUEST : usmd_crequest, p_langu : spras
as select from usmd120c cr inner join usmd130t st  on cr.usmd_creq_status = st.usmd_creq_status {
key cr.usmd_crequest,
    cr.usmd_creq_type,
    cr.usmd_edition,
    cr.usmd_creq_status,
    cr.usmd_creq_text,
    cr.usmd_created_at,
    cr.usmd_created_by,
    cr.usmd_changed_at,
    cr.usmd_changed_by,
    cr.usmd_released_at,
    cr.usmd_released_by,
    cr.usmd_data_chn_at,
    cr.usmd_data_active,
    cr.usmd_draft_step,
    cr.usmd_priority,
    cr.usmd_due_date,
    cr.usmd_reason,
    cr.usmd_reason_rej,
    cr.usmd_crequest_re,
    cr.usmd_replic_mode,
    st.langu,
    st.txtmi   
}
where cr.usmd_crequest = $parameters.P_CREQUEST
  and st.langu           = $parameters.p_langu;
