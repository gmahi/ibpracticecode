CLASS zcl_530_feeder_search_uibb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_fpm_guibb_search.
    DATA lo_field_catalog TYPE REF TO cl_abap_structdescr.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_530_feeder_search_uibb IMPLEMENTATION.
  METHOD if_fpm_guibb_search~check_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~flush.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_data.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_default_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_definition.
    DATA: ls_flight TYPE sflight.
    eo_field_catalog_attr = CAST #( cl_abap_structdescr=>describe_by_data( p_data = ls_flight ) ).

    TRY.
        lo_field_catalog ?= eo_field_catalog_attr.
      CATCH cx_sy_move_cast_error.
    ENDTRY.

  ENDMETHOD.

  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~process_event.
    IF io_event->mv_event_id = 'FPM_EXECUTE_SEARCH'.

      DATA(lo_fpm_event_parameters) = NEW cl_fpm_parameter( ).
      TRY.

          cl_fpm_guibb_search_conversion=>to_abap_select_where_tab(
            EXPORTING
              it_fpm_search_criteria =  it_fpm_search_criteria   " search criteria for GUIBB Search
              iv_table_name          =  'SFLIGHT'   " Table Name
              io_field_catalog       = lo_field_catalog    " Runtime Type Services
            IMPORTING
              et_abap_select_table   = DATA(lt_where_string)
          ).

        CATCH cx_fpmgb.
          RETURN.
      ENDTRY.

      lo_fpm_event_parameters->if_fpm_parameter~set_value(
        EXPORTING
          iv_key   =  'SEARCH_CRITERIA'
          iv_value = lt_where_string
*          ir_value =
      ).

      DATA(lo_fpm_event) = NEW cl_fpm_event(
          iv_event_id         =  CONV #( 'EV_SEARCH_CRITERIA' )
          io_event_data       =  lo_fpm_event_parameters
      ).

      cl_fpm=>get_instance( )->raise_event( io_event = lo_fpm_event ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
