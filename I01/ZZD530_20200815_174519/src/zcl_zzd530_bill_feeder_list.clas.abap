CLASS zcl_zzd530_bill_feeder_list DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .



  PUBLIC SECTION.
    INTERFACES: if_fpm_guibb,
              if_fpm_guibb_list.
  PROTECTED SECTION.
  data: gt_billing_doc type zzd530_t_bill_list.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZZD530_BILL_FEEDER_LIST IMPLEMENTATION.


  METHOD if_fpm_guibb_list~check_config.

  ENDMETHOD.


  METHOD if_fpm_guibb_list~flush.

  ENDMETHOD.


  METHOD if_fpm_guibb_list~get_data.

 IF iv_eventid->mv_event_id = if_fpm_guibb_list~gc_event_list_filter.
   ct_data  = gt_billing_doc.
   ev_data_changed = abap_true.
 ENDIF.

  ENDMETHOD.


  METHOD if_fpm_guibb_list~get_default_config.

  ENDMETHOD.


  METHOD if_fpm_guibb_list~get_definition.
  eo_field_catalog ?= cl_abap_tabledescr=>describe_by_name( p_name = 'ZZD530_T_BILL_LIST'  ).

  ENDMETHOD.


  METHOD if_fpm_guibb_list~process_event.
    DATA: lt_fpm_search_criteria TYPE  fpmgb_t_search_criteria,
          ls_rsds                TYPE  rsdsselopt,
          lt_vbeln_range         TYPE zzd530_t_vbeln_range,
          ls_vbeln_range         LIKE LINE OF lt_vbeln_range,
          lt_vkorg_range         TYPE zzd530_t_vkorg_range,
          ls_vkorg_range         LIKE LINE OF lt_vkorg_range,
          lt_vtweg_range         TYPE zzd530_t_vtweg_range,
          ls_vtweg_range         LIKE LINE OF lt_vtweg_range,
          lv_max_num             TYPE i.

    CASE io_event->mv_event_id.
      WHEN if_fpm_guibb_list~gc_event_list_filter .
*        get fpm parameters
        io_event->mo_event_data->get_value(
          EXPORTING
            iv_key   =  'SEL_TAB'
          IMPORTING
            ev_value = lt_fpm_search_criteria
        ).

        io_event->mo_event_data->get_value(
           EXPORTING
             iv_key   =  'MAX_NUM'
           IMPORTING
             ev_value = lv_max_num
         ).

        IF lt_fpm_search_criteria IS NOT INITIAL .

          LOOP AT  lt_fpm_search_criteria ASSIGNING FIELD-SYMBOL(<ls_fpm_search_criteria>).
            CASE <ls_fpm_search_criteria>-search_attribute.
              WHEN 'VBELN'.
                TRY .
                    cl_fpm_guibb_search_conversion=>to_abap_select_option(
                      EXPORTING
                        is_fpm_search_row  =  <ls_fpm_search_criteria>   " GUIBB search: Search operator
*                      io_attr_rtti       =     " Runtime Type Services
                      RECEIVING
                        rs_abap_sel_option = ls_rsds    " ABAP: Selection option (EQ/BT/CP/...)
                    ).
                    MOVE-CORRESPONDING ls_rsds TO ls_vbeln_range.
                    INSERT ls_vbeln_range INTO TABLE lt_vbeln_range.
                  CATCH cx_fpmgb.    "
                ENDTRY.
              WHEN 'VKORG'.
                TRY .
                    cl_fpm_guibb_search_conversion=>to_abap_select_option(
                      EXPORTING
                        is_fpm_search_row  =  <ls_fpm_search_criteria>   " GUIBB search: Search operator
*                      io_attr_rtti       =     " Runtime Type Services
                      RECEIVING
                        rs_abap_sel_option = ls_rsds    " ABAP: Selection option (EQ/BT/CP/...)
                    ).
                    MOVE-CORRESPONDING ls_rsds TO ls_vkorg_range.
                    INSERT ls_vkorg_range INTO TABLE lt_vkorg_range.
                  CATCH cx_fpmgb.    "
                ENDTRY.

              WHEN 'VTWEG'.

                TRY .
                    cl_fpm_guibb_search_conversion=>to_abap_select_option(
                      EXPORTING
                        is_fpm_search_row  =  <ls_fpm_search_criteria>   " GUIBB search: Search operator
*                      io_attr_rtti       =     " Runtime Type Services
                      RECEIVING
                        rs_abap_sel_option = ls_rsds    " ABAP: Selection option (EQ/BT/CP/...)
                    ).
                    MOVE-CORRESPONDING ls_rsds TO ls_vtweg_range.
                    INSERT ls_vtweg_range INTO  TABLE lt_vtweg_range.
                  CATCH cx_fpmgb.    "
                ENDTRY.
            ENDCASE.
          ENDLOOP.
          select * FROM vbrk UP TO lv_max_num ROWS INTO CORRESPONDING FIELDS OF TABLE gt_billing_doc
                WHERE vbeln in lt_vbeln_range
                AND vkorg   In lt_vkorg_range
                AND vtweg in lt_vtweg_range.
         ELSE.
           SELECT * FROM vbrk INTO CORRESPONDING FIELDS OF TABLE gt_billing_doc.

        ENDIF.

      WHEN OTHERS.
    ENDCASE.



  ENDMETHOD.


  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.


  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.
ENDCLASS.
