*&---------------------------------------------------------------------*
*& Report zsy_bopf_ro
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsy_bopf_ro.


PARAMETERS: p_lifnr  TYPE lifnr,
            p_create TYPE lifnr,
            p_delete AS CHECKBOX.


DATA: lt_root      TYPE zbo_t_root,
      lt_sel_param TYPE /bobf/t_frw_query_selparam,
      lt_mod       TYPE /bobf/t_frw_modification,
      lr_create    TYPE REF TO zbo_s_root,
      lr_delete    TYPE REF TO zbo_s_root
      .


"Access Service manager

/bobf/cl_tra_serv_mgr_factory=>get_service_manager(
  EXPORTING
    iv_bo_key                     = zif_bo_apf_rom_bopf_c=>sc_bo_key
*    iv_create_sync_notifications  = abap_false
*    iv_create_assoc_notifications = abap_false
*    iv_create_prop_notifications  = abap_false
  RECEIVING
    eo_service_manager            =  DATA(lo_serv_mgr)
).


DATA(lo_trans_mgr)         =     /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).


APPEND INITIAL LINE TO lt_sel_param ASSIGNING FIELD-SYMBOL(<ls_sel_param>).
<ls_sel_param>-attribute_name = zif_bo_apf_rom_bopf_c=>sc_node_attribute-root-owner.
<ls_sel_param>-sign = 'I'.
<ls_sel_param>-option = 'EQ'.
<ls_sel_param>-low = p_lifnr.


*Query

IF p_create IS NOT INITIAL.

  CREATE DATA lr_create .
  lr_create->owner = p_create.
  lr_create->key = /bobf/cl_frw_factory=>get_new_key( ).

  APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<ls_create>).


  <ls_create>-key = lr_create->key.
  <ls_create>-node = zif_bo_apf_rom_bopf_c=>sc_node-root.
  <ls_create>-data = lr_create.
  <ls_create>-change_mode = 'C'.


  lo_serv_mgr->modify(
    EXPORTING
      it_modification =  lt_mod
    IMPORTING
      eo_change       =  DATA(lt_change)
      eo_message      =  DATA(lt_message)
  ).
*CATCH /bobf/cx_frw_contrct_violation.

  lo_trans_mgr->save(

    IMPORTING
      ev_rejected            = DATA(lv_rejected)
      eo_message             = lt_message
  ).

ENDIF.

lo_serv_mgr->query(
  EXPORTING
    iv_query_key            =  zif_bo_apf_rom_bopf_c=>sc_query-root-select_by_elements
*    it_filter_key           =
    it_selection_parameters = lt_sel_param
*    is_query_options        =
    iv_fill_data            = abap_true
*    it_requested_attributes =
  IMPORTING
*    eo_message              =
*    es_query_info           =
    et_data                 = lt_root
    et_key                  = DATA(lt_key)
).
*CATCH /bobf/cx_frw_contrct_violation.


IF p_delete IS NOT INITIAL.
  READ TABLE lt_root INDEX 1 REFERENCE INTO lr_delete.
  lr_delete->owner = p_lifnr.
  APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<fs_del>).
  <fs_del>-node = zif_bo_apf_rom_bopf_c=>sc_node-root.

  IF sy-subrc = 0.
    lo_serv_mgr->modify(
     EXPORTING
       it_modification =  lt_mod
     IMPORTING
       eo_change       =  lt_change
       eo_message      =  lt_message
   ).
*CATCH /bobf/cx_frw_contrct_violation.

    lo_trans_mgr->save(

      IMPORTING
        ev_rejected            = lv_rejected
        eo_message             = lt_message
    ).



  ENDIF.

ENDIF.



cl_demo_output=>display(
  EXPORTING
    data = lt_root
*    name =
).
