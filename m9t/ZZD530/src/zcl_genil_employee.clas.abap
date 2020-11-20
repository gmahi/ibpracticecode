CLASS zcl_genil_employee DEFINITION
  PUBLIC
  INHERITING FROM cl_wcf_genil_abstr_component
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS if_genil_appl_intlay~get_dynamic_query_result
        REDEFINITION.
    METHODS if_genil_appl_intlay~get_objects REDEFINITION.
    METHODS if_genil_applmodel_persistency~get_comp_design_time_props
        REDEFINITION .
    METHODS if_genil_applmodel_persistency~save_dquery_options
        REDEFINITION .
    METHODS if_genil_applmodel_persistency~save_model
        REDEFINITION .
    METHODS if_genil_applmodel_persistency~save_object_props
        REDEFINITION .
    METHODS if_genil_applmodel_persistency~transport_component
        REDEFINITION .
    METHODS if_genil_applmodel_persistency~save_component_props
        REDEFINITION .
    METHODS search_employee IMPORTING it_search_criteria TYPE genilt_selection_parameter_tab
                                      iv_max_hists       TYPE genilt_unsigned_int4
                            EXPORTING et_results         TYPE zttbol_empl_key.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_genil_employee IMPLEMENTATION.


  METHOD if_genil_applmodel_persistency~get_comp_design_time_props.
*CALL METHOD SUPER->IF_GENIL_APPLMODEL_PERSISTENCY~GET_COMP_DESIGN_TIME_PROPS
*  RECEIVING
*    RS_COMP_DT_PROPS =
*    .
  ENDMETHOD.


  METHOD if_genil_applmodel_persistency~save_component_props.
*CALL METHOD SUPER->IF_GENIL_APPLMODEL_PERSISTENCY~SAVE_COMPONENT_PROPS
*  EXPORTING
*    IV_COMPONENT_NAME  =
*    IS_COMPONENT_PROPS =
**    iv_prefix          =
**    iv_final           =
**  IMPORTING
**    et_messages        =
*    .
  ENDMETHOD.


  METHOD if_genil_applmodel_persistency~save_dquery_options.
*CALL METHOD SUPER->IF_GENIL_APPLMODEL_PERSISTENCY~SAVE_DQUERY_OPTIONS
*  EXPORTING
**    iv_component_name      =
*    IT_DQUERY_ATTR_OPTIONS =
**  IMPORTING
**    et_messages            =
*    .
  ENDMETHOD.


  METHOD if_genil_applmodel_persistency~save_model.
*CALL METHOD SUPER->IF_GENIL_APPLMODEL_PERSISTENCY~SAVE_MODEL
*  EXPORTING
**    iv_component_name =
*    IT_RELATION_DET   =
**    it_wcf_rels       =
**  IMPORTING
**    et_messages       =
*    .
  ENDMETHOD.


  METHOD if_genil_applmodel_persistency~save_object_props.
*CALL METHOD SUPER->IF_GENIL_APPLMODEL_PERSISTENCY~SAVE_OBJECT_PROPS
*  EXPORTING
**    iv_component_name =
*    IT_OBJ_PROPS      =
*    IT_OBJ_PROPS_WCF  =
**  IMPORTING
**    et_messages       =
*    .
  ENDMETHOD.


  METHOD if_genil_applmodel_persistency~transport_component.
*CALL METHOD SUPER->IF_GENIL_APPLMODEL_PERSISTENCY~TRANSPORT_COMPONENT
**  IMPORTING
**    et_messages          =
*  CHANGING
*    CV_TRANSPORT_REQUEST =
*    .
  ENDMETHOD.
  METHOD if_genil_appl_intlay~get_dynamic_query_result.
    DATA: lr_msg_cont     TYPE REF TO cl_crm_genil_global_mess_cont,
          lv_num_hits     TYPE i,
          lt_results      TYPE zttbol_empl_key,
          lv_max_hits     TYPE char5,
          lv_max_hits_tmp TYPE int4,
          lr_root_object  TYPE REF TO if_genil_cont_root_object,
          lt_request_obj  TYPE crmt_request_obj_tab.
    FIELD-SYMBOLS: <fs_results> TYPE zbol_empl_master_key.
* Retrieve the message container to log eventual messages
    lr_msg_cont = iv_root_list->get_global_message_container( ).
* When the max hits is set to 0.
    IF is_query_parameters-max_hits IS INITIAL.
      lv_max_hits_tmp = 100. "100 when no max_hits is set
    ELSE.
      lv_max_hits_tmp = is_query_parameters-max_hits.
    ENDIF.
* select the rigth query
    CASE iv_query_name.
      WHEN 'SearchEmployee'.
* Call the API and get the result.

        CALL METHOD search_employee
          EXPORTING
            it_search_criteria = it_selection_parameters
            iv_max_hists       = lv_max_hits_tmp
          IMPORTING
            et_results         = lt_results.

        IF lt_results IS NOT INITIAL.
