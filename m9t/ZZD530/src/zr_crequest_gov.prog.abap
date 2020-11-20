*&---------------------------------------------------------------------*
*& Report zr_crequest_gov
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_crequest_gov.

FIELD-SYMBOLS: <fs_key_tab>  TYPE INDEX TABLE,
               <fs_tab_attr> TYPE INDEX TABLE,
                <lt_data>         TYPE INDEX TABLE,
               <fs_tab_marcbasic> TYPE INDEX TABLE.

DATA: lt_sel      TYPE usmd_ts_sel.
DATA: ls_sel      TYPE usmd_s_sel.

TRY.
    DATA(lo_gov_api) = cl_usmd_gov_api=>get_instance(
                     iv_model_name = 'MM'
                   ).
  CATCH cx_usmd_gov_api.
ENDTRY.

TRY.
    DATA(ls_cr_attributes)  = lo_gov_api->get_crequest_attributes( iv_crequest_id = '866' ).
  CATCH cx_usmd_gov_api_core_error.
  CATCH cx_usmd_gov_api.
ENDTRY.

*cl_demo_output=>display(
*  EXPORTING
*    data = ls_cr_attributes
**    name =
*).
TRY.
    lo_gov_api->create_data_reference(
      EXPORTING
        iv_entity_name = 'MATERIAL'
    iv_struct      =  lo_gov_api->gc_struct_key
*    it_attribute   =
*    iv_edition     = abap_false
      IMPORTING
        er_structure   = DATA(lr_key_str)
        er_table       = DATA(lr_key_tab)
    ).

    lo_gov_api->create_data_reference(
      EXPORTING
        iv_entity_name = 'MATERIAL'
    iv_struct      =  lo_gov_api->gc_struct_key_attr
*    it_attribute   =
*    iv_edition     = abap_false
      IMPORTING
        er_structure   = DATA(lr_str_attr)
        er_table       = DATA(lr_tab_attr)
    ).

  lo_gov_api->create_data_reference(
      EXPORTING
        iv_entity_name = 'MARCBASIC'
    iv_struct      =  lo_gov_api->gc_struct_key_attr
*    it_attribute   =
*    iv_edition     = abap_false
      IMPORTING
        er_structure   = DATA(lr_str_marcbasic)
        er_table       = DATA(lr_tab_marcbasic)
    ).

  CATCH cx_usmd_gov_api.
    EXIT.
ENDTRY.

ASSIGN: lr_key_str->* TO FIELD-SYMBOL(<fs_key_str>),
        lr_key_tab->*   TO      <fs_key_tab>,
        lr_str_attr->* TO FIELD-SYMBOL(<fs_str_attr>),
        lr_tab_attr->*  TO   <fs_tab_attr>,
        lr_str_marcbasic->* to FIELD-SYMBOL(<fs_str_marcbasic>),
        lr_tab_marcbasic->*  to <fs_tab_marcbasic>.

*DATA: lt_data TYPE <fs_tab_attr>.

TRY.


*    lo_gov_api->read_entity(
*      EXPORTING
*        iv_crequest_id   = '241'
*        iv_entity_name   = 'BP_HEADER'
*        it_key           =  <fs_key_tab>
**         iv_edition       =
**         if_edition_logic = ' '
*         if_active_data   = ABAP_TRUE
*      IMPORTING
*        et_data          = <fs_tab_attr>
*    ).

    lo_gov_api->get_object_list(
      EXPORTING
        iv_crequest_id          = '320'
      IMPORTING
        et_object_list          = DATA(lt_object_list)
    et_object_list_db_style =   DATA(lt_object_list_db)
*    ev_max_seq_no           =
    ).


*DATA(ls_key_bp_header) = lt_object_list[ entity = 'BP_HEADER' ]-r_struc.
*ASSIGN ls_key_bp_header->* to <fs_key_str>.
*
*INSERT <fs_key_str> INTO TABLE <fs_key_tab>.
    LOOP AT lt_object_list INTO DATA(ls_object_list).
      ASSIGN ls_object_list-r_struc->* TO <fs_key_str>.
      INSERT <fs_key_str> INTO TABLE <fs_key_tab>.

    ENDLOOP.


cl_usmd_adapter_provider=>get_chg_document_adapter(
      EXPORTING
        i_usmd_model       = 'MM'    " Data Model
      IMPORTING
        eo_chg_doc_adapter = DATA(lr_adapter)    " Adapter for Access to Change Documents
        et_message         = data(lt_messages)    " Messages
      ).


    lr_adapter->read_document_header(
      EXPORTING
        it_uname                =    VALUE #( ( sign = 'I' option = 'EQ'  low = 'D498'  ) )
*

      IMPORTING
        et_document_header        = DATA(lt_change_request_header)
    ).

    LOOP AT lt_change_request_header INTO DATA(ls_header).

