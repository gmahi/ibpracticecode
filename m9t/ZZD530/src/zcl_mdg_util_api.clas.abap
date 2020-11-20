CLASS zcl_mdg_util_api DEFINITION PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Constructor
    "! @parameter iv_model |MDG DATA MODEL <p class="shorttext synchronized" lang="en"></p>
    METHODS constructor IMPORTING  iv_model TYPE usmd_model
                        EXCEPTIONS cx_usmd_gov_api .
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns material number for given change request
    "! @parameter iv_crequest | Change Request <p class="shorttext synchronized" lang="en"></p>
    "! @parameter rv_matnr |Material Number <p class="shorttext synchronized" lang="en"></p>
    METHODS get_matnr IMPORTING  iv_crequest     TYPE usmd_crequest
                      RETURNING  VALUE(rv_matnr) TYPE matnr
                      EXCEPTIONS cx_usmd_gov_api
                                 cx_usmd_gov_api_core_error.

    METHODS get_plants_act_cr IMPORTING  iv_crequest     TYPE usmd_crequest
                              RETURNING  VALUE(re_werks) TYPE werks_D
                              EXCEPTIONS cx_usmd_gov_api
                                         cx_usmd_gov_api_core_error.
    METHODS get_entity_data IMPORTING iv_crequest    TYPE usmd_crequest
                                      iv_entity      TYPE usmd_entity
                                      iv_active      TYPE abap_bool
                            EXPORTING rt_entity_data TYPE INDEX TABLE.

    METHODS get_crequest_types_of_user IMPORTING iv_user                 TYPE xubname
                                       RETURNING VALUE(rt_crequest_type) TYPE usmd_ts_crequest_type.
    METHODS get_field_description IMPORTING iv_tabname TYPE ddobjname
                                            iv_fieldname TYPE dfies-fieldname
                                            iv_language  TYPE sy-langu default sy-langu
                                  RETURNING VALUE(rv_description)         TYPE as4text .

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: go_gov_api TYPE REF TO if_usmd_gov_api.
ENDCLASS.



CLASS zcl_mdg_util_api IMPLEMENTATION.
  METHOD constructor.

    cl_usmd_gov_api=>get_instance(
      EXPORTING
        iv_model_name = iv_model
*      iv_classname  = 'CL_USMD_GOV_API'
      RECEIVING
        ro_gov_api    = go_gov_api
    ).

  ENDMETHOD.

  METHOD get_matnr.

    FIELD-SYMBOLS: <ls_key> TYPE any,
                   <lt_key> TYPE INDEX TABLE.

    go_gov_api->create_data_reference(
      EXPORTING
        iv_entity_name = 'MATERIAL'
        iv_struct      = go_gov_api->gc_struct_key
*        it_attribute   =
*        iv_edition     = abap_false
      IMPORTING
        er_structure   = DATA(lr_str_key)
        er_table       = DATA(lr_tab_key)
    ).
    ASSIGN: lr_str_key->* TO <ls_key>,
            lr_tab_key->* TO <lt_key>.

    go_gov_api->get_object_list(
      EXPORTING
        iv_crequest_id          = iv_crequest
    IMPORTING
      et_object_list          = DATA(lt_object_list)
*      et_object_list_db_style =
*      ev_max_seq_no           =
    ).

    LOOP AT lt_object_list INTO DATA(ls_object_list) WHERE entity = 'MATERIAL'.
      ASSIGN ls_object_list-r_struc->* TO <ls_key>.
    ENDLOOP.
    ASSIGN COMPONENT 'MATERIAL' OF STRUCTURE <ls_key> TO FIELD-SYMBOL(<lv_material>).
    rv_matnr = <lv_material>.

  ENDMETHOD.

  METHOD get_plants_act_cr.

    DATA(ls_crequest) = go_gov_api->get_crequest_attributes( iv_crequest_id = iv_crequest ).

    cl_usmd_adapter_provider=>get_chg_document_adapter(
       EXPORTING
         i_usmd_model       = 'MM'    " Data Model
       IMPORTING
         eo_chg_doc_adapter = DATA(lr_adapter)    " Adapter for Access to Change Documents
         et_message         = DATA(lt_messages)    " Messages
       ).


    lr_adapter->read_document_header(
     EXPORTING
       it_uname                =    VALUE #( ( sign = 'I' option = 'EQ'  low = ls_crequest-usmd_created_by  ) )
*      i_date_from              = CONV #( ls_crequest-usmd_changed_at )
*      i_date_to                =  CONV #( ls_crequest-usmd_changed_at )
       it_crequest             = VALUE #(  ( iv_crequest ) )
     IMPORTING
       et_document_header        = DATA(lt_change_request_header)
   ).

    IF  lt_change_request_header IS NOT INITIAL.

      LOOP AT lt_change_request_header INTO DATA(ls_crequest_header) WHERE change_request = iv_crequest.

        lr_adapter->read_document_lines(
         EXPORTING
           is_document_header = ls_crequest_header
         IMPORTING
           et_changed_value   = DATA(lt_keys)
           et_changed_detail  = DATA(lt_changes)    " Change Documents: Change
           et_message         = lt_messages    " Messages
         ).

        LOOP  AT lt_keys INTO DATA(LS_keys) WHERE fieldname = 'WERKS'.
          re_werks = ls_keys-value.
        ENDLOOP.

      ENDLOOP.
    ENDIF.


  ENDMETHOD.

  METHOD get_entity_data.

    FIELD-SYMBOLS: <ls_key> TYPE any,
                   <lt_key> TYPE INDEX TABLE.

    FIELD-SYMBOLS: <lt_entity_data> TYPE INDEX TABLE.

    go_gov_api->create_data_reference(
      EXPORTING
        iv_entity_name = iv_entity
        iv_struct      = go_gov_api->gc_struct_key
*        it_attribute   =
*        iv_edition     = abap_false
      IMPORTING
        er_structure   = DATA(lr_str_key)
        er_table       = DATA(lr_tab_key)
    ).
    ASSIGN: lr_str_key->* TO <ls_key>,
            lr_tab_key->* TO <lt_key>.


    go_gov_api->create_data_reference(
  EXPORTING
    iv_entity_name = iv_entity
    iv_struct      = go_gov_api->gc_struct_key_attr
*        it_attribute   =
*        iv_edition     = abap_false
  IMPORTING
*    er_structure   = DATA(lr_str_key)
    er_table       = DATA(lr_tab_entity)
).
    ASSIGN: lr_tab_entity->* TO <lt_entity_data>.



    go_gov_api->get_object_list(
      EXPORTING
        iv_crequest_id          = iv_crequest
    IMPORTING
      et_object_list          = DATA(lt_object_list)
*      et_object_list_db_style =
*      ev_max_seq_no           =
    ).

    LOOP AT lt_object_list INTO DATA(ls_object_list) .
      ASSIGN ls_object_list-r_struc->* TO  FIELD-SYMBOL(<ls_mat_key>).

    ENDLOOP.