* Log a message if search result exceed the max hit limit
          DESCRIBE TABLE lt_results LINES lv_num_hits.
          IF lv_num_hits > lv_max_hits_tmp.
            lv_max_hits = lv_max_hits_tmp.
            lr_msg_cont->add_message( iv_msg_type = 'i'
            iv_msg_id = 'zbol_msg'
            iv_msg_number = '000'
            iv_msg_v1 = lv_max_hits
            iv_show_only_once = abap_true ).
          ENDIF.
* Loop through the results to build search result objects
          LOOP AT lt_results ASSIGNING <fs_results>.
            TRY.
* Try to create a new result object
                lr_root_object = iv_root_list->add_object(
                iv_object_name = 'employee'
                is_object_key = <fs_results> ).
* Flag it as direct query result
                lr_root_object->set_query_root( abap_true ).
              CATCH cx_crm_genil_duplicate_rel cx_crm_genil_model_error.
* Since the given object name is correct this could not happen!
            ENDTRY.
          ENDLOOP.
* Note: The request object restricts the attributes to read.
* If there is no request object entry or the attributes
* table is empty all attributes are requested.
* read the attributes and relation using the GET_OBJECTS
          me->if_genil_appl_intlay~get_objects( it_request_objects = lt_request_obj
          iv_root_list = iv_root_list ).
        ELSE.
          lr_msg_cont->add_message( iv_msg_type = 'w'
          iv_msg_id = 'zbol_msg'
          iv_msg_number = '001'
          iv_show_only_once = abap_true ).
        ENDIF.
      WHEN OTHERS.
        RETURN.
    ENDCASE.



  ENDMETHOD.

  METHOD search_employee.

    DATA: lt_search_criteria TYPE genilt_selection_parameter_tab,
          lv_last_attr_name  TYPE name_komp,
          lv_string          TYPE string.
    DATA(lv_max_hits) = iv_max_hists.
    IF lv_max_hits EQ 0.
      lv_max_hits = 100.
    ENDIF.


    lt_search_criteria = it_search_criteria.
    SORT lt_search_criteria BY attr_name.
    LOOP AT lt_search_criteria ASSIGNING FIELD-SYMBOL(<search_criteria>) .
      IF (  <search_criteria>-option EQ 'CP' OR <search_criteria>-option EQ 'EQ' ).
        IF  lv_string IS NOT INITIAL.
          IF <search_criteria>-attr_name NE lv_last_attr_name.
            CONCATENATE lv_string ') AND (' INTO lv_string SEPARATED BY space.
          ELSE.
            CONCATENATE lv_string 'OR' INTO lv_string SEPARATED BY space.
          ENDIF.
        ELSE.
          lv_string = '('.
        ENDIF.

        CONCATENATE lv_string <search_criteria>-attr_name <search_criteria>-option ''''
              INTO lv_string SEPARATED BY space.
        CONCATENATE lv_string  <search_criteria>-low INTO lv_string.
        CONCATENATE lv_string ''''
                         INTO lv_string.
      ENDIF.
      lv_last_attr_name = <search_criteria>-attr_name.
    ENDLOOP.
    REFRESH et_results.
    IF  lv_string IS NOT INITIAL.
      CONCATENATE lv_string ')' INTO lv_string SEPARATED BY space.
    ENDIF.
* retrive data from backend
    zcl_empl_master_api=>search_employee(
      EXPORTING
        iv_string   = lv_string
        iv_max_hits = lv_max_hits
      IMPORTING
        et_results  = et_results
    ).


  ENDMETHOD.

  METHOD if_genil_appl_intlay~get_objects.

    DATA lv_root TYPE REF TO if_genil_cont_root_object.
    DATA lv_empl_key TYPE zbol_empl_master_key.
    DATA lv_empl_att TYPE zbol_empl_master_attr.
    DATA lv_temp_att TYPE zbol_empl_master_attr.
    lv_root = iv_root_list->get_first( ).
    WHILE lv_root IS BOUND.
      lv_root->get_key( IMPORTING es_key = lv_empl_key ).
* Check if attributes should be read
      IF lv_root->check_attr_requested( ) = abap_true.
        zcl_empl_master_api=>read_employee(
        EXPORTING is_empl_key = lv_empl_key
        IMPORTING es_emply_att = lv_empl_att ).
* Return the object only if it still exists
        IF lv_empl_att IS NOT INITIAL.
* Put attributes to the container
          lv_root->set_attributes( lv_empl_att ).
* You could set attribute properties like readonly.
        ENDIF.
      ENDIF.
** check if dependent objects should be read
*    IF lv_root->check_rels_requested( ) = abap_true.
** process the directly dependent objects
*      process_children( it_requested_objects = it_request_objects
*      iv_root = lv_root ).
*    ENDIF.
*    “process foreign relations
*    process_foreign( iv_root = lv_root ).
*    “continue with the loop
      lv_root = iv_root_list->get_next( ).
    ENDWHILE.

  ENDMETHOD.

ENDCLASS.