*  filter out change requests other than activated

        lr_adapter->read_document_lines(
          EXPORTING
            is_document_header = ls_header
          IMPORTING
            et_changed_value   = DATA(lt_keys)
            et_changed_detail  = data(lt_changes)    " Change Documents: Change
            et_message         = lt_messages    " Messages
          ).



ENDLOOP.


*     cl_usmd_model=>get_instance(
*       EXPORTING
*         i_usmd_model = 'MM'
*       IMPORTING
*         eo_instance  = DATA(LO_ex_model)
*         et_message   = DATA(lt_messages)
*     ).
*
*     lo_ex_model->read_char_value(
*       EXPORTING
*         i_fieldname       = 'USMD_CREQUEST'
*         it_sel            =  VALUE #( ( sign = 'I'  option = 'EQ' low = '320' )
**         if_edition_logic  = 'X'
**         if_use_edtn_slice = space
**         i_readmode        = if_usmd_db_adapter=>gc_readmode_default
**         if_no_flush       = abap_false
*       IMPORTING
*         et_data           =  <lt
*         et_message        = lt
*     ).
*
*

*DATA(conv_api) = cl_usmd_conv_som_gov_api=>get_instance(
*                   iv_model_name = 'MM'
*                   iv_classname  = 'CL_USMD_CONV_SOM_GOV_API'
*                 ).
**                 CATCH cx_usmd_conv_som_gov_api.
**                 CATCH cx_usmd_app_context_cons_error.
**                 CATCH cx_usmd_gov_api.
*
*
*conv_api->set_environment(
*  EXPORTING
*    iv_crequest_id     = '320'
**    iv_crequest_type   =
**    iv_process         =
**    iv_wi_id           =
**    iv_create_crequest =
**    iv_edition         =
*).
*
*conv_api->read_entity_data(
*  EXPORTING
*    iv_struct      = gc_struct_key_attr
*    if_active_data = ABAP_TRUE
**    it_entity_keys =
*    if_select      = abap_true
*  RECEIVING
*    rt_entity_data = DATA(lt_entity_data)
*).
**CATCH BEFORE UNWIND cx_usmd_gov_api_core_error.
**CATCH               cx_usmd_gov_api.
**CATCH cx_usmd_conv_som_gov_api_env.
*    lt_sel = VALUE #( ( sign = 'I'  option = 'EQ' low = <fs_key_str> ) ).
*    lo_gov_api->read_entity(
*      EXPORTING
*        iv_crequest_id   = '866'
*        iv_entity_name   = 'MATERIAL'
*        it_key           =  <fs_key_tab>
**         if_edition_logic = ' '
**         if_active_data   = abap_true
*      IMPORTING
*        et_data          = <fs_tab_marcbasic>
*    ).



lo_gov_api->retrieve_entity(
  EXPORTING
    iv_crequest_id = '866'
    iv_entity_name =  'MARCBASIC'
    it_key         = <fs_key_tab>
*    iv_edition     =
*    if_active_data = ' '
  IMPORTING
    et_data        = <fs_tab_marcbasic>
).

*CATCH BEFORE UNWIND cx_usmd_gov_api_core_error.
*CATCH               cx_usmd_gov_api.


*<fs_str_attr> = <fs_tab_attr>[ 1 ].

*ASSIGN COMPONENT 'MCNAME1' OF STRUCTURE <fs_str_attr> to FIELD-SYMBOL(<fs_name1>).
*
*WRITE:/ 'Name', <fs_name1>.

    lo_gov_api->get_crequest_data(
      EXPORTING
        iv_crequest_id          = '866'
      IMPORTING
      et_entity_data_inactive    = DATA(lt_entity_data)
    ).

*  CATCH BEFORE UNWIND cx_usmd_gov_api_core_error.
*  CATCH               cx_usmd_gov_api.
*ENDTRY.


DATA(ls_bp_key) = lt_entity_data[ usmd_entity = 'MATERIAL' struct = 'KEY' ].
ASSIGN ls_bp_key-r_data->* TO <fs_key_tab>.

*ASSIGN COMPONENT 'BP_HEADER' OF STRUCTURE <fs_key_tab>[ 1 ]  TO FIELD-SYMBOL(<fs_value>).

*WRITE: <fs_value>.
DATA(lr_marcbasic) = lt_entity_data[  usmd_entity = 'MATERIAL' usmd_entity_cont = 'MARCBASIC' ].

 ASSIGN lr_marcbasic-r_data->* TO <fs_tab_marcbasic>.

 LOOP AT <fs_tab_marcbasic> ASSIGNING <fs_str_marcbasic>.
 ASSIGN COMPONENT 'WERKS' OF STRUCTURE <fs_str_marcbasic> to FIELD-SYMBOL(<fs_werks>).
 endloop.

 WRITE: | Plant { <fs_werks> } |.

DATA(lv_matnr) = NEW zcl_mdg_util_api( iv_model = 'MM' )->get_matnr( iv_crequest = 834 ).


*cl_demo_output=>display(
*  EXPORTING
*    data =  <fs_key_str>
**    name =
*).
ENDTRY.
