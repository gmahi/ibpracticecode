CLASS zcl_zzd530_bill_feeder_search DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_fpm_guibb,
      if_fpm_guibb_search.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzd530_bill_feeder_search IMPLEMENTATION.
  METHOD if_fpm_guibb_search~check_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~flush.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_data.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_default_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_definition.
    eo_field_catalog_attr ?= cl_abap_structdescr=>describe_by_name( p_name = 'ZZD530_S_BILL_SEARCH' ). "pass the search structure

  ENDMETHOD.

  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~process_event.

    DATA: lo_fpm        TYPE REF TO if_fpm,
          lr_event_data TYPE REF TO cl_fpm_parameter.
*   when clicked on search button, standard event FPM_EXECUTE_SEARCH is triggered

    CHECK io_event->mv_event_id = if_fpm_guibb_search=>fpm_execute_search.

*  get fpm instance
    lo_fpm = cl_fpm_factory=>get_instance( ).

    lr_event_data = NEW #( ).

    lr_event_data->if_fpm_parameter~set_value(
      EXPORTING
        iv_key   =  'SEL_TAB'
        iv_value = it_fpm_search_criteria
*        ir_value =
    ).

    lr_event_data->if_fpm_parameter~set_value(
  EXPORTING
    iv_key   =  'MAX_NUM'
    iv_value = iv_max_num_results
*        ir_value =
).

*Now raise the event  "FPM_GUIBB_LIST_FILTER" which will be handled in the list feeder class
    lo_fpm->raise_event_by_id(
      EXPORTING
        iv_event_id   = if_fpm_guibb_list=>gc_event_list_filter    " This defines the ID of the FPM Event
        io_event_data = lr_event_data    " Property Bag
    ).

  ENDMETHOD.

ENDCLASS.
