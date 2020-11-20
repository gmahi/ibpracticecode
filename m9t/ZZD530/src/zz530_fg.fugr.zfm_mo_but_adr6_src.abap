FUNCTION ZFM_MO_BUT_ADR6_SRC.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_TEST_RUN) TYPE  BOOLEAN
*"     REFERENCE(IT_BUT_ADR6_SRC) TYPE  MDC_TT_BUT_ADR6_SRC
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  et_messages =    NEW zcl_con_bp_d530(  )->write_data( it_data = it_but_adr6_src ).

  IF iv_test_run IS NOT INITIAL.
     CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.

ENDFUNCTION.