*if <ls_mat_key> is ASSIGNED.
*   ASSIGN COMPONENT 'MATERIAL' of STRUCTURE <ls_mat_key> to FIELD-SYMBOL(<lv_mat>).
*   if  sy-subrc is INITIAL.
*     ASSIGN COMPONENT 'MATERIL' of STRUCTURE <ls_key> TO FIELD-SYMBOL(<lv_value>).
*     if sy-subrc is INITIAL.
*       <lv_value> = <lv_mat>.
*       APPEND <ls_key> to <lt_key>.
*     endif.
*   endif.
*endif.

    MOVE-CORRESPONDING <ls_mat_key> TO <ls_key>.
    APPEND <ls_key> TO <lt_key>.


    go_gov_api->read_entity(
      EXPORTING
        iv_crequest_id   = iv_crequest
        iv_entity_name   = iv_entity
        it_key           = <lt_key>
*      iv_edition       =
*      if_edition_logic = ' '
      if_active_data   = iv_active
    IMPORTING
      et_data          =  <lt_entity_data>
    ).
*  CATCH BEFORE UNWIND cx_usmd_gov_api_core_error.
*  CATCH               cx_usmd_gov_api.

    rt_entity_data = <lt_entity_data>.

  ENDMETHOD.

  METHOD get_crequest_types_of_user.

    DATA: lt_values TYPE STANDARD TABLE OF usvalues,
    lv_crequest_type TYPE usmd_crequest_type.

    CALL FUNCTION 'SUSR_USER_AUTH_FOR_OBJ_GET'
      EXPORTING
        user_name  = iv_user
        sel_object = 'USMD_CREQ'
      TABLES
        values     = lt_values.
    IF sy-subrc =  0.
*
      LOOP AT lt_values INTO DATA(ls_values) WHERE field = 'CREQ_TYPE'.

       lv_crequest_type = ls_values-von.
       APPEND lv_crequest_type to rt_crequest_type.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD get_field_description.

  DATA: lt_dfies TYPE STANDARD TABLE OF dfies.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        =  iv_fieldname
      fieldname      = iv_fieldname
      langu          = sy-langu

    TABLES
      dfies_tab      = lt_dfies

   .
  IF SY-SUBRC = 0.
    rv_description = lt_dfies[ 1 ]-fieldtext.
  ENDIF.



  ENDMETHOD.

ENDCLASS.
