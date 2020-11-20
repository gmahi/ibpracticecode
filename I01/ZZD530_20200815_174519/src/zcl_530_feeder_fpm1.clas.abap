CLASS zcl_530_feeder_fpm1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_fpm_guibb_list.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_530_feeder_fpm1 IMPLEMENTATION.
  METHOD if_fpm_guibb_list~check_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~flush.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~get_data.
    DATA lt_where_tab TYPE rsds_where_tab.

    IF iv_eventid->mv_event_id EQ 'FPM_START'.

      SELECT * FROM sflight INTO TABLE @DATA(lt_flight).
      ct_data = lt_flight.
      ev_data_changed = abap_true.
    ELSEIF iv_eventid->mv_event_id EQ 'EV_SEARCH_CRITERIA' .
      CLEAR ct_data.
      iv_eventid->mo_event_data->get_value(
        EXPORTING
          iv_key   = 'SEARCH_CRITERIA'
        IMPORTING
          ev_value = lt_where_tab
      ).
      SELECT * FROM sflight INTO TABLE @lt_flight WHERE (lt_where_tab).
      ct_data = lt_flight.
      ev_data_changed = abap_true.

    ENDIF.




  ENDMETHOD.

  METHOD if_fpm_guibb_list~get_default_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~get_definition.
    DATA: lt_flight            TYPE STANDARD TABLE OF sflight,
          ls_field_description LIKE LINE OF et_field_description.
    eo_field_catalog = CAST #( cl_abap_tabledescr=>describe_by_data( p_data = lt_flight ) ).
    DATA(lo_sflight_descr) = CAST cl_abap_structdescr( eo_field_catalog->get_table_line_type( ) ).

    et_field_description = VALUE #( FOR <ls_sflight_line_descr> IN  lo_sflight_descr->components
                                        ( name = <ls_sflight_line_descr>-name
                                          allow_aggregation = abap_true
                                          allow_filter = abap_true
                                          allow_sort = abap_true )
                                    ).



  ENDMETHOD.

  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~process_event.

  ENDMETHOD.

ENDCLASS.
