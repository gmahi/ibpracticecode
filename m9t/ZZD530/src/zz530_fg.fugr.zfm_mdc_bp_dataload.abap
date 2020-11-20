FUNCTION ZFM_MDC_BP_DATALOAD.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_BUT000_SRC) TYPE  MDC_TT_BUT000_SRC OPTIONAL
*"     VALUE(IT_BUT020_SRC) TYPE  MDC_TT_BUT020_SRC OPTIONAL
*"     VALUE(IT_BUT_ADR12_SRC) TYPE  MDC_TT_BUT_ADR12_SRC OPTIONAL
*"     VALUE(IT_BUT_ADR2_SRC) TYPE  MDC_TT_BUT_ADR2_SRC OPTIONAL
*"     VALUE(IT_BUT_ADR3_SRC) TYPE  MDC_TT_BUT_ADR3_SRC OPTIONAL
*"     VALUE(IT_BUT_ADR6_SRC) TYPE  MDC_TT_BUT_ADR6_SRC OPTIONAL
*"     VALUE(IT_BUT_ADRC_SRC) TYPE  MDC_TT_BUT_ADRC_SRC OPTIONAL
*"     VALUE(IT_BUT021_FS_SRC) TYPE  MDC_TT_BUT021_FS_SRC OPTIONAL
*"     VALUE(IT_BUT050_SRC) TYPE  MDC_TT_BUT050_SRC OPTIONAL
*"     VALUE(IT_BUT051_SRC) TYPE  MDC_TT_BUT051_SRC OPTIONAL
*"     VALUE(IT_BUT052_SRC) TYPE  MDC_TT_BUT052_SRC OPTIONAL
*"     VALUE(IT_BUT0BK_SRC) TYPE  MDC_TT_BUT0BK_SRC OPTIONAL
*"     VALUE(IT_BUT0ID_SRC) TYPE  MDC_TT_BUT0ID_SRC OPTIONAL
*"     VALUE(IT_BUT0IS_SRC) TYPE  MDC_TT_BUT0IS_SRC OPTIONAL
*"     VALUE(IT_BUT100_SRC) TYPE  MDC_TT_BUT100_SRC OPTIONAL
*"     VALUE(IT_BUR_ADCP_SRC) TYPE  MDC_TT_BUR_ADCP_SRC OPTIONAL
*"     VALUE(IT_BUR_ADR12_SRC) TYPE  MDC_TT_BUR_ADR12_SRC OPTIONAL
*"     VALUE(IT_BUR_ADR2_SRC) TYPE  MDC_TT_BUR_ADR2_SRC OPTIONAL
*"     VALUE(IT_BUR_ADR3_SRC) TYPE  MDC_TT_BUR_ADR3_SRC OPTIONAL
*"     VALUE(IT_BUR_ADR6_SRC) TYPE  MDC_TT_BUR_ADR6_SRC OPTIONAL
*"     VALUE(IT_BUT_ADRP_SRC) TYPE  MDC_TT_BUT_ADRP_SRC OPTIONAL
*"     VALUE(IT_BUT050_TD_SRC) TYPE  MDC_TT_BUT050_TD_SRC OPTIONAL
*"     VALUE(IT_BUT053_SRC) TYPE  MDC_TT_BUT053_SRC OPTIONAL
*"     VALUE(IT_KNA1_AUSP_SRC) TYPE  MDC_TT_KNA1_AUSP_SRC OPTIONAL
*"     VALUE(IT_KNA1_KSSK_SRC) TYPE  MDC_TT_KNA1_KSSK_SRC OPTIONAL
*"     VALUE(IT_KNA1_SRC) TYPE  MDC_TT_KNA1_SRC OPTIONAL
*"     VALUE(IT_KNAS_SRC) TYPE  MDC_TT_KNAS_SRC OPTIONAL
*"     VALUE(IT_KNB1_SRC) TYPE  MDC_TT_KNB1_SRC OPTIONAL
*"     VALUE(IT_KNB5_SRC) TYPE  MDC_TT_KNB5_SRC OPTIONAL
*"     VALUE(IT_KNBW_SRC) TYPE  MDC_TT_KNBW_SRC OPTIONAL
*"     VALUE(IT_KNVI_SRC) TYPE  MDC_TT_KNVI_SRC OPTIONAL
*"     VALUE(IT_KNVP_SRC) TYPE  MDC_TT_KNVP_SRC OPTIONAL
*"     VALUE(IT_KNVV_SRC) TYPE  MDC_TT_KNVV_SRC OPTIONAL
*"     VALUE(IT_LFA1_AUSP_SRC) TYPE  MDC_TT_LFA1_AUSP_SRC OPTIONAL
*"     VALUE(IT_LFA1_KSSK_SRC) TYPE  MDC_TT_LFA1_KSSK_SRC OPTIONAL
*"     VALUE(IT_LFA1_SRC) TYPE  MDC_TT_LFA1_SRC OPTIONAL
*"     VALUE(IT_LFAS_SRC) TYPE  MDC_TT_LFAS_SRC OPTIONAL
*"     VALUE(IT_LFB1_SRC) TYPE  MDC_TT_LFB1_SRC OPTIONAL
*"     VALUE(IT_LFB5_SRC) TYPE  MDC_TT_LFB5_SRC OPTIONAL
*"     VALUE(IT_LFBW_SRC) TYPE  MDC_TT_LFBW_SRC OPTIONAL
*"     VALUE(IT_LFM1_SRC) TYPE  MDC_TT_LFM1_SRC OPTIONAL
*"     VALUE(IT_LFM2_SRC) TYPE  MDC_TT_LFM2_SRC OPTIONAL
*"     VALUE(IT_DFKKBPTAXNUM_SRC) TYPE  MDC_TT_DFKKBPTAXNUM_SRC
*"         OPTIONAL
*"     VALUE(IT_WYT1_SRC) TYPE  MDC_TT_WYT1_SRC OPTIONAL
*"     VALUE(IT_WYT3_SRC) TYPE  MDC_TT_WYT3_SRC OPTIONAL
*"     VALUE(IT_WYT1T_SRC) TYPE  MDC_TT_WYT1T_SRC OPTIONAL
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
  Data: lv_error              TYPE abap_bool,
        lv_table_name         TYPE string,
        ls_message            TYPE bapiret2,
        it_but_adr12_src_conv TYPE TABLE OF but_adr12_src.

  CLEAR lv_error.

  IF it_but000_src IS NOT INITIAL.
    MODIFY but000_src FROM TABLE it_but000_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT000_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT000_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but020_src IS NOT INITIAL.
    MODIFY but020_src FROM TABLE it_but020_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT020_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT020_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but_adr12_src IS NOT INITIAL.
    MOVE-CORRESPONDING it_but_adr12_src TO it_but_adr12_src_conv.
    MODIFY but_adr12_src FROM TABLE it_but_adr12_src_conv.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT_ADR12_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT_ADR12_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but_adr2_src IS NOT INITIAL.
    MODIFY but_adr2_src FROM TABLE it_but_adr2_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT_ADR2_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT_ADR2_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but_adr3_src IS NOT INITIAL.
    MODIFY but_adr3_src FROM TABLE it_but_adr3_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT_ADR3_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT_ADR3_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but_adr6_src IS NOT INITIAL.
    MODIFY but_adr6_src FROM TABLE it_but_adr6_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT_ADR6_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT_ADR6_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but_adrc_src IS NOT INITIAL.
    MODIFY but_adrc_src FROM TABLE it_but_adrc_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT_ADRC_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT_ADRC_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but021_fs_src IS NOT INITIAL.
    MODIFY but021_fs_src FROM TABLE it_but021_fs_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT021_FS_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT021_FS_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but050_src IS NOT INITIAL.
    MODIFY but050_src FROM TABLE it_but050_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT050_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT050_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but051_src IS NOT INITIAL.
    MODIFY but051_src FROM TABLE it_but051_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT051_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT051_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but052_src IS NOT INITIAL.
    MODIFY but052_src FROM TABLE it_but052_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT052_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT052_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but0bk_src IS NOT INITIAL.
    MODIFY but0bk_src FROM TABLE it_but0bk_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT0BK_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT0BK_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but0id_src IS NOT INITIAL.
    MODIFY but0id_src FROM TABLE it_but0id_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT0ID_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT0ID_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but0is_src IS NOT INITIAL.
    MODIFY but0is_src FROM TABLE it_but0is_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT0IS_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT0IS_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but100_src IS NOT INITIAL.
    MODIFY but100_src FROM TABLE it_but100_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT100_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT100_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_bur_adcp_src IS NOT INITIAL.
    MODIFY bur_adcp_src FROM TABLE it_bur_adcp_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUR_ADCP_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUR_ADCP_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_bur_adr12_src IS NOT INITIAL.
    MODIFY bur_adr12_src FROM TABLE it_bur_adr12_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUR_ADR12_SRCC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUR_ADR12_SRCC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_bur_adr2_src IS NOT INITIAL.
    MODIFY bur_adr2_src FROM TABLE it_bur_adr2_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUR_ADR2_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUR_ADR2_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_bur_adr3_src IS NOT INITIAL.
    MODIFY bur_adr3_src FROM TABLE it_bur_adr3_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUR_ADR3_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUR_ADR3_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_bur_adr6_src IS NOT INITIAL.
    MODIFY bur_adr6_src FROM TABLE it_bur_adr6_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUR_ADR6_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUR_ADR6_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but_adrp_src IS NOT INITIAL.
    MODIFY but_adrp_src FROM TABLE it_but_adrp_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT_ADRP_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT_ADRP_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but050_td_src IS NOT INITIAL.
    MODIFY but050_td_src FROM TABLE it_but050_td_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT050_TD_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT050_TD_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_but053_src IS NOT INITIAL.
    MODIFY but053_src FROM TABLE it_but053_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'BUT053_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'BUT053_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_kna1_ausp_src IS NOT INITIAL.
    MODIFY kna1_ausp_src FROM TABLE it_kna1_ausp_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNA1_AUSP_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNA1_AUSP_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_kna1_kssk_src IS NOT INITIAL.
    MODIFY kna1_kssk_src FROM TABLE it_kna1_kssk_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNA1_KSSK_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNA1_KSSK_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_kna1_src IS NOT INITIAL.
    MODIFY kna1_src FROM TABLE it_kna1_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNA1_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNA1_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.


  IF it_knas_src IS NOT INITIAL.
    MODIFY knas_src FROM TABLE it_knas_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNAS_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNAS_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_knb1_src IS NOT INITIAL.
    MODIFY knb1_src FROM TABLE it_knb1_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNB1_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNB1_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_knb5_src IS NOT INITIAL.
    MODIFY knb5_src FROM TABLE it_knb5_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNB5_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNB5_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_knbw_src IS NOT INITIAL.
    MODIFY knbw_src FROM TABLE it_knbw_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNBW_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNBW_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_knvi_src IS NOT INITIAL.
    MODIFY knvi_src FROM TABLE it_knvi_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNVI_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNVI_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_knvp_src IS NOT INITIAL.
    MODIFY knvp_src FROM TABLE it_knvp_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNVP_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNVP_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_knvv_src IS NOT INITIAL.
    MODIFY knvv_src FROM TABLE it_knvv_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'KNVV_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'KNVV_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfa1_ausp_src IS NOT INITIAL.
    MODIFY lfa1_ausp_src FROM TABLE it_lfa1_ausp_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFA1_AUSP_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFA1_AUSP_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfa1_kssk_src IS NOT INITIAL.
    MODIFY lfa1_kssk_src FROM TABLE it_lfa1_kssk_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFA1_KSSK_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFA1_KSSK_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfa1_src IS NOT INITIAL.
    MODIFY lfa1_src FROM TABLE it_lfa1_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFA1_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFA1_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfas_src IS NOT INITIAL.
    MODIFY lfas_src FROM TABLE it_lfas_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFAS_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFAS_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfb1_src IS NOT INITIAL.
    MODIFY lfb1_src FROM TABLE it_lfb1_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFB1_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFB1_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfb5_src IS NOT INITIAL.
    MODIFY lfb5_src FROM TABLE it_lfb5_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFB5_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFB5_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

    IF it_lfbw_src IS NOT INITIAL.
    MODIFY lfbw_src FROM TABLE it_lfbw_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFBW_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFBW_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfm1_src IS NOT INITIAL.
    MODIFY lfm1_src FROM TABLE it_lfm1_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFM1_SRC'.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFM1_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_lfm2_src IS NOT INITIAL.
    MODIFY lfm2_src FROM TABLE it_lfm2_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'LFM2_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'LFM2_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_dfkkbptaxnum_src IS NOT INITIAL.
    MODIFY dfkkbptaxnum_src FROM TABLE it_dfkkbptaxnum_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'DFKKBPTAXNUM_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'DFKKBPTAXNUM_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.


  IF it_wyt1_src IS NOT INITIAL.
    MODIFY wyt1_src FROM TABLE it_wyt1_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'WYT1_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'WYT1_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_wyt3_src IS NOT INITIAL.
    MODIFY wyt3_src FROM TABLE it_wyt3_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'WYT3_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'WYT3_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF it_wyt1t_src IS NOT INITIAL.
    MODIFY wyt1t_src FROM TABLE it_wyt1t_src.
    IF sy-subrc <> 0.
      ls_message-id = '/IBS/MDGI_MSG'.
      ls_message-number = '026'.
      ls_message-type = 'E'.
      ls_message-message_v1 = 'WYT1T_SRC'.
      ls_message-message_v2 = sy-subrc.
      MESSAGE e026(/IBS/MDGI_MSG) INTO ls_message-message WITH 'WYT1T_SRC' sy-subrc.
      APPEND ls_message TO et_messages.
      lv_error = abap_true.
    ENDIF.

  ENDIF.

  IF lv_error IS INITIAL.
    COMMIT WORK.
  ELSE.
    ROLLBACK WORK.
  ENDIF.

ENDFUNCTION.
