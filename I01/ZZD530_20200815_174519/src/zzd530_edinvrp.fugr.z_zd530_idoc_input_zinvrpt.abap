FUNCTION Z_ZD530_IDOC_INPUT_ZINVRPT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) TYPE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) TYPE  BDWFAP_PAR-MASS_PROC
*"  EXPORTING
*"     REFERENCE(WORKFLOW_RESULT) TYPE  BDWFAP_PAR-RESULT
*"     REFERENCE(APPLICATION_VARIABLE) TYPE  BDWFAP_PAR-APPL_VAR
*"     REFERENCE(IN_UPDATE_TASK) TYPE  BDWFAP_PAR-UPDATETASK
*"     REFERENCE(CALL_TRANSACTION_DONE) TYPE  BDWFAP_PAR-CALLTRANS
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"----------------------------------------------------------------------
  DATA: gv_last_id  TYPE  zzd530_edinvrpt-invrptid,
        gt_edinvrpt TYPE STANDARD TABLE OF zzd530_edinvrpt,
        gs_edinvrpt TYPE  zzd530_edinvrpt.
  DATA:
    gs_zivprh TYPE zivprh,
    gs_zivprd TYPE zivprd.

  CLEAR gv_last_id.

  SELECT FROM zzd530_edinvrpt FIELDS MAX( invrptid )
     INTO @gv_last_id.
  ADD 1 TO gv_last_id.
* process Idoc records and format insert INTO internal tab´le
  LOOP AT idoc_contrl INTO DATA(ls_idoc_contrl).
    CLEAR gs_edinvrpt.
*  DATA(ls_idoc_data) = idoc_data[ docnum = ls_idoc_contrl-docnum ].

    LOOP AT idoc_data INTO DATA(ls_idoc_data)  WHERE docnum = ls_idoc_contrl-docnum .
      CASE ls_idoc_data-segnam.
        WHEN 'zivprh'.
          gs_zivprh = idoc_data-sdata.
        WHEN 'zivprd'.
          gs_zivprd = idoc_data-sdata.
          gs_edinvrpt-mandt = sy-mandt.
          gs_edinvrpt-invrptid = gv_last_id.
          gs_edinvrpt-matnr = gs_zivprd-matnr.
          gs_edinvrpt-werks = gs_zivprd-werks.
          gs_edinvrpt-lgort = gs_zivprd-lgort.
          gs_edinvrpt-menge = gs_zivprd-menge.
          gs_edinvrpt-meins = gs_zivprd-meins.
          gs_edinvrpt-credat = gs_zivprh-credat.
          gs_edinvrpt-cretim = gs_zivprh-cretim.
          gs_edinvrpt-updat = sy-datum.
          gs_edinvrpt-uptim = sy-uzeit.
          APPEND gs_edinvrpt TO gt_edinvrpt.
          ADD 1 TO gv_last_id.
      ENDCASE.

    ENDLOOP.
*    Inser Idoc records to table zzd530_edinvrpt.
    MODIFY zzd530_edinvrpt FROM TABLE gt_edinvrpt.
    IF sy-subrc = 0.
*    Success message to status record
      CLEAR idoc_status.
      idoc_status = VALUE #( docnum = idoc_contrl-docnum
                             msgty  = 's'
                             msgid = 'ZEDI01'
                             msgno = '001'
                             status = '53'
                                            ).
    ELSE.

      CLEAR idoc_status.
      idoc_status = VALUE #( docnum = idoc_contrl-docnum
                             msgty  = 'e'
                             msgid = 'ZEDI01'
                             msgno = '002'
                             status = '51'
                                           ).
    ENDIF.

  ENDLOOP.

ENDFUNCTION.
