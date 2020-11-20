*&---------------------------------------------------------------------*
*& Report zr_cds_usage_530
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_cds_usage_530.

SELECT SINGLE * FROM ZCDS_CREQ_STATUS_PARA( p_crequest = '291', p_langu = @sy-langu )
INTO @DATA(ls_crequest).
*
*SELECT SINGLE FROM I_MDGovChangeRequestBasic FIELDS MDGovChangeRequest,MDGovChgReqCreatedByUser, MDGovChgReqDataIsActivated, MDGovChgReqStatus, MDGovChgReqDescription, MDGovChgReqType
*
*


cl_demo_output=>display(
  EXPORTING
    data = ls_crequest
*    name =
).
